#include <stdio.h>
#include <stdlib.h>
#include "affichageGrille.h"
#include "main.h"

extern Bille grille[NB_LIG_GRILLE][NB_COL_GRILLE];

void afficherCase(char couleur){

	switch(couleur){
		case ROUGE:
			printf("[\e[1;31m*\e[0m]");
			break;
		case JAUNE:
			printf("[\e[1;33m*\e[0m]");
			break;
		case BLEU:
			printf("[\e[1;34m*\e[0m]");
			break;
		case VIDE:
			printf("[ ]");
			break;
		default:
			printf("Valeur non connue");
	}
}

void afficherGrille(void){

	char lettre = 'A';

	for (int i = 1; i < NB_LIG_GRILLE - 1; ++i)
	{
		printf("\n");
		printf("%c ", lettre++);
		for (int j = 1; j < NB_COL_GRILLE - 1; ++j)
		{
			afficherCase(grille[i][j].couleur);
		}
	}
	
	printf("\n  ");

	for (int i = 1; i < 10 ; ++i)
	{
		printf(" %d ",i);
	}

	printf("\n");
	printf("\n");
}

/* avec cette fonction on génére un chiffre compris entre
   1 et 3. En fonction de sa valeur on remplit une case
   avec une couleur */

char remplirCase(void){

	char couleur = ( rand() % 3 ) + 1;

	if (couleur == 1){
		couleur = 'R'; 
	}
	else if(couleur == 2){
		couleur = 'J';
	}
	else if(couleur == 3){
		couleur = 'B';
	}

	return couleur;
}

void remplirGrille(void){

	for (int i = 1; i < NB_LIG_GRILLE - 1; ++i)
	{
		for (int j = 1; j < NB_COL_GRILLE - 1; ++j)
		{
			grille[i][j].couleur = remplirCase();
		}
	}
}