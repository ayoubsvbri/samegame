#include <stdio.h>
#include <stdlib.h>
#include "main.h"
#include "manipulationGrille.h"

extern Bille grille[NB_LIG_GRILLE][NB_COL_GRILLE];

/*
Cette fonction parcours la grille pour voir si il y a des billes a supprimer
Si oui elle renvoi 1, sinon 0
*/

int parcourirGrille(void){
	int flag = 0;

	for (int i = 1; i < NB_LIG_GRILLE - 1; ++i)
	{
		for (int j = 1; j < NB_COL_GRILLE - 1; ++j)
		{
			if(grille[i][j].supprimer == 1){
				flag = 1;
			}
		}
	}
	return flag;
}

/*
Cette fonction supprime les billes qui ont la meme couleur que la bille choisie 
par l'utilisateur et apporte les modifications necessaires
*/

void suppressionBille(void){
	// variables utilisées pour faire descendre les billes d'une position

	int w = 0;
	int y = 1;

	do
	{
		for (int i = NB_LIG_GRILLE - 1; i > 0; --i)
		{
			for (int j = 1; j < NB_COL_GRILLE - 1; ++j)
			{
				if (grille[i][j].supprimer == 1)
				{
					while(grille[i-y][j].couleur != VIDE)
					{
						grille[i-w][j] = grille[i-y][j]; // decale toutes les billes d'une position (recopie tous les membres)
						w++;
						y++;
					}	
						grille[i-w][j].couleur = VIDE;
						grille[i-w][j].supprimer = 0; // mettre la case du haut vide
						w = 0;
						y = 1;
				}
			}
		}	
	} while (parcourirGrille() == 1);
}