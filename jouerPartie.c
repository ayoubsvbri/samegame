#include <stdio.h>
#include <stdlib.h>
#include "main.h"
#include "jouerPartie.h"

extern int nombreCoups;
extern Bille grille[NB_LIG_GRILLE][NB_COL_GRILLE];

int quatreDirections [4] = {};

/* 
	Si aucune des billes adjacentes à celle choisie par l'utilisateur
	n'a pas la meme couleur alors il s'agit d'un coup invalide
	La fonction renvoi 1 ci c'est un coup valide, 0 si invalide
*/

int estCoupValide(char y, int x){
	int flag = 0;
	
	char couleurCase = grille[y-'A'+1][x].couleur;

	char couleurHaut = grille[y-'A'][x].couleur; 
	char couleurDroite = grille[y-'A'+1][x+1].couleur;
	char couleurBas = grille[y-'A'+2][x].couleur;
	char couleurGauche = grille[y-'A'+1][x-1].couleur;

	if (couleurCase == VIDE)
	{
		return flag = 0;
	}
	else if (couleurHaut == couleurCase || couleurDroite == couleurCase ||
		couleurBas == couleurCase || couleurGauche == couleurCase)
	{
		return flag = 1;
	}
	else{
		return flag = 0;
	}
}

int verifierCasesAdjacentes(char y, int x){

	int flag = 0;

	Bille billeActuelle = grille[y-'A'+1][x];
	grille[y-'A'+1][x].supprimer = 1;

	Bille billeHaut = grille[y-'A'][x]; 
	Bille billeDroite = grille[y-'A'+1][x+1];
	Bille billeBas = grille[y-'A'+2][x];
	Bille billeGauche = grille[y-'A'+1][x-1];

	if (billeHaut.couleur == billeActuelle.couleur && billeHaut.supprimer == 0)
	{
		quatreDirections[0] = 1;
		//billeHaut.supprimer = 1;
		flag = 1;
	}
	else {quatreDirections[0] = 0;} 

	if (billeDroite.couleur == billeActuelle.couleur && billeDroite.supprimer == 0)
	{
		quatreDirections[1] = 1;
		flag = 1;
	}
	else {quatreDirections[1] = 0;}

	if (billeBas.couleur == billeActuelle.couleur && billeBas.supprimer == 0)
	{
		quatreDirections[2] = 1;
		flag = 1;
	}
	else {quatreDirections[2] = 0;}

	if (billeGauche.couleur == billeActuelle.couleur && billeGauche.supprimer == 0)
	{
		quatreDirections[3] = 1;
		flag = 1;
	}
	else {quatreDirections[3] = 0;}

	//printf("Cases adjacentes de %c%d : %d%d%d%d \n", y,x,quatreDirections[0], quatreDirections[1], quatreDirections[2], quatreDirections[3]);

	return flag;
}

// fonction recursive

void marquerBlocSupprimer(char y, int x){
	
	int tempDirections[4] = {};

	if (verifierCasesAdjacentes(y,x) == 0) // sinon eliminer flag et tester la somme des quatre cases du tableau
	{
		/* 
		   sortir de la fonction car toutes le billes adjacentes
		   ont la n'ont pas la meme couleur ou ont ete deja 
		   marquées comme billes a supprimer 
		*/
	}
	else{
		for (int i = 0; i < 4; ++i) // sauvegarde du tableau qui sera reutilisé par la suite
		{
			tempDirections[i] = quatreDirections[i];
		}

		if (quatreDirections[0] == 1)
		{
			marquerBlocSupprimer(y-1,x); // en haut
			for (int i = 0; i < 4; ++i)
			{
				quatreDirections[i] = tempDirections[i];
			}
			//afficherDebogage();
		}
		if (quatreDirections[1] == 1)
		{
			marquerBlocSupprimer(y,x+1); // a droite
			for (int i = 0; i < 4; ++i)
			{
				quatreDirections[i] = tempDirections[i];
			}
		}
		if (quatreDirections[2] == 1)
		{
			marquerBlocSupprimer(y+1,x); // en bas
			for (int i = 0; i < 4; ++i)
			{
				quatreDirections[i] = tempDirections[i];
			}
		}
		if (quatreDirections[3] == 1)
		{
			marquerBlocSupprimer(y,x-1); // a gauche
			for (int i = 0; i < 4; ++i)
			{
				quatreDirections[i] = tempDirections[i];
			}
		}
	}
}

/*
	Dans cette fonction on demande à l'utilisateur
	de rentrer les coordonnés de la bille choisie
*/

void jouerCoup(void){
	
	char ligneChoisie = 0;
	int colonneChoisie = 0;

	printf("Choisissez une ligne et une colonne : \n");

	scanf("%c%d", &ligneChoisie, &colonneChoisie);
	while(getchar()!='\n'); // on vide le buffer (ESSENTIEL)

	while (estCoupValide(ligneChoisie, colonneChoisie) != 1){
		printf("Le coup n'est pas valide \n");
		printf("Choisissez une ligne et une colonne : \n");
		scanf("%c%d", &ligneChoisie, &colonneChoisie);
	};

	marquerBlocSupprimer(ligneChoisie, colonneChoisie);
	nombreCoups++;
}

/*
	Cette fonction renvoi 0 si il y a au moins deux cases
	 de la meme couleur adjacentes ou 1 si il y a plus de
	cases a supprimer. Elle est utilisée pour detecter la 
	fin du jeu
*/

int partieTerminee(void){
	int flag = 1;

	for (int i = 1; i < NB_LIG_GRILLE - 1; ++i)
	{
		for (int j = 1; j < NB_COL_GRILLE - 1; ++j)
		{
			if (grille[i][j].couleur != VIDE)
			{
				if(grille[i][j].couleur == grille[i-1][j].couleur || // en haut
				   grille[i][j].couleur == grille[i][j+1].couleur || // a droite
				   grille[i][j].couleur == grille[i+1][j].couleur || // en bas
				   grille[i][j].couleur == grille[i][j-1].couleur)   // a gauche
				{
					flag = 0;
				}
			}
		}
	}
	return flag;
}