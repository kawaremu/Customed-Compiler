

/* Toutes les règles de grammaire */


%{
int error=0;
int nb_ligne=0;
int nb_colonne=1;
char sauvType[20];
int bib_declare = 0;
%}

%union {
int     entier;
char*   str;
char car;
float reel;
}


%nterm <entier> exp


%token mc_import bib_io bib_lang mc_out signe_s signe_f signe_d 
pourcentage mc_in mc_for egal sup inf infegal supegal diff quote 
<reel>valeur <str>chaine plus moins mult divi par_ouv par_frm mc_main mc_const
 dpegal pvg err vrg <str>idf_Tab cr_ouv cr_frm <str>mc_reel mc_chaine mc_private
 mc_protected <str>mc_entier aco_ouv aco_frm <str>idf mc_class mc_public <entier>cst

%left moins plus           //Associativité gauche 
%left neg

%%
S: LISTE_BIB HEADER_CLASS aco_ouv CORPS aco_frm {printf("Fin de l'execution du programme.\n"); YYACCEPT;}
 
; 
LISTE_BIB : BIB LISTE_BIB
          |
;		  
BIB: mc_import Nom_BIB pvg 
    
;	
Nom_BIB:bib_io 
       |bib_lang
;
HEADER_CLASS: MODIFICATEUR mc_class idf 
;
MODIFICATEUR:mc_public
             |mc_private
             |mc_protected
;
CORPS: Partie_DEC mc_main par_ouv par_frm aco_ouv Partie_ins aco_frm    
;
Partie_ins: ins Partie_ins
          | 
;
ins: affec | loop | input | output
;
output: mc_out par_ouv out_exp par_frm pvg_inout 
;
input: mc_in par_ouv in_exp par_frm pvg_inout 
;
pvg_inout: pvg {//verification si des signes de formats non utilisés 
                //if(VerifFormat()!=0) printf("Erreur format dans la fonction IN/OUT a la ligne: %d \n",nb_ligne); 
                 error=1;}
;
in_exp: quote param_form_in quote vrg IDFS // "";
;
out_exp: quote param_form_out quote vrg IDFS 
;
IDFS: idf vrg IDFS {   if(desempiler($1)==0 && error==0) { printf("Erreur format ou nombre de formatage dans la fonction IN/OUT a la ligne: %d \n",nb_ligne); error=1;}
                      
                      if(!estDeclare($1)) printf("Identificateur %s non declaré à la ligne %d.\n",$1,nb_ligne);}
| idf {   if(desempiler($1)==0 && error==0) {printf("Erreur format ou nombre de formatage dans la fonction IN/OUT a la ligne: %d \n",nb_ligne); error=1;}
          if(!estDeclare($1)) printf("Identificateur %s non declaré à la ligne %d.\n",$1,nb_ligne);}
;
param_form_in: pourcentage signe_form //%d %f %s
           | pourcentage signe_form param_form_in
;
param_form_out: pourcentage signe_form 
           | pourcentage signe_form param_form_out
           | chaine 
           | chaine param_form_out
;
signe_form: signe_d {   empiler('d'); }
          | signe_f {  empiler('f'); }
          | signe_s {    empiler('s'); }
;
loop: mc_for par_ouv cond par_frm aco_ouv Partie_ins aco_frm
;
cond: idf dpegal val pvg idf op_comp val pvg idf inc_dec { if(!estDeclare($5)) printf("Identificateur %s non declaré à la ligne %d.\n",$5,nb_ligne); return;
                                                           if(!estDeclare($9)) printf("Identificateur %s non declaré à la ligne %d.\n",$9,nb_ligne); return;
                                                           if(!estDeclare($1)) printf("Identificateur %s non declaré à la ligne %d.\n",$1,nb_ligne); return;}
;
op_comp: egal | inf | sup | infegal | supegal | diff
;
inc_dec: plus plus | moins moins
;
affec: idf dpegal exp pvg { if(estConstante($1)) printf("Erreur : La constante %s à la ligne %d ne peut pas être modifiée.\n",$1,nb_ligne);
                           if(!estDeclare($1)) printf("Identificateur %s non declaré à la ligne %d.\n",$1,nb_ligne); }
 | idf_Tab cr_ouv cst cr_frm dpegal exp pvg 
     { if(depassementIndexTableau($1,$3)) printf("Dépassement de taille du tableau %s à la ligne %d.\n",$1,nb_ligne);
       if(!estDeclare($1)) printf("Identificateur %s non declaré à la ligne %d.\n",$1,nb_ligne); }

