# Code written by Ayoub SABRI
# assembly implementation of the game SAMEGAME
		
		.data
		
grilleBille:	.space 100			# regarder schéma de la representation en mémoire pour plus d'éxplication
grilleSupprimer:.space 100
quatreDirections: .space 4			# tableau utilisé pour repérer les cases adjacentes ayant la même couleur
		.align 2			# alignement en mémoire
coupsJoues:	.word 0
dimensionGrille:.word 8
nombreCouleurs: .word 4				# K : nombre de couleurs possibles (choisir un nombre entre 2 et 4 pour régler la difficulté)
table_switch:	.word CASE_0, CASE_1, CASE_2, CASE_3, CASE_4 DEFAULT
caseVide:	.asciiz "[ ]"
caseRouge:	.asciiz "[+]"			# rouge (1)
caseVerte:	.asciiz "[o]"			# vert (2)
caseBleue:	.asciiz "[*]"			# bleu (3)
caseJaune:	.asciiz "[$]"			# jaune (4)
caseErreur:	.asciiz "[?]"
chaineChiffres:	.asciiz "  1  2  3  4  5  6  7  8 "
mess:		.asciiz "\nChoississez une ligne et une colonne : \n"
coupInvalide:	.asciiz "\nCoup invalide ! Veuillez choisir une ligne et une colonne : \n"
messCoups:	.asciiz "\nCoups joués: "
messFinPartie:	.asciiz "\nPartie terminée, nombre de coups joués : "
newLine:	.asciiz "\n"

		.text
main:
		jal fctRemplirGrille		# OUV remplie grilleBille
		jal fctAfficherGrille		# OUV
		
    jouerPartie:jal fctPartieTerminee		# OUV
    		beq $v0, $zero, finPartie	# si v0 = 0 -> finPartie				
		jal fctChoisirCase		# OUV $v0 -> ligne $v1 -> colonne
		jal fctSupprimerBloc		# OUV prend les arguments en v0 et v1
		jal fctSupprimerBille		# OUV
		jal fctAfficherGrille		# OUV
		
		j jouerPartie
		
finPartie:	la $a0, messFinPartie		# a0 <- @messFinPartie
		ori $v0, $zero, 4		# code service pour afficher une chaine de caractères
		syscall				# "Partie terminée"
		
		la $a0, coupsJoues
		lw $a0, 0($a0)
		ori $v0, $zero, 1		# code service pour afficher un entier
		syscall
		
		ori $v0, $zero, 10		# Terminer programme
		syscall
				
fctAfficherCase: 				# a0: couleur de la case (0,1,2,3,4 = vide, rouge, vert, bleu, jaune)
		addiu $sp, $sp -8		# PRO on ajuste $sp
		sw $ra, 0($sp)			# PRO sauvegarde $ra
		sw $fp, 4($sp)			# PRO sauvegarde $fp
		addiu $fp, $sp, 8		# PRO on ajuste $fp
		
		ori $v0, $0, 4			# Code service pour afficher ch. car
		
		la $t0, nombreCouleurs		# t0 <- @nombreCouleurs
		lw $t0, 0($t0)			# t0 <- nombreCouleurs
		bgt $a0, $t0, DEFAULT		# si a0 contient une valeur sup à nombreCouleurs -> DEFAULT
 		or $t0, $0, $a0			# On charge le parametre dans t0
 	
 		switch:
 			sll $t0, $t0, 2		# t0 <- t0 x 4 (car on va manipuler des adresses sur 4 octets)
 			la $t1, table_switch	# t1 <- table_switch
 			add $t2, $t0, $t1	# t2 <- @table_switch[k]
 			lw $t2, 0($t2)		# t2 <- ETQ_K
 			jr $t2
 			
 		CASE_0: la $a0, caseVide
 			syscall
 			j suite_switch
 		
 		CASE_1: la $a0, caseRouge
 			syscall
 			j suite_switch
 		
 		CASE_2: la $a0, caseVerte
 			syscall
 			j suite_switch
 		
 		CASE_3: la $a0, caseBleue
 			syscall
 			j suite_switch
 			
 		CASE_4: la $a0, caseJaune
 			syscall
 			j suite_switch
 			
 		DEFAULT:la $a0, caseErreur
 			syscall
 			j suite_switch
 			
 		suite_switch:
 			
 			sw $ra, 0($sp)		# EPI
 			lw $fp, 4($sp)				
 			addiu $sp, $sp, 8
 			jr $ra
 			
