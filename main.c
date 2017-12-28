#include <stdio.h>
#include <stdlib.h>
#include "mesTypes.h"
#include "main.h"
#include "affichageGrille.h"
#include "jouerPartie.h"
#include "manipulationGrille.h"

int main(void){

	remplirGrille();
	afficherGrille();
	
	while(1){
		jouerCoup();
		suppressionBille();
		afficherGrille();
	}
	
	return 0;
}