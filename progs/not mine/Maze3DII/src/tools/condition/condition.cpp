/*
condition - a preprocessor for converting high-level logic into assembly
Copyright (C) 2006  Kevin Harness

 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 2 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

*/
#include <unistd.h>
#include <cstdio>
#include <cstdlib>

#ifndef _GNU_SOURCE
#define _GNU_SOURCE
#endif
#include <getopt.h>

#include "condition.h"
using namespace std;

////////////////////////////////
// Globals
FILE* z80in = stdin;
FILE* z80out = stdout;
FILE* z80err = stderr;

int out_lineno=0;
int cond_err=0;

////////////////////////////////
// Error Handling

int line_no = 0;
int line_no_out = 0;
static int error_count = 0;
const char* src_filename = NULL;

void disp_error(int line_number, const char* message) {
	// gcc error format:
	// printf("%s:%d: error: %s", filename, line_number, description);
	fprintf(z80err, "%s:%d: error: %s\n", src_filename, line_number, message);
	error_count++;
}

void disp_error(const char* message) {
	disp_error(line_no, message);
}

int count_newlines(const char* str) {
	int n=0;
	while(str=strchr(str,'\n'))
		str++,n++;
	return n;
}

////////////////////////////////
// Options

static options global_options;

void options::clear() {
	fields=0;
	jump_mode=0;
	iparam=0;
}

bool options::operator^=(const options& o) {
	if(fields&o.fields)
		return false;	// can't combine fields
	fields|=o.fields;
	if(o.fields&OPT_JUMP_MODE)
		jump_mode = o.jump_mode;
	if(o.fields&OPT_IPARAM)
		iparam = o.iparam;
	return true;
}

options options::operator<<(const options& o) const {
	int ef = o.fields&~fields;
	options r = *this;
	r.fields = o.fields|fields;
	if(ef&OPT_JUMP_MODE)
		r.jump_mode = o.jump_mode;
	if(ef&OPT_IPARAM)
		r.iparam = o.iparam;
	return r;
}

int set_global_options(const options& o) {
	if(o.fields & OPT_IPARAM)
		return false;
	global_options = o;
	return true;
}

////////////////////////////////
// Labels

static string label_prefix;
static int free_label_id;

struct label {
	label() : prefix(), id(0) { }
	label(string p, int i=0) : prefix(p), id(i) { }
	label(const label& l) : prefix(l.prefix), id(l.id) { }
	string prefix;
	int id;
	string name() {
		char Buffer[5];
		sprintf(Buffer,"%04X",id&0xFFFF);
		return prefix+Buffer;
	}
};

bool islabel(string l) {
	string::iterator c=l.begin();
	if(!(isalpha(*c)||'_'==*c))
		return false;
	for(c++;c!=l.end();c++)
		if(!(isalnum(*c)||'_'==*c))
			return false;
	return true;
}

////////////////////////////////
// Anonymous Labels

label AnonCur;

string AnonNew() {
	AnonCur.id++;
	return AnonGet(0);
}

string AnonGet(int i) {
	label RetAnon(AnonCur);
	if(i<0) i++;
	RetAnon.id += i;
	return RetAnon.name();
}

////////////////////////////////
// Stack Frames

struct stackframe {
	void create_new(int t);
	label start;
	label end;
	int type;
	operator bool() const;
};

frame_stack global_stack;

void stackframe::create_new(int t) {
	type = t;
	start.prefix = label_prefix;
	start.id = free_label_id++;
	end.prefix = label_prefix;
	end.id = free_label_id++;
}

stackframe::operator bool() const {
	return type!=FRAME_INVALID;
}

stackframe frame_stack::top(int depth) {
	if(depth>st.size()||depth<1) {
		stackframe r;
		r.type = FRAME_INVALID;
		return r;
	}
	return st[st.size()-depth];
}

stackframe frame_stack::top(int depth, int type) {
	int i;
	stackframe r;
	r.type = FRAME_INVALID;
	if(depth>st.size()||depth<1)
		return r;
	for(i=st.size()-1;i>=0;i--)
		if(type==st[i].type)
			if(!--depth)
				return st[i];
	return r;
}