fctAfficherGrille:
 		
 		addiu $sp, $sp -8		# PRO on ajuste $sp
		sw $ra, 0($sp)			# PRO sauvegarde $ra
		sw $fp, 4($sp)			# PRO sauvegarde $fpa	
		addiu $fp, $sp, 8		# PRO on ajuste $fp
 		
 		la $s0, dimensionGrille		# s0 <- @dimensionGrille
 		lw $s0, 0($s0)			# s0 <- dimensionGrille
 		or $s1, $zero, $zero		# s1 <- i = 0 (compteur lignes)
 		or $s2, $zero, $zero		# s2 <- j = 0  (compteur colonnes)
 		ori $s6, $zero, 'A'		# s7 <- 'A'
 		la $s7, newLine			# s7 <- @newLine
 		la $s3, grilleBille 		# t3 <- @grilleBille
		addi $s3, $s3, 11		# pour se placer à la première case à afficher 
		 		 		
 		loopLignes:	   
 			   or $a0, $zero, $s6		# on affiche la lettre
 			   ori $v0, $zero, 11		# code service pour afficher un caractère
 	 		   syscall
 	 		   
 	 		   addi $s6, $s6, 1		# lettre suivante
 			   
 			   loopColonnes: lb $s4, 0($s3)			# on charge la valeur contenue dans la case
 			   		 or $a0, $zero, $s4		# parametre passé à la fonction
 			   		 sw $a0, 4($sp)			# OUV sauvegarde de a0
 			   		 jal fctAfficherCase
 			   		 lw $a0, 4($sp)			# FIN
 			   		 addi $s2, $s2, 1		# j++
 			   		 addi $s3, $s3, 1		# @grilleBille++
 			   		 bne  $s2, $s0, loopColonnes	# loopColonnes si j != dimensionGrille
 			   
 			   ori $v0, $zero, 4		# Code service pour afficher ch. car
 			   or $a0, $zero, $s7 		# a0 <- @newLine
 			   syscall			# retour à la ligne
 			   
 			   addiu $s3, $s3, 2		# sauter les deux cases vides en memoire
 			   addi $s1, $s1, 1		# i++
 			   or $s2, $zero, $zero		# j=0
 			   bne $s1,$s0,loopLignes	# loopColonnes si i != dimensionGrille

		ori $v0, $zero, 4			# code service pour afficher une ch car
 		la $a0, chaineChiffres
 		syscall
 			   	 			 		
 		lw $ra, 0($sp)				# EPI
 		lw $fp, 4($sp)				
 		addiu $sp, $sp, 8
 		jr $ra

fctRemplirCase:						#ne prend rien en entrée, retourne 1, 2 ou 3
		
		addiu $sp, $sp -8			# PRO on ajuste $sp
		sw $ra, 0($sp)				# PRO sauvegarde $ra
		sw $fp, 4($sp)				# PRO sauvegarde $fpa	
		addiu $fp, $sp, 8			# PRO on ajuste $fp
		
		la $t0, nombreCouleurs			# t0 <- @nombreCouleurs
		lw $t0, 0($t0)				# t0 <- nombreCouleurs
		
		li $v0, 42            			# Service 42, nombre aléatoire compris entre 0 et a1
		or $a1, $zero, $t0			# nombre aléatoire entre 0 et 2 inclus
		or $a0, $zero, $zero
		syscall                			# nombre généré retourné dans a0

		addi $a0, $a0, 1			# On rajoute 1 pour faire en sorte que le nombre généré soit compris entre 1 et 3 inclus
		or $v0, $zero, $a0			# valeur à retourner (1, 2, ou 3)
		
		lw $ra, 0($sp)				# EPI
 		lw $fp, 4($sp)				
 		addiu $sp, $sp, 8
 		jr $ra