;
exp: quote chaine quote
 | idf operateur exp { if(!estDeclare($1)) printf("Identificateur %s non declaré à la ligne %d.\n",$1,nb_ligne);}
  | idf { if(!estDeclare($1)) printf("Identificateur %s non declaré à la ligne %d.\n",$1,nb_ligne);}
  | val operateur exp 	
  | val
  | idf divi exp {if($3==0) printf("Erreur sémantique:  DIVISION PAR ZERO à la ligne %d.\n",nb_ligne); 
                  if(!estDeclare($1)) printf("Identificateur %s non declaré à la ligne %d.\n",$1,nb_ligne);}
  | val divi exp {if($3==0) printf("Erreur sémantique:  DIVISION PAR ZERO à la ligne %d.\n",nb_ligne);	
                 }
  
									
  
;
operateur: plus 
          | moins
          | mult
          
;
Partie_DEC: Partie_DEC_VAR Partie_DEC
          | Partie_DEC_TAB Partie_DEC
          | Partie_DEC_CONST Partie_DEC
          |
;
Partie_DEC_CONST:   mc_const TYPE idf dpegal val pvg { if(!doubleDeclaration($3))
                                     {insererType($3,sauvType); insererTaille($3,0);}
							    else
								printf("Erreur sémantique: double declaration de la variable %s à la ligne %d.\n",$3,nb_ligne);
								}
                  | mc_const TYPE idf dpegal quote chaine quote pvg { if(doubleDeclaration($3)==0)
                                     {insererType($3,sauvType);
                                     insererTaille($3,0);}
							    else
								printf("Erreur sémantique: double declaration de la variable %s à la ligne %d.\n",$3,nb_ligne);
								}
                  | mc_const TYPE idf pvg { if(doubleDeclaration($3)==0)
                                     {insererType($3,sauvType); insererTaille($3,0);}
							    else
								printf("Erreur sémantique: double declaration de la variable %s à la ligne %d.\n",$3,nb_ligne);
								}
;
val: valeur 
    | moins valeur
    | moins cst
    | cst 
    
;
Partie_DEC_TAB: TYPE LISTE_IDF_TAB pvg
;
LISTE_IDF_TAB: idf_Tab cr_ouv cst cr_frm vrg LISTE_IDF_TAB
{ if(doubleDeclaration($1)==0)
                                    { insererType($1,sauvType); insererTaille($1,$3);}
							    else
								printf("Erreur sémantique: double declaration de la variable %s à la ligne %d.\n",$1,nb_ligne);
								}
              | idf_Tab cr_ouv cst cr_frm
{ if(doubleDeclaration($1)==0)
                                    { insererType($1,sauvType); insererTaille($1,$3);}
							    else
								printf("Erreur sémantique: double declaration de la variable %s à la ligne %d.\n",$1,nb_ligne);
								}
;
Partie_DEC_VAR: TYPE LISTE_IDF pvg
;
LISTE_IDF: idf vrg LISTE_IDF { if(!doubleDeclaration($1))
                                    insererType($1,sauvType);
							    else
								printf("Erreur sémantique: double declaration de la variable %s à la ligne %d.\n",$1,nb_ligne);
								}

         | idf { if(doubleDeclaration($1)==0)
                                     insererType($1,sauvType);
							    else
								printf("Erreur sémantique: double declaration de la variable %s à la ligne %d.\n",$1,nb_ligne);
								}
;
TYPE: mc_entier {strcpy(sauvType,$1);}
    | mc_reel {strcpy(sauvType,$1);} 
    | mc_chaine {strcpy(sauvType,$1);}
;


%%
main()
{
    yyparse(); 
    afficherTableSymbole();
}

yywrap()
{

}

yyerror(char *msg)
{
    printf("Erreur syntaxique à la ligne %d.\n", nb_ligne);
}