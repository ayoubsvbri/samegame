all: samegame

samegame : manipulationGrille.o jouerPartie.o affichageGrille.o main.o
	gcc -Wall manipulationGrille.o jouerPartie.o affichageGrille.o main.o -o samegame 

manipulationGrille.o : manipulationGrille.c manipulationGrille.h
	gcc -Wall -c manipulationGrille.c -o manipulationGrille.o

jouerPartie.o : jouerPartie.c jouerPartie.h
	gcc -Wall -c jouerPartie.c -o jouerPartie.o

affichageGrille.o : affichageGrille.c affichageGrille.h
	gcc -Wall -c affichageGrille.c -o affichageGrille.o

main.o : main.c main.h
	gcc -Wall -c main.c -o main.o

clean:
	rm -rf *.o

