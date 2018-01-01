#include <stdio.h>
#include "mesTypes.h"

//definition de la taille de la grille affichée

#define NB_LIG 9 // nombre de lignes
#define NB_COL 9 // nombre de colonnes

#define NB_LIG_GRILLE NB_LIG + 2
#define NB_COL_GRILLE NB_COL + 2

//definition des quatre etats possibles d'une case de la grille

#define VIDE 0
#define ROUGE 'R'
#define JAUNE 'J'
#define BLEU 'B'

#define NB_MAX_COUPS 100 // à n'utiliser que en mode coups limités

Bille grille[NB_LIG_GRILLE][NB_COL_GRILLE];

int nombreCoups;