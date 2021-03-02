%{
#include "semantique_final.h"
#include "syntaxical_final.tab.h"
extern bib2_declare;
extern nb_ligne;
extern YYSTYPE yylval;
%}


lettres [a-zA-Z]
chiffres [0-9]
constante {chiffres}+
valeur ({constante}","{constante})
idf "$"{lettres}({lettres}|{chiffres}|_)*
idf_Tab "@"{lettres}({lettres}|{chiffres}|_)*
commentaire [^##]*
ch ({chiffres}|{lettres})*


%%

"##"{commentaire}*"##" { nb_ligne++; if(yytext=="\n") nb_ligne++; }
"d"  return signe_d;
"s"  return signe_s;
"f"  return signe_f;
import return mc_import; 
isil.io return bib_io;
isil.lang return bib_lang;
public return mc_public;
class return mc_class;
Entier { yylval.str=strdup(yytext);  
                return mc_entier;}
Const { yylval.str=strdup(yytext);  
                return mc_const;}
private return mc_private;
protected return mc_protected;
Reel { yylval.str=strdup(yytext);  
             return mc_reel; }
main return mc_main;
Chaine { yylval.str=strdup(yytext); 
         return mc_chaine;}
For return mc_for;
In return mc_in;
Out return mc_out;
{constante} { yylval.entier=atoi(yytext); 
                     return cst;
		}
{idf} {if(yyleng<=25) { yylval.str=strdup(yytext); inserer(yytext,"idf");   
                     return idf;}
       else printf("La taille de l'idf %d est trop longue!\n",yytext);}
{idf_Tab} {if(yyleng<=25) { yylval.str=strdup(yytext); inserer(yytext,"idf_tab");   
                     return idf_Tab;}
       else printf("La taille de l'idf %d trop longue!\n",yytext);}
{valeur} { yylval.reel=atoi(yytext);
                     return valeur;
		}
"=" return egal;
"<" return inf;
">" return sup;
"<=" return infegal;
">=" return supegal;
"!=" return diff;
\" return quote;
"+" return plus;
"-" return moins;
"*" return mult;
"/" return divi;
":=" { if(bib2_declare == 1) return dpegal; else {printf("Bibliothèque isil.lang manquante pour l'éxecution des affectations.\n"); return err;}}
"[" return cr_ouv;
"]" return cr_frm;
"," return vrg;
; return pvg;
"{" return aco_ouv;
"}" return aco_frm;
"(" return par_ouv;
")" return par_frm;
"%" return pourcentage;
[ \t]
\n {nb_ligne++;}
{ch} { yylval.str=strdup(yytext);
       return chaine;}
. {printf("Erreur lexicale à la ligne %d avec l'entité %s.\n",nb_ligne,yytext);
return err;}


