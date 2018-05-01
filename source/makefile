mymakefile: myparser.y mylexer.l 
	bison -d -v -r all myparser.y
	flex 'mylexer.l'
	gcc -o mycompiler 'lex.yy.c' 'cgen.c' 'myparser.tab.c' -lfl