fctRemplirGrille:
		
		addiu $sp, $sp -8			# PRO on ajuste $sp
		sw $ra, 0($sp)				# PRO sauvegarde $ra
		sw $fp, 4($sp)				# PRO sauvegarde $fpa	
		addiu $fp, $sp, 8			# PRO on ajuste $fp
		
		la $s0, dimensionGrille			# s0 <- @dimensionGrille
 		lw $s0, 0($s0)				# s0 <- dimensionGrille
 		ori $s1, $zero, 0			# s1 <- i = 0 (compteur lignes)
 		ori $s2, $zero, 0			# s2 <- j = 0  (compteur colonnes)
		
		
		la $s3, grilleBille 			# s3 <- @grilleBille
 		add $s3, $s3, $s0
 		addi $s3, $s3, 3			# on se place à la première case à remplir
 		
 		remplirLignes:
 			   	   
 			   remplirColonnes: jal fctRemplirCase
 			   		    sb $v0, 0($s3)			# v0 -> grilleBille[i][j]
 			   		    addi $s2, $s2, 1			# j++
 			   		    addi $s3, $s3, 1			# @grilleBille++
 			   		    bne  $s2, $s0, remplirColonnes	# loopColonnes si j != dimensionGrille
 			   
 			   addiu $s3, $s3, 2		# sauter les deux cases vides en memoire
 			   addi $s1, $s1, 1		# i++
 			   or $s2, $zero, $zero		# j=0
 			   bne $s1,$s0,remplirLignes	# loopColonnes si i != dimensionGrille
								
		lw $ra, 0($sp)				# EPI
 		lw $fp, 4($sp)				
 		addiu $sp, $sp, 8
 		jr $ra
 		
fctChoisirCase:						# La fonction retourne un caractère en $v0 (ligne) et un entier (colonne) en $v1
							# rajouter la fctEstCoupValide
							
		addiu $sp, $sp -8			# PRO on ajuste $sp
		sw $ra, 0($sp)				# PRO sauvegarde $ra
		sw $fp, 4($sp)				# PRO sauvegarde $fpa	
		addiu $fp, $sp, 8			# PRO on ajuste $fp
		
saisieCoordonnees:
		la $a0, mess				# "Choisissez une ligne et une colonne : "
		ori $v0, $zero, 4			# Code service pour afficher une chaine de caractere
		syscall
		
		ori $v0, $zero, 12			# Code service pour lire un caractère
		syscall					# ligne retournée dans v0
		
		or $s0, $zero, $v0  			# ligne (caractère ASCII) stocké dans s0
		
		ori $v0, $zero, 5			# Code service pour lire entier
		syscall					# colonne retourné dans v0
		
		or $s1, $zero, $v0			# colonne (entier) stocké dans s1
		
		estCoupValide:
				or $t0, $zero, $s0		# t0 <- ligne (caractère ASCII)
				or $t1, $zero, $s1		# t1 <- colonne (entier entre 1 et 8)
		
				la $t3, grilleBille		# t3 <- @grilleBille
				la $t4, dimensionGrille		# t4 <- @dimensionGrille
				lw $t4, 0($t4)			# t4 <- dimensionGrille
				addi $t4, $t4, 2		# t4 <- dimensionGrille + 2
				
				subi $t0, $t0, 'A'		# ligne (entier entre 0 et 7)
				addi $t0, $t0, 1		# ligne+1 (entier entre 1 et 8)
				
				mult $t0, $t4			# (ligne+1)*(dimensionGrille+2)
				mflo $t5			# t5 <- [(ligne+1)x(dimensionGrille+2)]
				add $t5, $t5, $t1		# t5 <- [(ligne+1)x(dimensionGrille+2)] + colonne
				
				add $t5, $t5, $t3		# t5 <- @grilleBille[ligne][colonne]
				lb $t6, 0($t5)			# t6 <- grilleBille[ligne][colonne]
				
				beq $t6, $zero, afficherErreur  # si on selectionne une case vide -> coupInvalide
				
				# bille en haut
				sub $t0, $t5, $t4		# t0 <- @grilleBille[ligne-1][colonne]
				lb $t1, 0($t0)			# t1 <- grilleBille[ligne-1][colonne]
				beq $t6, $t1, suiteChoisirCase	# Si case adjacentes égale -> suiteChoisirCase
				
				# bille à droite
				addi $t0, $t5, 1		# t0 <- @grilleBille[ligne][colonne+1]
				lb $t1, 0($t0)			# t1 <- grilleBille[ligne][colonne+1]
				beq $t6, $t1, suiteChoisirCase	# Si case adjacentes égale -> suiteChoisirCase
				
				# bille en bas
				add $t0, $t5, $t4		# t0 <- @grilleBille[ligne+1][colonne]
				lb $t1, 0($t0)			# t1 <- grilleBille[ligne+1][colonne]
				beq $t6, $t1, suiteChoisirCase	# Si case adjacentes égale -> suiteChoisirCase
				
				# bille à gauche
				subi $t0, $t5, 1		# t0 <- @grilleBille[ligne][colonne-1]
				lb $t1, 0($t0)			# t1 <- grilleBille[ligne][colonne-1]
				beq $t6, $t1, suiteChoisirCase	# Si case adjacentes égale -> suiteChoisirCase
				
		afficherErreur:	la $a0, coupInvalide		# a0 <- @ de la chaîne à afficher en cas d'erreur
				ori $v0, $zero, 4		# code service chaine de caractères
				syscall				# message d'erreur
				
				j saisieCoordonnees		# Pas de case adjacentes avec la même valeur -> saisieCoordonnees
				
