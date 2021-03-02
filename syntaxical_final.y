%{
int error=0; 
int nb_ligne=0;
int nb_colonne=1;
char sauvType[20];
int bib2_declare = 0;
int bib_declare = 0;
int conflit=0;
%}

%union {
int     entier;
char*   str;
char car;
float reel;
}

%nterm <str> idf_exp
%nterm <entier> exp
%nterm <str> idf_affec
%nterm <str> idf_Tab_affec

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
Nom_BIB:bib_io {bib_declare = 1;}
       |bib_lang {bib2_declare = 1;}
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
output: mc_out mc_out2 par_ouv out_exp par_frm pvg_inout 
;
mc_out2 :  {if(!bib_declare) printf("Bibliothèque isil.io manquante pour l'éxecution du programme.\n");
}
;
input: mc_in mc_in2 par_ouv in_exp par_frm pvg_inout 
;
mc_in2 :  {if(!bib_declare) printf("Bibliothèque isil.io manquante pour l'éxecution du programme.\n");
}
;
pvg_inout: pvg {//verification si des signes de formats non utilisés 
                if(verifierFormatage()!=0 && error==0) {printf("Erreur nombre de formats/identificateur dans la fonction IN/OUT à la ligne: %d.\n",nb_ligne); 
                   resetPile(); } error=0;}
;
in_exp: quote param_form_in quote vrg IDFS 
;
out_exp: quote param_form_out quote vrg IDFS 
;
IDFS: idf vrg IDFS {   if(desempiler($1)==0 && error==0  ) { printf("Erreur format ou nombre de formatage dans la fonction IN/OUT a la ligne: %d \n",nb_ligne); error=1;  }
                      
                      if(!estDeclare($1)) printf("Identificateur %s non declaré à la ligne %d.\n",$1,nb_ligne);}
