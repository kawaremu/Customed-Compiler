flex lexical_final.l
bison -d syntaxical_final.y
gcc -w lex.yy.c syntaxical_final.tab.c -lfl -ly -o compilateur2