suiteChoisirCase:
	
		la $t0, coupsJoues			# t0 <- @coupsJoues
		lw $t1, 0($t0)				# t1 <- coupsJoues
		addi $t1, $t1, 1			# coupsJoues++
		sw $t1, 0($t0)				# coupsJoues <- coupsJoues + 1
		
		ori $v0, $zero, 4			# code service pour afficher une ch car
 		la $a0, messCoups			# a0 <- @messCoups 
 		syscall					# afficher le nombre de coups joués
		
		ori $v0, $zero, 1			# code service pour afficher un entier
 		or $a0, $zero, $t1			# a0 <- t1 
 		syscall					# afficher le nombre de coups joués
		
		ori $v0, $zero, 4			# code service pour afficher une ch car
 		la $a0, newLine				# a0 <- @messCoups 
 		syscall					# afficher le nombre de coups joués
																																																				
		or $v0, $zero, $s0			# v0 <- s0 (ligne : caractère ASCII)	
		or $v1, $zero, $s1			# v1 <- s1 (colonne : entier)
		
		lw $ra, 0($sp)				# EPI
 		lw $fp, 4($sp)				
 		addiu $sp, $sp, 8
 		jr $ra
 		
fctCasesAdjacentes:					# rajouter la condition sur grilleSupprimer
							# fct prend en entrée $a0 = ligne (caractère), $a1 = colonne (entier) de la case à verifier
							# fct retourne v0 = 1 si il y au moins deux adjacentes et v0 = 0 sinon
							# elle modifie le tableau quatreDirections
 
 		addiu $sp, $sp -8			# PRO on ajuste $sp
		sw $ra, 0($sp)				# PRO sauvegarde $ra
		sw $fp, 4($sp)				# PRO sauvegarde $fpa	
		addiu $fp, $sp, 8			# PRO on ajuste $fp

		or $v0, $zero, $zero			# v0 <- 0
		or $t0, $zero, $a0			# t0 <- a0 (ligne)
		or $t1, $zero, $a1			# t1 <- a1 (colonne)

		la $t2, grilleSupprimer			# t2 <- @grilleSupprimer
		la $t3, grilleBille			# t3 <- @grilleBille
		
		la $t4, dimensionGrille			# t4 <- @dimensionGrille
		lw $t4, 0($t4)				# t4 <- dimensionGrille
		addi $t4, $t4, 2			# t4 <- dimensionGrille + 2
		
		subi $t0, $t0, 'A'			# t0 <- ligne (entier entre 0 et 7)
		addi $t0, $t0, 1			# t0 <- ligne+1 (entier entre 1 et 8)
				
		mult $t0, $t4				# (ligne+1)*(dimensionGrille+2)
		mflo $t5				# t5 <- [(ligne+1)x(dimensionGrille+2)]
		add $t5, $t5, $t1			# t5 <- [(ligne+1)x(dimensionGrille+2)] + colonne
		
		add $t3, $t5, $t3			# t3 <- @grilleBille[ligne][colonne]
		lb $t6, 0($t3)				# t6 <- grilleBille[ligne][colonne]
		
		add $t2, $t5, $t2			# t2 <- @grilleSupprimer[ligne][colonne]
		li $t0, 1
		sb $t0 , 0($t2)				# grilleSupprimer[ligne][colonne] = 1
		
		la $t5, quatreDirections		# t5 <- @quatreDirections
		sw $v0, 0($t5)				# quatreDirections = 0

		billeHaut:
		
		sub $t0, $t2, $t4			# t0 <- @grilleSupprimer[ligne-1][colonne]
		lb $t0, 0($t0) 				# t0 <- grilleSupprimer[ligne-1][colonne]
		bne $t0, $zero, billeDroite		# si grilleSupprimer[ligne-1][colonne] = 1 -> billeDroite
		
		sub $t1, $t3, $t4			# t1 <- @grilleBille[ligne-1][colonne]
		lb $t1, 0($t1)				# t1 <- grilleBille[ligne-1][colonne]
		bne $t6, $t1, billeDroite		# Si case adjacentes égale -> suiteChoisirCase
		li $v0, 1
		sb $v0, 0($t5)				# quatreDirections[0] = 1 
						
		billeDroite:
		
		addi $t0, $t2, 1			# t0 <- @grilleSupprimer[ligne][colonne+1]
		lb $t0, 0($t0) 				# t0 <- grilleSupprimer[ligne][colonne+1]
		bne $t0, $zero, billeBas		# si grilleSupprimer[ligne][colonne+1] = 1 -> billeBas
		
		addi $t1, $t3, 1			# t1 <- @grilleBille[ligne][colonne+1]
		lb $t1, 0($t1)				# t1 <- grilleBille[ligne][colonne+1]
		bne $t6, $t1, billeBas			# Si case adjacentes égale -> suiteChoisirCase
		li $v0, 1
		sb $v0, 1($t5)				# quatreDirections[1] = 1 
				
		billeBas:
		
		add $t0, $t2, $t4			# t0 <- @grilleSupprimer[ligne+1][colonne]
		lb $t0, 0($t0) 				# t0 <- grilleSupprimer[ligne+1][colonne]
		bne $t0, $zero, billeGauche		# si grilleSupprimer[ligne+1][colonne] = 1 -> billeGauche
		
		add $t1, $t3, $t4			# t1 <- @grilleBille[ligne+1][colonne]
		lb $t1, 0($t1)				# t1 <- grilleBille[ligne+1][colonne]
		bne $t6, $t1, billeGauche		# Si case adjacentes égale -> suiteChoisirCase
		li $v0, 1
		sb $v0, 2($t5)				# quatreDirections[2] = 1 
				
		billeGauche:
		
		subi $t0, $t2, 1			# t0 <- @grilleSupprimer[ligne][colonne-1]
		lb $t0, 0($t0) 				# t0 <- grilleSupprimer[ligne][colonne-1]
		bne $t0, $zero, suiteAdjacente		# si grilleSupprimer[ligne][colonne-1] = 1 -> billeBas
		
		subi $t1, $t3, 1			# t1 <- @grilleBille[ligne][colonne-1]
		lb $t1, 0($t1)				# t1 <- grilleBille[ligne][colonne-1]
		bne $t6, $t1, suiteAdjacente		# Si case adjacentes égale -> suiteChoisirCase
		li $v0, 1
		sb $v0, 3($t5)				# quatreDirections[3] = 1 
																		
