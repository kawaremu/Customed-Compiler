flex lexical_final.l
bison -d syntaxical_final.y
gcc lex.yy.c syntaxical_final.tab.c -lfl -ly -o compilateur2
compilateur2.exe<exp.txt