bool frame_stack::pop() {
	if(st.empty())
		return false;
	st.pop_back();
	return true;
}

void frame_stack::push(const stackframe& s) {
	st.push_back(s);
}

////////////////////////////////
// Jumps

static const char* jump_conditions[8] = {
	"nz","z","nc","c","po","pe","p","m"
};

string generate_jump(int cond, string type) {
	return type + ' ' + jump_conditions[cond-COND_NZ]+',';
}

string generate_jump(int cond, int jump_policy) {
	if(COND_UNCOND==(cond&-2)) {
		switch(jump_policy) {
			case OPT_FAR:
			case OPT_SPEED:
				return " jp ";
			case OPT_NEAR:
				return " jr ";
		}
		return "#error bad jump policy\\";
	}
	if(COND_JR(cond)) {
		switch(jump_policy) {
			case OPT_FAR:
				return generate_jump(cond," jp");
			case OPT_SPEED:
			case OPT_NEAR:
				return generate_jump(cond," jr");
		}
		return "#error bad jump policy\\";
	}
	if(COND_JP(cond))
		return generate_jump(cond," jp");
	if(COND_DJNZ == cond)
		return " djnz ";
	disp_error("Invalid condition");
	return "#error invalid condition\\";
}

////////////////////////////////
// Functions

bool process_options(const char* name, const char* value) {
	if(!strcasecmp("PREFIX",name)) {
		label_prefix = value;
		return true;
	}
	if(!strcasecmp("ANONPREFIX",name)) {
		AnonCur.prefix = value;
		return true;
	}
	return false;
}

bool process_directive(directive d, string& r) {
	options eopts = d.opts << global_options;
	int jmode = eopts.jump_mode;
	stackframe sf;
	string l;
	int i;
	r.erase();
	switch(d.id) {
		case JMP_IF:
			d.cond ^= 1;
		case JMP_SKIP:
			sf.create_new(FRAME_IF);
			global_stack.push(sf);
			r = generate_jump(d.cond,jmode) + global_stack.top().end.name();
			return true;
		case JMP_ELSE:
			if(FRAME_IF != global_stack.top().type) {
				r = "Unmatched `else' found";
				return false;
			}
			l = global_stack.top().end.name();
			global_stack.pop();	// remove old `if' frame
			sf.create_new(FRAME_IF);
			global_stack.push(sf);
			r = generate_jump(d.cond,jmode) + global_stack.top().end.name()
				+ '\\' + l + ':';
			return true;
		case JMP_UNTIL:
			d.cond ^= 1;
		case JMP_LOOP:
			if(FRAME_LOOP != global_stack.top().type) {
				r = "Unmatched end of loop";
				return false;
			}
			r = generate_jump(d.cond,jmode) + global_stack.top().start.name() + '\\';
			r += global_stack.top().end.name() + ':';
			global_stack.pop();
			return true;
		case JMP_AGAIN:
			if(!(d.opts.fields&OPT_IPARAM)) d.opts.iparam=1;
			sf = global_stack.top(d.opts.iparam,FRAME_LOOP);
			if(!sf) {
				r = "`again' without corresponding loop";
				return false;
			}
			r = generate_jump(d.cond,jmode) + sf.start.name();
			return true;
		case JMP_BREAK:
			if(!(d.opts.fields&OPT_IPARAM)) d.opts.iparam=1;
			sf = global_stack.top(d.opts.iparam,FRAME_LOOP);
			if(!sf) {
				r = "`break' without corresponding loop";
				return false;
			}
			r = generate_jump(d.cond,jmode) + sf.end.name();
			return true;
		case LBL_ENDIF:
			if(FRAME_IF != global_stack.top().type) {
				r = "Unmatched end of conditional";
				return false;
			}
			r = global_stack.top().end.name() + ':';
			global_stack.pop();
			return true;
		case LBL_DO:
			sf.create_new(FRAME_LOOP);
			global_stack.push(sf);
			r = global_stack.top().start.name() + ':';
			return true;
		case LBL_ENDDO:
			if(FRAME_LOOP != global_stack.top().type) {
				r = "Unmatched end of conditional";
				return false;
			}
			r = global_stack.top().end.name() + ':';
			global_stack.pop();
			return true;
		case JMP_JMP:
			if(!islabel(d.text)) {
				r = "Invalid target label";
				return false;
			}
			r = generate_jump(d.cond,jmode) + d.text;
			return true;
		case JMP_RET:
			if(COND_JP(d.cond)) {
				r = generate_jump(d.cond," ret");
				r.erase(r.end()-1);
				return true;
			}
			if(COND_UNCOND==(d.cond&-2)) {
				r = " ret";
				return true;
			}
			r = "Invalid condition for return";
			return false;
	}
	r = "Illegal directive";
	return false;
}

