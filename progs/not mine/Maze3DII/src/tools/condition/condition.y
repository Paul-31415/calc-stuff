%{
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
#include "condition.h"

static string current_statement;

void yyerror(const char* msg) {
	//fprintf(z80err, "YACC: %s\n", msg);
	return;
}



%}


%token <text> LITERAL TERMINATOR
%token <id> LABEL_DIRECTIVE JUMP_DIRECTIVE CONDITION LITERAL_JMP
%token <integer> INTEGER
%token <id> OPT
%token <text> NATIVE UNCLOSED OPTION

%type <opt> option_list
%type <dir> jump_cmd
%type <text> statement
%type <id> optional_cond

%%

lines: /* empty */
	| lines line	{
			}
;

line:
	statement TERMINATOR	{
		// check if this line is terminated by "\n"
		if($2[0]=='\n')
			line_no_out++;
		// sync lines
		for(;line_no_out<line_no;line_no_out++)
			fputc('\n',z80out);
		fputs($1.c_str(),z80out);
		fputs($2.c_str(),z80out);
				}
	| error TERMINATOR	{
		// display unmodified line
		line_no_out += count_newlines(strCurLine.c_str());
		fputs(strCurLine.c_str(),z80out);
		// sync lines
		for(;line_no_out<line_no;line_no_out++)
			fputc('\n',z80out);
		yyerrok;
				}
;

statement:
	option_list LABEL_DIRECTIVE {
		directive d;
		d.id = $2;
		d.cond = COND_UNCOND;
		d.opts = $1;
		if(!process_directive(d,current_statement)) {
			disp_error(current_statement.c_str());
			YYERROR;
		}
		$$=current_statement.c_str();
	}
	| option_list jump_cmd {
		$2.opts = $1;
		string s;
		if(!process_directive($2,current_statement)) {
			disp_error(current_statement.c_str());
			YYERROR;
		}
		$$=current_statement.c_str();
	}
	| OPTION option_list {
		if(!set_global_options($2)) {
			disp_error("Invalid option(s) specified");
			YYERROR;
		}
		$$="";
	}
	| OPTION LITERAL LITERAL {
		if(!process_options($2.c_str(),$3.c_str())) {
			disp_error("Invalid option");
			YYERROR;
		}
		$$="";
	}
;

option_list:
	/* empty */ { $$.clear(); }
	| option_list OPT	{	$$.clear();
					$$.jump_mode=$2;
					$$.fields = OPT_JUMP_MODE;
					if(!($$ ^= $1)) {
						disp_error("Incompatible options");
						YYERROR;
					}
				}
	| option_list INTEGER	{	$$.clear();
					$$.iparam=$2;
					$$.fields = OPT_IPARAM;
					if(!($$ ^= $1)) {
						disp_error("Incompatible options");
						YYERROR;
					}
				}
;

jump_cmd:
	JUMP_DIRECTIVE optional_cond	{
		$$.id = $1;
		$$.cond = $2;
		$$.opts.clear();
		$$.text = "";
					}
	| LITERAL_JMP optional_cond NATIVE	{
		$$.id = $1;
		$$.cond = $2;
		$$.opts.clear();
		$$.text = $3;
					}
;

optional_cond:
	/* empty */	{ $$ = COND_UNCOND; }
	| CONDITION	{ $$ = $1; }
;
