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
%option case-insensitive
%option noyywrap
/* %option debug */

/* %option c++ */

%x CCOMMENT
%x STRING

%{
#include "condition.h"
#include "y.tab.h"

#define APPEND { strLine += yytext; }
#define RET_ID(i,t) { APPEND; yylval.id=i; return t; }

#define COND(c) RET_ID(c,CONDITION)
#define JMP(i) RET_ID(i,JUMP_DIRECTIVE)
#define LBL(i) RET_ID(i,LABEL_DIRECTIVE)

string strCurLine;
static string strLine;
static int comment_line_no = 0;
bool eof_term = false;
#define FRESHLINE { BEGIN(INITIAL); strCurLine = strLine; strLine=""; }

%}

%%

 /* Comments */

\/\*			{ strLine += ' '; BEGIN(CCOMMENT); comment_line_no=line_no; }
<CCOMMENT>[*]+\/	{ BEGIN(INITIAL); }
<CCOMMENT>[^*\n]+	{ }
<CCOMMENT>.		{ }
<CCOMMENT>\n		{ line_no++; }
<CCOMMENT><<EOF>>	{ BEGIN(INITIAL); disp_error(comment_line_no,"Unclosed comment"); return UNCLOSED; }

\/\/.*	{ /* C++ comment */ }
;.*	{ /* ASM comment */ }

 /* string literals */

'.'	{ APPEND; yylval.text = string(1,yytext[1]); return LITERAL; }

\"		{ APPEND; BEGIN(STRING); yylval.text = ""; }
<STRING>[\\].	{ APPEND; yylval.text += yytext; }
<STRING>\"	{ APPEND; BEGIN(INITIAL); return LITERAL; }
<STRING>\n	{ APPEND; line_no++; BEGIN(INITIAL); disp_error("Unclosed quotes"); return UNCLOSED; }
<STRING>[^\n\\"]+	{ APPEND; yylval.text += yytext; }
<STRING>.		{ APPEND; yylval.text += yytext; }
<STRING><<EOF>>	{ BEGIN(INITIAL); disp_error("Unclosed quotes"); return UNCLOSED; }

 /* Terminators */

<<EOF>>		{ FRESHLINE; yylval.text=""; if(eof_term) return 0; eof_term=true; return TERMINATOR; }
\n		{ APPEND; FRESHLINE; line_no++;
		yylval.text=yytext; return TERMINATOR; }
[\\]		{ APPEND; FRESHLINE;
		yylval.text=yytext; return TERMINATOR; }

 /* Anonymous labels */

@@		{ strLine+=(yylval.text=AnonNew()); return NATIVE; }
@[0-9]*F	{ int i=1; if(isdigit(yytext[1])) i=atoi(yytext+1);
		  strLine+=(yylval.text=AnonGet(i)); return NATIVE; }
@[0-9]*B	{ int i=1; if(isdigit(yytext[1])) i=atoi(yytext+1);
		  strLine+=(yylval.text=AnonGet(-i)); return NATIVE; }

 /* numbers */

[0-9]+	{ APPEND; yylval.integer=atoi(yytext); return INTEGER; }

 /* Conditions */

NE	|
NZ	{ COND(COND_NZ); }

EQ	|
Z	{ COND(COND_Z); }

A>=N	|
N<=A	|
NC	{ COND(COND_NC); }

A<N	|
N>A	|
C	{ COND(COND_C); }

NV	|
PO	{ COND(COND_PO); }

V	|
PE	{ COND(COND_PE); }

P	{ COND(COND_P); }

M	{ COND(COND_M); }

DJNZ	{ COND(COND_DJNZ); }

NDJNZ	{ COND(COND_NDJNZ); }

 /* common bad conditions */
A>N	|
N>=A	|
N<A	|
A<=N	{ COND(COND_BAD); }

 /**************
  * directives *
  **************/

 /* if/else/endif */

IF	{ JMP(JMP_IF); }
SKIP	{ JMP(JMP_SKIP); }
ELSE	{ JMP(JMP_ELSE); }

ENDSKIP	|
ENDIF	{ LBL(LBL_ENDIF); }

 /* jumps and returns */

JMP	{ RET_ID(JMP_JMP, LITERAL_JMP); }
RETURN	{ JMP(JMP_RET); }

 /* loops */

DO	{ LBL(LBL_DO); }
WHILE	|
LOOP	{ JMP(JMP_LOOP); }
UNTIL	{ JMP(JMP_UNTIL); }
ENDDO	{ LBL(LBL_ENDDO); }
AGAIN	{ JMP(JMP_AGAIN); }
BREAK	{ JMP(JMP_BREAK); }

 /* Option Directives */

OPTION	{ APPEND; yylval.text=""; return OPTION; }

NEAR	|
SIZE	{ RET_ID(OPT_NEAR,OPT); }

FAR	{ RET_ID(OPT_FAR,OPT); }

SPEED	{ RET_ID(OPT_SPEED,OPT); }

[_A-Z]+	{ APPEND; yylval.text=yytext; return NATIVE; }

[[:blank:]]+ { APPEND; }

,	{ APPEND; /* this is cheating but it allows us to write JMP COND, LABEL */ }

.	{ APPEND; return NATIVE; }

%%