suiteAdjacente:	lw $ra, 0($sp)				# EPI
 		lw $fp, 4($sp)				
 		addiu $sp, $sp, 8
 		jr $ra 							  					  					  
 		
fctSupprimerBloc:					# prend en entrée $v0 <- ligne (caractère) | $v1 <- colonne (entier)
		addiu $sp, $sp -24			# PRO on ajuste $sp
		sw $ra, 0($sp)				# PRO sauvegarde $ra
		sw $fp, 20($sp)				# PRO sauvegarde $fp
		addiu $fp, $sp, 24			# PRO on ajuste $fp
		
		or $a0, $zero, $v0			# PRO : a0 <- v0 
		or $a1, $zero, $v1			# PRO : a1 <- v1
		jal fctCasesAdjacentes
		beq $v0, $zero, finSupprimerBloc	# si v0 = 0 -> terminer fonction
		
		sw $a0, 8($sp)				# sauvegarde des paramètres dans la pile
		sw $a1, 12($sp)
		
		la $s0, quatreDirections		# s0 <- @quatreDirections
		lw $t0, 0($s0)				# t0 <- quatreDirections	
		sw $t0, 4($sp)				# Sauvegarde du tableau quatreDirection dans la pile
		
		supprimerHaut:
		lb $s1, 0($s0)				# s1 <- quatreDirections[0] 
		beq $s1, $zero, supprimerDroite
		subi $v0, $a0, 1			# v0 <- ligne-1 (caractère)
		or $v1, $zero, $a1			# v1 <- colonne (entier)
		jal fctSupprimerBloc			
		lw $t0, 4($sp)				# on restaure les éléments de quatreDirection après la recursion
		sw $t0, 0($s0)
		lw $a0, 8($sp)				# on restaure les paramètres stockés dans la pile
		lw $a1, 12($sp)
		
		supprimerDroite:
		lb $s1, 1($s0)				# s1 <- quatreDirections[1] 
		beq $s1, $zero, supprimerBas
		or $v0, $zero, $a0 			# v0 <- ligne
		addi $v1, $a1, 1			# v1 <- colonne+1
		jal fctSupprimerBloc			
		lw $t0, 4($sp)				# on restaure les éléments de quatreDirection après la recursion
		sw $t0, 0($s0)
		lw $a0, 8($sp)				# on restaure les paramètres stockés dans la pile
		lw $a1, 12($sp)
		
		supprimerBas:
		lb $s1, 2($s0)				# s1 <- quatreDirections[2] 
		beq $s1, $zero, supprimerGauche
		addi $v0, $a0, 1			# v0 <- ligne+1
		or $v1, $zero, $a1			# v1 <- colonne
		jal fctSupprimerBloc			
		lw $t0, 4($sp)				# on restaure les éléments de quatreDirection après la recursion
		sw $t0, 0($s0)
		lw $a0, 8($sp)				# on restaure les paramètres stockés dans la pile
		lw $a1, 12($sp)
		
		supprimerGauche:
		lb $s1, 3($s0)				# s1 <- quatreDirections[3] 
		beq $s1, $zero, finSupprimerBloc
		or $v0, $zero, $a0 			# v0 <- ligne
		subi $v1, $a1, 1			# v1 <- colonne-1
		jal fctSupprimerBloc			
		lw $t0, 4($sp)				# on restaure les éléments de quatreDirection après la recursion
		sw $t0, 0($s0)
		lw $a0, 8($sp)				# on restaure les paramètres stockés dans la pile
		lw $a1, 12($sp)
		
