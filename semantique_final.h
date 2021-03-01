#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
/******************************************************************************/
// Définition de la structure dynamique, c'est un noeud qui a plusieurs champs
//version avec element
/*************************** I-DECLARATION      ********************************/
/******************************************************************************/
typedef struct
{
    char *NomEntite;
    char *CodeEntite;
    char *TypeEntite;
    int tailleEntite;
} typeTS;
/******************************************************************************/
typedef struct node
{
    typeTS element;
    struct node *next;
} node;
/******************************************************************************/
// Variables globales pour les élèments de la table des symboles
/******************************************************************************/

typedef node *list;
list head; //C'est la tête de la liste chaînée de la table des symboles
int cpt_tab_symb = 0;
char pile[25];
int taille_pile = 0;
int tete_pile = -1;
/******************************************************************************/
/****** Fonction qui crée un nouveau noeud avec le nom et code de l'entité*****/
/******************************************************************************/
list newNode(char *entite, char *code)
{

    list newnode = (node *)malloc(sizeof(node));
    newnode->element.NomEntite = strdup(entite);
    newnode->element.CodeEntite = strdup(code);
    newnode->element.TypeEntite = strdup("");
    newnode->element.tailleEntite = 1;
    newnode->next = NULL;
    return newnode;
}

/******************************************************************************/
/*********** 1- Fonction de recherche  dans la table de symboles **************/
/******************************************************************************/
bool recherche(char *entite)
{
    list curr;
    curr = head;
    while (curr != NULL)
    {
        if (strcmp(curr->element.NomEntite, entite) == 0) return true;
        curr = curr->next;
    }
    return false;
}

/******************************************************************************/
/*********** 2- Fonction d'insertion  dans la table de symboles ****************/
/******************************************************************************/
void inserer(char *entite, char *code)
{
    list temp, curr;

    temp = newNode(entite, code);
    curr = head;
    bool exist = recherche(entite);
    if(!exist) //Si l'entité n'existe pas
    {
    if (head == NULL)
    {
        head = temp;
        return;
    }
    while (curr->next != NULL)
    {
        curr = curr->next;
    }
    curr->next = temp;
    cpt_tab_symb++;
    return;
    }
}


/******************************************************************************/
/*********** 3- Fonction d'affichage de la table de symboles ******************/
/******************************************************************************/
void afficherTableSymbole()
{
    list curr;
    curr = head;
    printf("\n/*****************    **************************************   ***************\n");
    printf("/*****************    ========  TABLE DES SYMBOLES  ========    ***************/\n");
    printf("-------------------------------------------------------------------------------\n");
    printf("|  Nom entité  |   Code entité    |    Type entité     |    Taille entité      |\n");
    printf("-------------------------------------------------------------------------------\n");
    while (curr != NULL)
    {
        printf("|%13s | %15s | %19s | %21d |\n",curr->element.NomEntite, curr->element.CodeEntite,
        curr->element.TypeEntite,curr->element.tailleEntite);
        printf("-------------------------------------------------------------------------------\n");
        curr = curr->next;
    }
}

/******************************************************************************/
/*********** 4- Fonction d'insertion du type dans la table de symboles ********/
/******************************************************************************/
void insererType(char *entite, char *type)
{
    list curr;
    curr = head;
    while (curr != NULL)
    {
        if (strcmp(curr->element.NomEntite, entite) == 0)
        {
            curr->element.TypeEntite = strdup(type);
            return;
        }
        curr = curr->next;
    }
}

/****************************************************************************/
/*********** 5- Fonction détection de double déclaration     ****************/
/****************************************************************************/
bool doubleDeclaration(char *entite)
{
    list curr;
    curr = head;
    while (curr != NULL)
    {
        if (strcmp(curr->element.NomEntite, entite) == 0){
            if(strcmp(curr->element.TypeEntite, "") == 0) return false;    //N'est pas doublement déclarée
            else return true;
        }
    curr = curr->next;
    }
    return false;
}

