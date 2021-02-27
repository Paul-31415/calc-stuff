#LEX_FLAGS = -d

.PHONY : all clean install
all : condition

condition : condition.cpp condition.h y.tab.c lex.yy.c
	g++ -o condition -x c++ condition.cpp y.tab.c lex.yy.c

y.tab.c y.tab.h : condition.y condition.h
	yacc -d condition.y

lex.yy.c : condition.lex y.tab.h condition.h
	lex $(LEX_FLAGS) condition.lex

clean :
	rm -f condition y.tab.h y.tab.c lex.yy.c

install : condition
	mv condition ~/bin/condition

