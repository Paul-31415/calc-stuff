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
#ifndef CONDITION_H
#define CONDITION_H
#include <cstdio>
#include <cstdlib>
#include <queue>
#include <vector>
#include <string>
#include <stack>
using namespace std;

extern FILE* z80in;
extern FILE* z80out;
extern FILE* z80err;

////////////////////////////////
// Error System
extern int line_no;
extern int line_no_out;
extern string strCurLine;

void disp_error(int line_number, const char* message);
void disp_error(const char* message);

int count_newlines(const char* str);

//#define YYDEBUG 1
#ifdef YYDEBUG
extern int yydebug;
#endif

////////////////////////////////
// Conditions
static	const int COND_UNCOND	= 0x00;

static	const int COND_NZ	= 0x10;
static	const int COND_Z	= 0x11;
static	const int COND_NC	= 0x12;
static	const int COND_C	= 0x13;
#define COND_JR(c) ((-4&(c))==COND_NZ)

static	const int COND_PO	= 0x14;
static	const int COND_PE	= 0x15;
static	const int COND_P	= 0x16;
static	const int COND_M	= 0x17;
#define COND_JP(c) ((-8&(c))==COND_NZ)

static	const int COND_DJNZ	= 0x20;
static	const int COND_NDJNZ	= 0x21;

static	const int COND_BAD	= 0x28;

////////////////////////////////
// Statements
static	const int JMP_SKIP	= 0x30;
static	const int JMP_IF	= 0x31;
static	const int JMP_ELSE	= 0x32;	// ELSE <cond> is deprecated but legal

static	const int JMP_LOOP	= 0x34;
static	const int JMP_UNTIL	= 0x35;

static	const int JMP_AGAIN	= 0x40;
static	const int JMP_BREAK	= 0x42;

static	const int JMP_JMP	= 0x50;
static	const int JMP_RET	= 0x52;

static	const int LBL_ENDIF	= 0x80;
static	const int LBL_DO	= 0x82;
static	const int LBL_ENDDO	= 0x84;

////////////////////////////////
// Options
static	const int OPT_SPEED	= 0x01;
static	const int OPT_NEAR 	= 0x02;
static	const int OPT_FAR  	= 0x03;

static	const int OPT_JUMP_MODE	= 0x0001;
static	const int OPT_IPARAM	= 0x0002;

struct options {
	void clear();
	options operator<<(const options&) const;
	bool operator^=(const options&);
	unsigned int fields;
	unsigned int jump_mode;
	int iparam;
};

int set_global_options(const options&);
bool process_options(const char* name, const char* value);

////////////////////////////////
// Directives

struct directive {
	options opts;
	int id;
	int cond;
	string text;
};

bool process_directive(directive, string&);

////////////////////////////////
// Stack Frames

static const int FRAME_INVALID = 0;
static const int FRAME_IF = 1;
static const int FRAME_LOOP = 2;

struct stackframe;

struct frame_stack {
	vector<stackframe> st;
	stackframe top(int depth=1);
	stackframe top(int type, int depth);
	bool pop();
	void push(const stackframe& s);
};

extern frame_stack global_stack;

////////////////////////////////
// Anonymous Labels
string AnonNew();
string AnonGet(int i);

////////////////////////////////
// Lex/Yacc

struct yytoken {
	string	text;
	int	integer;
	int	id;
	options	opt;
	directive	dir;
};
#define YYSTYPE yytoken
extern YYSTYPE yylval;

int yylex();
int yyparse();
extern FILE* yyin;

#endif