finSupprimerBloc:
		lw $ra, 0($sp)				# EPI
 		lw $fp, 20($sp)				
 		addiu $sp, $sp, 24
 		jr $ra 
 		 		 		
fctParcourirGrille: 					# La fct ne prend rien en entrée et retourne $v0 et $v1
 							# v0 <- ligne et v1 <- colonne de la bille a supprimer
							# si v0 et/ou v1 = 0 il n'y a rien a supprimer
 
 		addiu $sp, $sp -8			# PRO on ajuste $sp
		sw $ra, 0($sp)				# PRO sauvegarde $ra
		sw $fp, 4($sp)				# PRO sauvegarde $fp
		addiu $fp, $sp, 8			# PRO on ajuste $fp
		
		la $s0, dimensionGrille			# s0 <- @dimensionGrille
 		lw $s0, 0($s0)				# s0 <- dimensionGrille
 		or $t4 , $zero, $s0			# t4 <- diemnsionGrille
 		addi $s0, $s0, 2			# s0 <- dimensisionGrille + 2

  		or $t1, $zero, $zero			# t1 <- i = 0 (compteur lignes)
 		or $t2, $zero, $zero			# t2 <- j = 0  (compteur colonnes)
		
		la $t3, grilleSupprimer 		# s4 <- @grilleSupprimer
		or $s4, $zero, $t3			# s4 <- t3
		addi $s4, $s4, 11			# s4 <- grilleSupprimer[0][0]
		or $v0, $zero, $zero			# v0 <- 0
		or $v1, $zero, $zero			# v1 <- 0
 		
 		parcourirLignes:
 			   	   
 			 parcourirColonnes: lb $s5, 0($s4)			# s5 <- grilleSupprimer[i][j]
 			 		    beq $s5, $zero, suiteParcourir	# si s5 = 0 -> suiteParcourir
 			 		    sb $zero, 0($s4)			# grilleSupprimer[i][j] = 0
 			 		    sub $s7, $s4, $t3			# s7 <- s4 - t3
 			 		    div $s7, $s0			# afin d'obtenir le numéro de la case
 			 		    mflo $v0				# v0 <- ligne
 			 		    mfhi $v1				# v1 <- colonne
 			 		    j finParcourir 			
 			 		    
 			    suiteParcourir: addi $t2, $t2, 1			# j++
 			   		    addi $s4, $s4, 1			# @grilleSupprimer++
 			   		    bne  $t2, $t4, parcourirColonnes	# loopColonnes si j != dimensionGrille
 			   
 			   addi $s4, $s4, 2		# sauter les deux cases vides en mémoire
 			   addi $t1, $t1, 1		# i++
 			   or $t2, $zero, $zero		# j=0
 			   bne $t1,$t4,parcourirLignes	# loopColonnes si i != dimensionGrille
		
		finParcourir:
		lw $ra, 0($sp)				# EPI
 		lw $fp, 4($sp)				
 		addiu $sp, $sp, 8
 		jr $ra
 		
 fctSupprimerBille: 					# La fonction ne prend rien en entrée, elle se limite à manipuler grilleBille
 							# en fonction de la valeur retournée par fctParcourirGrille
 
 		addiu $sp, $sp -8			# PRO on ajuste $sp
		sw $ra, 0($sp)				# PRO sauvegarde $ra
		sw $fp, 4($sp)				# PRO sauvegarde $fp	
		addiu $fp, $sp, 8			# PRO on ajuste $fp
		
		la $s2, grilleBille			# s2 <- @grilleBille
		la $t0, dimensionGrille			# t2 <- @dimensionGrille
		lw $t0, 0($t0)				# t2 <- dimensionGrille
		addi $t0, $t0, 2			# t2 <- dimensionGrille + 2
			
								
 		tantQueSupprimer: or $s3, $zero, $s2			# s3 <- s2
 				  jal fctParcourirGrille		# Retourne : v0 <- ligne | v1 <- colonne
 				  beq $v0, $zero, suiteSupprimerBille	# si v0 = 0 ca veut dire qu'il n'y a pas de bille à supprimer 
 				  
 				  or $s0,$zero, $v0			# s0 <- v0 (ligne)				
				  or $s1,$zero, $v1			# s1 <- v1 (colonne)
 				  
 				  mult $s0, $t0				
 				  mflo $t2				# t2 <- ligne x (dimensionGrille+2)
 				  add $t2, $t2, $s1			# t2 <- (ligne x (dimensionGrille+2)) + colonne
 				  add $s3, $s3, $t2			# s3 <- adresse de la case à supprimer (w)
 				  sub $s4, $s3, $t0			# s4 <- adresse de la case au dessous de la case à supprimer (y)
 				  
 				  tantQueDecalage: 
 				  		   lb $t1, 0($s4)			# t1 <- grilleBille[ligne][colonne+1]
 				  		   sb $t1, 0($s3)			# t1 -> grilleBille[ligne][colonne]
 				  		   beq $t1, $zero, tantQueSupprimer 	# grilleBille[ligne][colonne] = 0 -> tantQueSupprimer
 				  		   sub $s3, $s3, $t0			# w++
 				  		   sub $s4, $s4, $t0			# y++
 				  		   j tantQueDecalage
 				  
 				  j tantQueSupprimer
 		