| idf {   if(desempiler($1)==0 && error==0 ) {printf("Erreur format ou nombre de formatage dans la fonction IN/OUT a la ligne: %d \n",nb_ligne); error=1; }
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
cond: idf dpegal val pvg idf op_comp val pvg idf inc_dec { if(!estDeclare($5)) printf("Identificateur %s non declaré à la ligne %d.\n",$5,nb_ligne); 
                                                           if(!estDeclare($9)) printf("Identificateur %s non declaré à la ligne %d.\n",$9,nb_ligne);
                                                           if(!estDeclare($1)) printf("Identificateur %s non declaré à la ligne %d.\n",$1,nb_ligne);}
;
op_comp: egal | inf | sup | infegal | supegal | diff
;
inc_dec: plus plus | moins moins
;
affec: idf_affec dpegal exp pvg { if(estConstante($1)) printf("Erreur : La constante %s à la ligne %d ne peut pas être modifiée.\n",$1,nb_ligne);
                           if(!estDeclare($1)) printf("Identificateur %s non declaré à la ligne %d.\n",$1,nb_ligne); 
                                    conflit=0;}
 | idf_Tab_affec cr_ouv cst cr_frm dpegal exp pvg 
     { if(depassementIndexTableau($1,$3)) printf("Dépassement de taille du tableau %s à la ligne %d.\n",$1,nb_ligne);
       if(!estDeclare($1)) printf("Identificateur %s non declaré à la ligne %d.\n",$1,nb_ligne); 
       conflit=0;}

;
idf_affec: idf { addType($1);}
;
idf_Tab_affec: idf_Tab { addType($1);}
;
exp: quote chaine quote         { if((getVarType()!='s')&&(conflit==0)) {printf("Conflit de types a la ligne: %d \n",nb_ligne); conflit=1;}}
               //operation + sur chaines permise , mais si le type de idf de l'affectation != string donc erreure

  | quote chaine quote operateur exp     
                                      { if((getVarType()!='s')&&(conflit==0)) {printf("Conflit de types a la ligne: %d \n",nb_ligne); conflit=1;}}
               //operation + sur chaines permise , mais si le type de idf de l'affectation != string donc erreure

  | idf_exp operateur exp  

  | idf_exp  

   
  | val operateur exp {if((getVarType()=='d')&&(getValType()!='d')&&(conflit==0)) {printf("Conflit de types a la ligne: %d \n",nb_ligne); conflit=1;}
                                 if((getVarType()=='s')&&(conflit==0)) {printf("Conflit de types a la ligne: %d \n",nb_ligne); conflit=1;}}
	
  | val {if((getVarType()=='d')&&(getValType()!='d')&&(conflit==0)) {printf("Conflit de types a la ligne: %d \n",nb_ligne); conflit=1;}
                                   if((getVarType()=='s')&&(conflit==0)) {printf("Conflit de types a la ligne: %d \n",nb_ligne); conflit=1;}}

  | idf_exp divi exp {if((getVarType()=='s')&&(conflit==0)) {printf("Conflit de types a la ligne: %d \n",nb_ligne); conflit=1;}
                  if($3==0) printf("Erreur sémantique:  DIVISION PAR ZERO à la ligne %d.\n",nb_ligne);
                   if(getVarType()=='d') printf("La division est interdite sur un entier a la ligne: %d \n",nb_ligne);}


  | val divi exp {if($3==0) printf("Erreur sémantique:  DIVISION PAR ZERO à la ligne %d.\n",nb_ligne);	
                  if((getVarType()=='s')&&(conflit==0)) {printf("Conflit de types a la ligne: %d \n",nb_ligne); conflit=1;}
                  if((getVarType()=='d')&&(conflit==0) ) {printf("La division est interdite sur un entier a la ligne: %d \n",nb_ligne); conflit=1;}}
  
									
  
;
idf_exp:                           idf        { if(!estDeclare($1)) printf("Identificateur %s non declaré à la ligne %d.\n",$1,nb_ligne);
                                                if((getVarType()=='d')&&(typeEntite($1)!='d')&&(conflit==0)) {printf("Conflit de types a la ligne: %d \n",nb_ligne); conflit=1;}
                                                if((getVarType()=='s')&&(typeEntite($1)!='s')&&(conflit==0)) {printf("Conflit de types a la ligne: %d \n",nb_ligne); conflit=1;}}

               | idf_Tab cr_ouv cst cr_frm {   if(depassementIndexTableau($1,$3)) printf("Dépassement de taille du tableau %s à la ligne %d.\n",$1,nb_ligne);
                                               if(!estDeclare($1)) printf("Identificateur %s non declaré à la ligne %d.\n",$1,nb_ligne);
                                               if((getVarType()=='d')&&(typeEntite($1)!='d')&&(conflit==0)) {printf("Conflit de types a la ligne: %d \n",nb_ligne); conflit=1;}
                                               if((getVarType()=='s')&&(typeEntite($1)!='s')&&(conflit==0)) {printf("Conflit de types a la ligne: %d \n",nb_ligne); conflit=1;}}
operateur: plus 
          | moins {if(getVarType()=='s') printf("Conflit de types, Operation - est interdite sur les chaines! a la ligne: %d \n",nb_ligne);}
          | mult {if(getVarType()=='s') printf("Conflit de types, Operation - est interdite sur les chaines! a la ligne: %d \n",nb_ligne);}
          
;
Partie_DEC: Partie_DEC_VAR Partie_DEC
          | Partie_DEC_TAB Partie_DEC
          | Partie_DEC_CONST Partie_DEC
          |
;
Partie_DEC_CONST:   mc_const TYPE idf dpegal val pvg { if(!doubleDeclaration($3)) {insererType($3,sauvType); 
                                                                                    insererTaille($3,0);
                                                                                           if(((strcmp(sauvType,"Entier")==0)&&(getValType()=='f'))) printf("Conflit de type a la ligne: %d \n",nb_ligne);}
							    else
								printf("Erreur sémantique: double déclaration de la variable %s à la ligne %d.\n",$3,nb_ligne);
								}
                  | mc_const TYPE idf dpegal quote chaine quote pvg { if(!doubleDeclaration($3))
                                     {insererType($3,sauvType);
                                     insererTaille($3,0); 
                                      if(strcmp(sauvType,"Chaine")!=0) printf("Conflit de type a la ligne: %d \n",nb_ligne);}
							    else
								printf("Erreur sémantique: double déclaration de la variable %s à la ligne %d.\n",$3,nb_ligne);
								}
                  | mc_const TYPE idf pvg { if(!doubleDeclaration($3))
                                     {insererType($3,sauvType); insererTaille($3,0);}
							    else
								printf("Erreur sémantique: double déclaration de la variable %s à la ligne %d.\n",$3,nb_ligne);
								}
;
val: valeur  {addvalType('f');}
    | moins valeur {addvalType('f');}
    | moins cst {addvalType('d');}
    | cst  {addvalType('d');}
    
;
Partie_DEC_TAB: TYPE LISTE_IDF_TAB pvg
;
LISTE_IDF_TAB: idf_Tab cr_ouv cst cr_frm vrg LISTE_IDF_TAB
{ if(!doubleDeclaration($1))
                                    { insererType($1,sauvType); insererTaille($1,$3);}
							    else
								printf("Erreur sémantique: double declaration de la variable %s à la ligne %d.\n",$1,nb_ligne);
								}
              | idf_Tab cr_ouv cst cr_frm
{ if(!doubleDeclaration($1))
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

         | idf { if(!doubleDeclaration($1))
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