/*****************************************************************************/
/*********** 6- Fonction d'insertion de taille      **************************/
/*****************************************************************************/
void insererTaille(char *entite, int taille)
{
    list curr;
    curr = head;
    while (curr != NULL)
    {   //On cherche le nom de l'élément d'abord
        if (strcmp(curr->element.NomEntite, entite) == 0)
        { 
            curr->element.tailleEntite = taille;
            return;
        }
        curr = curr->next;
    }
}

/****************************************************************************/
/*********** 7- Fonction de dépassement taille de tableau *******************/
/***************************************************************************/
bool depassementIndexTableau(char *entite, int index)
{
    list curr;
    curr = head;
    while (curr != NULL)
    {
        if (strcmp(curr->element.NomEntite, entite) == 0)
        {
            if (curr->element.tailleEntite < index)
                return true; //La taille est dépassée
            else
                return false;
        }
        curr = curr->next;
    }
    return false; //La taille n'est pas dépassée
}

/******************************************************************************/
/***********     8- Fonction de vérification de constante    ******************/
/******************************************************************************/
bool estConstante(char *entite)
{
    list curr;
    curr = head;
    while (curr != NULL)
    {
        if (strcmp(curr->element.NomEntite, entite) == 0)
        { //Par convention, la taille d'une constante = 0
            if (curr->element.tailleEntite == 0) return true;
            else return false;
        }
        curr = curr->next;
    }
    return false;
}

/******************************************************************************/
/***********     9- Fonction de vérification de déclaration *******************/
/******************************************************************************/
bool estDeclare(char *entite)
{
    list curr;
    curr = head;
    while (curr != NULL)
    {
        if (strcmp(curr->element.NomEntite, entite) == 0)
        {
            if(strcmp(curr->element.TypeEntite, "") == 0) return false; 
            else return true;
        }       
        curr = curr->next;
    }
    return false;
}


/******************************************************************************/
/***********     10- Fonction qui retourne le type d'un idf    ****************/
/******************************************************************************/
char typeEntite(char *id)
{
    list curr;
    curr = head;
    while (curr != NULL)
    {
        if (strcmp(curr->element.NomEntite, id) == 0)
        {
            if (strcmp(curr->element.TypeEntite, "Entier") == 0)
                return 'd';
            if (strcmp(curr->element.TypeEntite, "Chaine") == 0)
                return 's';
            if (strcmp(curr->element.TypeEntite, "Reel") == 0)
                return 'f';
        }
        curr = curr->next;
    }
}

/******************************************************************************/
/***********     11- Fonction de bibliothèque nécessaire       ****************/
/******************************************************************************/








/******************************************************************************/
/***********     12- Fonction de formatage de chaîne E/S       ****************/
/******************************************************************************/

void resetPile()
{
    tete_pile = -1;
    taille_pile = 0;
}

int veriferFormatage()
{
    return taille_pile;
}

void empiler(char signe)
{
    pile[taille_pile] = signe;
    tete_pile++;
    taille_pile++;
}

int desempiler(char element[])
{
    if (tete_pile == -1)
    {
        return 0;
    }
    else
    {
        if (typeEntite(element) == pile[tete_pile])
        {
            taille_pile--;
            tete_pile--;
            return 1;
        }
        else return 0;
    }
}

/******************************************************************************/
/*********************     PARTIE DE TEST      ********************************/
/******************************************************************************/
// int main(int argc, char const *argv[])
// {
//     head = NULL;
//     inserer("prix", "idf");
//     inserer("$x", "idf");
//     inserer("$y", "idf");
//     inserer("$alpha", "idf");

//     insererType("prix", "float");
//     insererType("$x", "Entier");
//     insererType("$y", "Entier");
//     insererType("$alpha", "Chaine");
//     afficherTableSymbole();
//     return 0;
// }