suiteSupprimerBille:
 
 		lw $ra, 0($sp)				# EPI
 		lw $fp, 4($sp)				
 		addiu $sp, $sp, 8
 		jr $ra
 		
fctPartieTerminee:

		addiu $sp, $sp -8			# PRO on ajuste $sp
		sw $ra, 0($sp)				# PRO sauvegarde $ra
		sw $fp, 4($sp)				# PRO sauvegarde $fp	
		addiu $fp, $sp, 8			# PRO on ajuste $fp
		
		or $v0, $zero, $zero			# v0 <- 0
		la $t2, grilleBille			# t2 <- @grilleBille
		
		la $t4, dimensionGrille			# t4 <- @dimensionGrille
		lw $t4, 0($t4)				# t4 <- dimensionGrille
		
		addi $t5, $t4, 2			# t5 <- dimensionGrille + 2
		add $t2, $t2, $t5			
		add $t2, $t2, 1				# t2 <- @grilleBille[0][0]
		
		or $t0, $zero, $zero			# t0 <- i = 0
		or $t1, $zero, $zero			# t1 <- j = 0
		
		termineeLignes:
 			   	   
 			 termineeColonnes:  lb $t3, 0($t2)			# t3 <- grilleBille[i][j]
 			 		    beq $t3, $zero, suiteTerminee	# si t3 = 0 -> suiteTerminee
 			 		    
 			 		    termineeHaut:
 			 		    sub $t6, $t2, $t5			# t6 <- @grilleBille[ligne-1][colonne]
 			 		    lb $t6, 0($t6)			# t6 <- grilleBille[ligne-1][colonne]
 			 		    bne $t3, $t6, termineeDroite	# si couleur diff. -> termineeDroite 
 			 		    li $v0, 1				# v0 <- 1
 			 		    j finTerminee
 			 		    
 			 		    termineeDroite:
 			 		    addi $t6, $t2, 1			# t6 <- @grilleBille[ligne][colonne+1]
 			 		    lb $t6, 0($t6)			# t6 <- grilleBille[ligne][colonne+1]
 			 		    bne $t3, $t6, termineeBas		# si couleur diff. -> termineeDroite 
 			 		    li $v0, 1
 			 		    j finTerminee
 			 		    
 			 		    termineeBas:
 			 		    add $t6, $t2, $t5			# t6 <- @grilleBille[ligne+1][colonne]
 			 		    lb $t6, 0($t6)			# t6 <- grilleBille[ligne+1][colonne]
 			 		    bne $t3, $t6, termineeGauche	# si couleur diff. -> termineeDroite 
 			 		    li $v0, 1				# v0 <- 1
 			 		    j finTerminee
 			 		    
 			 		    termineeGauche:
 			 		    subi $t6, $t2, 1			# t6 <- @grilleBille[ligne][colonne-1]
 			 		    lb $t6, 0($t6)			# t6 <- grilleBille[ligne][colonne-1]
 			 		    bne $t3, $t6, suiteTerminee		# si couleur diff. -> termineeDroite 
 			 		    li $v0, 1
 			 		    j finTerminee
 			 		    
 			    suiteTerminee:  addi $t1, $t1, 1			# j++
 			   		    addi $t2, $t2, 1			# @grilleBille++
 			   		    bne  $t1, $t4, termineeColonnes	# loopColonnes si j != dimensionGrille
 			   
 			   addi $t2, $t2, 2		# sauter les deux cases vides en mémoire
 			   addi $t0, $t0, 1		# i++
 			   or $t1, $zero, $zero		# j=0
 			   bne $t0,$t4,termineeLignes	# loopColonnes si i != dimensionGrille
		
finTerminee:	lw $ra, 0($sp)				# EPI
 		lw $fp, 4($sp)				
 		addiu $sp, $sp, 8
 		jr $ra
