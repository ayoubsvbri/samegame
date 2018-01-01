# mettre les grilles en globales
# optimiser le programme en enlevant les constantes en dur		
		.data
grilleBille:	.space 100	# 1 octet pour pour chaque case sachant qu'on utilise une grille 8x8
grilleSupprimer:.space 64
		.align 2
dimensionGrille:.word 8
table_switch:	.word CASE_0, CASE_1, CASE_2, CASE_3, DEFAULT
caseVide:	.asciiz "[ ]"
caseRouge:	.asciiz "[+]"	# rouge (1)
caseVerte:	.asciiz "[o]"	# vert (2)
caseBleue:	.asciiz "[*]"	# bleu (3)
caseErreur:	.asciiz "[?]"
chaineChiffres:	.asciiz "  1  2  3  4  5  6  7  8 "
mess:		.asciiz "\nChoississez une ligne et une colonne : \n"
coupInvalide:	.asciiz "\n Coup invalide, veuillez choisir une ligne et une colonne : \n"
newLine:	.asciiz "\n"


		.text
main:
		jal fctRemplirGrille		# OUV remplie grilleBille
		jal fctAfficherGrille		# OUV
		jal fctChoisirCase		# OUV $v0 -> ligne $v1 -> colonne
		jal fctSelectionnerBloc		# OUV prend $v0 et $v1 en entrée et modifie grilleSupprimer
		jal fctSupprimerBille		# OUV
		jal fctAfficherGrille		# OUV
		
		ori $v0, $zero, 10		# Terminer programme
		syscall
				
fctAfficherCase: 				# a0: couleur de la case (0,1,2,3 = vide, rouge, vert, bleu)
		addiu $sp, $sp -8		# PRO on ajuste $sp
		sw $ra, 0($sp)			# PRO sauvegarde $ra
		sw $fp, 4($sp)			# PRO sauvegarde $fp
		addiu $fp, $sp, 8		# PRO on ajuste $fp
		ori $v0, $0, 4			# Code service pour afficher ch. car
		ori $t0, $0, 3			# 3 est le nombre de symbole utilisé
		bgt $a0, $t0, DEFAULT		# si a0 contient une valeur sup à 3 -> DEFAULT
 		or $t0, $0, $a0			# On charge le parametre dans t0
 	
 		switch:
 			sll $t0, $t0, 2		# t0 <- t0 x 4 (car on va manipuler des adresse sur 4 octets)
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
		
		li $v0, 42            			# Service 42, nombre aléatoire compris entre 0 et a1
		ori $a1, $a1, 3				# nombre aléatoire entre 0 et 2 inclus
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
 		addi $s3, $s3, 11			# on se place à la première case à remplir
 		
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
		
		la $a0, mess				# "Choisissez une ligne et une colonne : "
		ori $v0, $zero, 4			# Code service pour afficher une chaine de caractere
		syscall
		
		ori $v0, $zero, 12			# Code service pour lire charactere
		syscall					# ligne retourné dans v0
		
		or $s0, $zero, $v0  			# caractère stocké dans s0
		
		ori $v0, $zero, 5			# Code service pour lire entier
		syscall					# colonne retourné dans v0
		
		or $s1, $zero, $v0			# colonne stocké dans s1
		
		or $v0, $zero, $s0			# v0 <- s0 (ligne <- caractère ASCII)	
		or $v1, $zero, $s1			# v1 <- s1 (colonne)
			
		lw $ra, 0($sp)				# EPI
 		lw $fp, 4($sp)				
 		addiu $sp, $sp, 8
 		jr $ra
 		
 fctSelectionnerBloc:					# commencer avec une bille a supprimer puis le bloc
 							# la fonction prend en entree $v0 (ligne) et $v1 (colonne) rentrés par l'utilisateur
 							
 		addiu $sp, $sp -16			# PRO on ajuste $sp
		sw $ra, 0($sp)				# PRO sauvegarde $ra
		sw $fp, 12($sp)				# PRO sauvegarde $fpa	
		addiu $fp, $sp, 16			# PRO on ajuste $fp
		sw $v0, 4($sp)				# PRO sauvegarde Y (ligne)
		sw $v1, 8($sp)				# PRO sauvegarde X (colonne)
 		
 		subi $s0, $v0, 'A'			# s0 <- n. ligne (entre 0 et 7)
 		or $s1, $zero, $v1			# s1 <- n. colonne (entre 1 et 8)
 		
 		subi $s1, $s1, 1			# s1-- (colonne-1)
 		
 		la $t1, dimensionGrille			# t1 <- @dimensionGrille
 		lw $t1, 0($t1)				# t1 <- dimensionGrille
 		
 		mult $s0, $t1				# (ligne)*8
 		mflo $t1				# t1 <- (ligne)*8
 		
 		add $t1, $t1, $s1			# t1 <- [(ligne)*8] + (colonne-1)
 		 
 		
 		la $t0, grilleSupprimer			# t0 <- @grilleSupprimer
 		add $t0, $t0, $t1			# @grilleSupprimer[ligne][colonne]
 		li $t2, 1				# t2 <- 1
 		sb $t2, 0($t0)				# grilleSupprimer[ligne][colonne] = 1
 		
 		lw $ra, 0($sp)				# EPI
 		lw $fp, 12($sp)				
 		addiu $sp, $sp, 16			
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
 		or $t1, $zero, $zero			# t1 <- i = 0 (compteur lignes)
 		or $t2, $zero, $zero			# t2 <- j = 0  (compteur colonnes)
		
		la $t3, grilleSupprimer 		# t3 <- @grilleSupprimer
		or $s4, $zero, $t3			# s4 <- t3
		or $s7, $zero, $zero			# s7 <- utilisé pour stockér s4 - t3
		or $v0, $zero, $zero			# v0 <- 0
		or $v1, $zero, $zero			# v1 <- 0
 		
 		parcourirLignes:
 			   	   
 			 parcourirColonnes: lb $s5, 0($s4)			# s5 <- grilleSupprimer[i][j]
 			 		    beq $s5, $zero, suiteParcourir	# si s5 = 0 -> suiteParcourir
 			 		    sb $zero, 0($s4)			# grilleSupprimer[i][j] = 0
 			 		    sub $s7, $s4, $t3			# s7 <- s4 - t3
 			 		    div $s7, $s0			# afin d'obtenir le numéro de la case
 			 		    mflo $v0				# v0 <- ligne-1
 			 		    mfhi $v1				# v1 <- colonne-1
 			 		    addi $v0, $v0, 1			# v0 <- ligne
 			 		    addi $v1, $v1, 1			# v1 <- colonne
 			 		    j finParcourir 			
 			 		    
 			    suiteParcourir: addi $t2, $t2, 1			# j++
 			   		    addi $s4, $s4, 1			# @grilleSupprimer++
 			   		    bne  $t2, $s0, parcourirColonnes	# loopColonnes si j != dimensionGrille
 			   
 			   addi $t1, $t1, 1		# i++
 			   or $t2, $zero, $zero		# j=0
 			   bne $t1,$s0,parcourirLignes	# loopColonnes si i != dimensionGrille
		
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