int process_file(const char* in_filename, const char* out_filename, const char* err_filename) {
	FILE* fin =NULL;
	FILE* fout=NULL;
	FILE* ferr=NULL;
	// setup z80in
	src_filename = in_filename;
	if(!strcmp(in_filename,"stdin"))
		z80in = stdin;
	else {
		if(!(z80in=fin=fopen(in_filename,"r"))) {
			fprintf(stderr,"Error opening `%s' for input\n",in_filename);
			exit(EXIT_FAILURE);
		}
	}
	// setup z80out
	if(!strcmp(out_filename,"stderr"))
		z80out = stderr;
	else if(!strcmp(out_filename,"stdout"))
		z80out = stdout;
	else {
		if(!(z80out=fout=fopen(out_filename,"w"))) {
			fprintf(stderr,"Error opening `%s' for output\n",out_filename);
			exit(EXIT_FAILURE);
		}
	}
	// setup z80err
	if(!strcmp(err_filename,"stderr"))
		z80err = stderr;
	else if(!strcmp(err_filename,"stdout"))
		z80err = stdout;
	else {
		if(!(z80err=ferr=fopen(err_filename,"a"))) {
			fprintf(stderr,"Error opening `%s' for appending\n",err_filename);
			exit(EXIT_FAILURE);
		}
	}

	// Initialize variables
	yyin = z80in;
	line_no = 0;
	line_no_out = 0;
	error_count = 0;
	global_options.clear();
	global_options.fields = OPT_JUMP_MODE;
	global_options.jump_mode = OPT_FAR;
	AnonCur.prefix = "A";
	label_prefix = "C";
	free_label_id = 0;
	
#ifdef YYDEBUG
	yydebug=1;
#endif

	int status = yyparse();

	// TODO: check for unclosed blocks

	if(fin) fclose(fin);
	if(fout) fclose(fout);
	if(ferr) fclose(ferr);
	return status;
}

int usage(const char* prog_name) {
	fprintf(stderr,"%s [-i input] [-o output] [-e error]\n",prog_name);
	fputs("\ti\tinput file, or \"stdin\"\n",stderr);
	fputs("\to\toutput file, or \"stdout\" or \"stderr\"\n",stderr);
	fputs("\te\terror file, or \"stdout\" or \"stderr\"\n",stderr);
}

int main(int argc, char* argv[]) {
	static struct option long_opts[] = {
		{ "output",1,0,'o' },
		{ "input",1,0,'i' },
		{ "error",1,0,'e' },
		{ "help",0,0,'h' }
	};
	int opt;
	const char* prog_name = argv[0];
	const char* in_filename="stdin";
	const char* out_filename="stdout";
	const char* err_filename="stderr";
	while(0<=(opt=getopt_long(argc,argv,"i:o:e:h",long_opts,NULL))) {
		switch(opt) {
			case 'i':
				in_filename=optarg;
				break;
			case 'o':
				out_filename=optarg;
				break;
			case 'e':
				err_filename=optarg;
				break;
			default:
				return usage(prog_name);
				break;
		}
	}
	process_file(in_filename, out_filename, err_filename);
	return (error_count)?1:0;
}

