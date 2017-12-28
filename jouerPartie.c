#include <stdio.h>
#include <stdlib.h>
#include "main.h"
#include "jouerPartie.h"

extern int nombreCoups;
extern Bille grille[NB_LIG_GRILLE][NB_COL_GRILLE];

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

void marquerBilleSupprimer(char y, int x){
	grille[y-'A'+1][x].supprimer = 1;
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

	marquerBilleSupprimer(ligneChoisie, colonneChoisie);
	nombreCoups++;
}