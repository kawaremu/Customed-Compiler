
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     mc_import = 258,
     bib_io = 259,
     bib_lang = 260,
     mc_out = 261,
     signe_s = 262,
     signe_f = 263,
     signe_d = 264,
     mc_afficher = 265,
     pourcentage = 266,
     mc_in = 267,
     mc_for = 268,
     egal = 269,
     sup = 270,
     inf = 271,
     infegal = 272,
     supegal = 273,
     diff = 274,
     quote = 275,
     valeur = 276,
     chaine = 277,
     plus = 278,
     moins = 279,
     mult = 280,
     divi = 281,
     par_ouv = 282,
     par_frm = 283,
     mc_main = 284,
     mc_const = 285,
     dpegal = 286,
     pvg = 287,
     err = 288,
     vrg = 289,
     idf_Tab = 290,
     cr_ouv = 291,
     cr_frm = 292,
     mc_reel = 293,
     mc_chaine = 294,
     mc_private = 295,
     mc_protected = 296,
     mc_entier = 297,
     aco_ouv = 298,
     aco_frm = 299,
     idf = 300,
     mc_class = 301,
     mc_public = 302,
     cst = 303,
     neg = 304
   };
#endif



#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 10 "syntaxical_final.y"

int     entier;
char*   str;
char car;
float reel;



/* Line 1676 of yacc.c  */
#line 110 "syntaxical_final.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


