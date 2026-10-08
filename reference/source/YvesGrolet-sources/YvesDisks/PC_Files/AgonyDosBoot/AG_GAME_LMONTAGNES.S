
***************************************************************************
*                                                                         *
*                                                                         *
*				            *
*		   A  G  O  N  Y		            *
*                          =================            	            *
*                                                                         *
*                                                                         *
*                                                                         *
*                             GAME MODULE                                 *
*                             -----------                                 *
*                                                                         *
*                          M O U N T A I N S                              *
*                          -----------------                              *
*                                                                         *
***************************************************************************


* by ART & MAGIC


* Artwork:        Franck Sauer
*	Marc Albinet

* Coding:	Yves Grolet
* Date:	25/06/1990
* Tab:            custom



***************************************************************************



* MACRO
* -----


Wait	MACRO
	DC.W	\1
	ENDM

SL_End	MACRO
	DC.W    $7fff
	ENDM

Start_R	MACRO
	DC.L	\1
	ENDM

Start_A	MACRO
	DC.L	\1+$40000000
	DC.W	\2
	DC.W	\3
	ENDM

Start_C	MACRO
	DC.L	\1+$80000000
	ENDM

Par	MACRO
	DC.W	\1
	ENDM

Par_l	MACRO
	DC.L	\1
	ENDM

Par_End	MACRO
	DC.W	-1
	ENDM






***************************************************************************

*	STRUCTURES

***************************************************************************



* ATTACK WAVE START LIST
* ----------------------


Start_List
	WAIT	$40
	START_A DGDP_Boulle,256+300,256+100

	WAIT	$80
	START_C	R_Bomber
                  PAR_END

	WAIT	$100
	START_A DGDP_Plasma,256+300,256+40

	Wait	$140
	START_C	R_Colonne_Flamme
	PAR_END

	WAIT	$180
	START_A DGDP_Cristal,256+300,256+20

	WAIT	$200
	START_A DGC_Boulle,256+300,256+150

	WAIT	$240
	START_C	R_Volant_missile
	PAR_END

	WAIT	$280
	START_C	R_Sol_Guide
	PAR	256+200
	PAR_END

	WAIT	$300
	START_A Pont_Boulle,256+300,256+190

	WAIT	$3c0
	START_C	R_Sol_Kamikaze
	PAR_END

	WAIT	$400
	START_A DGDP_Cristal,256+300,256

	WAIT	$430
	START_A DGMP_Plasma,256+300,256+220

	WAIT	$460
	START_A DGDP_Cristal,256+200,230

	WAIT	$490
	START_A DGMP_Plasma,256+250,256+200

	WAIT	$4b0
	START_A DGDP_Cristal,256+250,230

	WAIT	$4d0
	START_A DGMP_Plasma,256+200,256+220

	Wait	$500
	START_C	R_Colonne_Flamme
	PAR_END

	WAIT	$5f0
	START_A BHBH_Cristal,256+200,235

	WAIT	$600
	START_C	R_Sol_Guide
	PAR	256+200
	PAR_END

	WAIT	$640
	START_C	R_Sol_Guide
	PAR	256+180
	PAR_END

	WAIT	$650
	START_C	R_Volant_missile
	PAR_END

	WAIT	$660
	START_A DGMP_Plasma,256+200,256+220

	WAIT	$680
	START_C	R_Sol_Guide
	PAR	256+150
	PAR_END

	WAIT	$690
	START_A DGDP_Boulle,256+300,256+100

	WAIT	$780
	START_A DGDP_Plasma_2,256+200,220

	WAIT	$7c0
	START_A DGDP_Plasma_2,256+100,220

	WAIT	$800
	START_A DGDP_Plasma_2,256+160,220

	WAIT	$840
	START_A DGDP_Plasma_2,256+50,220

	WAIT	$880
	START_A DGDP_Plasma_2,256+250,220

;	WAIT    $88a
;	START_R	Awsrt0

	WAIT	$8c0
	START_A DGDP_Plasma_2,256+120,220

	WAIT	$900
	START_C	R_Sol_Guide
	PAR	256+150
	PAR_END

	WAIT    $960
	START_R	Awsrt1

	WAIT    $96c
	START_R	Awsrt2

	WAIT	$a00
	START_A BHBH_Cristal,256+150,235

	Wait	$a80
	START_C	R_Colonne_Flamme
	PAR_END

                  WAIT	$b30
	START_C	R_Araignee
	PAR	150
	PAR     2
	PAR_END

	WAIT	$b80
	START_C	R_Sol_Guide
	PAR	256+200
	PAR_END

	WAIT	$bc0
	START_C	R_Sol_Guide
	PAR	256+180
	PAR_END

                  WAIT	$bc8
	START_C	R_Araignee
	PAR	100
	PAR     4
	PAR_END

	WAIT	$bd0
	START_A DGDP_Plasma_3,256+300,256+80

	WAIT	$c00
	START_C	R_Sol_Guide
	PAR	256+150
	PAR_END

                  WAIT	$c60
	START_C	R_Araignee
	PAR	150
	PAR     3
	PAR_END

	WAIT	$c70
	START_A DGDP_Plasma_3,256+300,256+120

	WAIT    $ce1
	START_R	Awsrt3

	WAIT    $ce5
	START_R	Awsrt4

	WAIT	$d00
	START_C	R_Sol_Kamikaze
	PAR_END

	WAIT	$d70
	START_C	R_Volant_missile
	PAR_END

	WAIT	$d80
	START_A DGDP_Plasma_2,256+120,220

	WAIT	$d90
	START_C	R_Sol_Kamikaze
	PAR_END

	WAIT	$dc0
	START_A DGDP_Plasma_2,256+80,220

	WAIT	$e00
	START_A DGDP_Plasma_2,256+160,220

	WAIT	$e40
	START_A DGDP_Plasma_2,256+100,220

	WAIT	$e80
	START_A DGDP_Plasma_4,256+200,220

	WAIT	$ec0
	START_A DGDP_Plasma_2,256+60,220

	WAIT    $ef0
	START_R	Awsrt5

	WAIT	$f00
	START_A DGDP_Plasma_4,256+140,220

	WAIT    $f05
	START_R	Awsrt6

	WAIT	$f40
	START_A DGDP_Plasma_4,256+220,220

	WAIT	$fa0
	START_C	R_Sol_Guide
	PAR	256+150
	PAR_END

	WAIT    $10ef
	START_R	Awsrt7

	WAIT	$1180
	START_C	R_Dragon
	PAR	256+60
	PAR_END

	WAIT	$1200
	START_C	R_Dragon
	PAR	256+140
	PAR_END

	WAIT	$127e
	START_C	R_Dragon
	PAR	256+60
	PAR_END

	WAIT	$1280
	START_C	R_Sol_Guide
	PAR	256+200
	PAR_END

	WAIT	$12c0
	START_C	R_Sol_Guide
	PAR	256+180
	PAR_END

	WAIT	$12f0
	START_C	R_Volant_missile
	PAR_END

	WAIT	$12fe
	START_C	R_Dragon
	PAR	256+140
	PAR_END

	WAIT	$1300
	START_C	R_Sol_Guide
	PAR	256+150
	PAR_END

	WAIT	$1380
	START_C	R_Dragon
	PAR	256+60
	PAR_END

	WAIT	$1400
	START_C	R_Dragon
	PAR	256+140
	PAR_END

                  WAIT	$1480
	START_C	R_Araignee
	PAR	150
	PAR     4
	PAR_END

	WAIT    $14f4
	START_R	Awsrt8

	WAIT    $1576
	START_R	Awsrt9

	WAIT	$1600
	START_C	R_Volant_missile
	PAR_END

	WAIT    $1651
	START_R	Awsrt10

	WAIT	$16a0
	START_A DGMP_Boulle,256+250,256+210

	WAIT	$1700
	START_C	R_Sol_Kamikaze
	PAR_END

	WAIT	$1710
	START_A DGDP_Cristal,256+300,256

	WAIT	$1740
	START_A DGDP_Cristal,256+250,240

;	WAIT    $176e
;	START_R	Awsrt11

;	WAIT    $17b4
;	START_R	Awsrt12

	WAIT	$17c0
	START_A DGC_Boulle,256+300,256+140

	WAIT	$1800
	START_C	R_Sol_Guide
	PAR	256+150
	PAR_END

	WAIT	$1840
	START_C	R_Sol_Kamikaze
	PAR_END

	WAIT	$1880
	START_C	R_Sol_Guide
	PAR	256+150
	PAR_END

	WAIT	$1890
	START_A BHBH_Cristal,256+150,235

	WAIT	$18c0
	START_C	R_Sol_Kamikaze
	PAR_END

	WAIT    $1946
	START_R	Awsrt13

	WAIT    $1968
	START_R	Awsrt14

	WAIT	$1980
	START_A DGDP_Plasma_4,256+40,220

	WAIT	$19c0
	START_A DGDP_Plasma_4,256+200,220

	WAIT	$19fe
	START_A Pont_Boulle,256+300,256+190

	WAIT	$1a00
	START_A DGDP_Plasma_4,256+150,220

	WAIT	$1a40
	START_A DGDP_Plasma_4,256+100,220

	WAIT	$1a80
	START_A DGDP_Plasma_4,256+80,220

	WAIT	$1ac0
	START_A DGDP_Plasma_4,256+130,220

	WAIT	$1af0
	START_C	R_Bomber
                  PAR_END

	WAIT	$1af8
	START_A DGMP_Plasma,256+200,256+200

	WAIT	$1b00
	START_C	R_Sol_Guide
	PAR	256+150
	PAR_END

	WAIT	$1b20
	START_A DGMP_Plasma,256+225,256+210

	WAIT	$1b40
	START_C	R_Sol_Kamikaze
	PAR_END

	WAIT	$1b60
	START_A DGMP_Plasma,256+250,256+200

	WAIT	$1b80
	START_C	R_Sol_Guide
	PAR	256+150
	PAR_END

	WAIT	$1bc0
	START_C	R_Sol_Kamikaze
	PAR_END

	WAIT    $1c42
	START_R	Awsrt15

	Wait	$1cd0
	START_C	R_Colonne_Flamme
	PAR_END

	WAIT	$1d00
	START_C	R_Sol_Guide
	PAR	256+150
	PAR_END

	WAIT	$1d40
	START_C	R_Sol_Kamikaze
	PAR_END

	WAIT	$1d80
	START_C	R_Sol_Guide
	PAR	256+150
	PAR_END

	WAIT	$1d90
	START_C	R_Volant_missile
	PAR_END

	WAIT	$1dc0
	START_C	R_Sol_Kamikaze
	PAR_END

	WAIT	$1dd0
	START_A DGDP_Cristal,256+300,256

	WAIT	$1e00
	START_C	R_Volant_missile
	PAR_END

	WAIT	$1e10
	START_A DGMP_Plasma,256+300,256+220

	WAIT	$1e40
	START_A DGDP_Cristal,256+250,240

	WAIT	$1e60
	START_A DGMP_Plasma,256+150,256+200

	WAIT	$1e80
	START_A DGMP_Plasma,256+250,256+220

	WAIT	$1ec0
	START_A DGDP_Cristal,256+300,256

	WAIT	$1f00
	START_A DGMP_Plasma,256+300,256+220

	WAIT	$1f20
	START_A DGMP_Plasma,256+100,256+200

	WAIT	$1f40
	START_A DGDP_Cristal,256+200,240

	WAIT    $2006
	START_R	Awsrt16

	WAIT	$2080
	START_A BHBH_Cristal,256+100,235

	Wait	$2100
	START_C	R_Colonne_Flamme
	PAR_END

	WAIT	$2300
                  START_C	R_Final
	PAR_END


	SL_END



* RELATIVE TRACKS START STRUCT
* ----------------------------


	INCLUDE	Game/lMontagnes_Rtr.s



* ABSOLUTE TRACKS START STRUCT
* ----------------------------


DGDP_Boulle
	DC.W	TX_DG_Descend_Plat_1 * AWS_Table_X_Off
	DC.W	TY_DG_Descend_Plat_1 * AWS_Table_Y_Off
	DC.W	Anim_Boulle	* AWS_Table_Obj_Off
	DC.B	30	* AWS_Alien_Rate
	DC.B	4	* AWS_Alien_Num
	DC.W	2	* AWS_Alien_Energy
	DC.B	18	* AWS_Alien_Bad_F
	DC.B	2	* AWS_Alien_F_Rate
	DC.B	-1	* AWS_Pal_Mod_Lin0
	DC.B	-1	* AWS_Pal_Mod_Lin1
	DC.B	-1	* AWS_Pal_Mod_Lin2
	DC.B	-1	* AWS_Pal_Mod_Lin3
	DC.B	-1	* AWS_Pal_Mod_Lin4
	DC.B	-1	* AWS_Pal_Mod_Lin5
	DC.W	-1	* AWS_Pal_Mod_Col1
	DC.W	-1	* AWS_Pal_Mod_Col2
	DC.W	-1	* AWS_Pal_Mod_Col3
	DC.W	-1	* AWS_Pal_Mod_Col7
	DC.W	-1	* AWS_Pal_Mod_Col5
	DC.W	-1	* AWS_Pal_Mod_Col4
	DC.W	-1	* AWS_Pal_Mod_Col6

DGDP_Plasma
	DC.W	TX_DG_Descend_Plat_2 * AWS_Table_X_Off
	DC.W	TY_DG_Descend_Plat_2 * AWS_Table_Y_Off
	DC.W	Anim_Plasma	* AWS_Table_Obj_Off
	DC.B	20	* AWS_Alien_Rate
	DC.B	5	* AWS_Alien_Num
	DC.W	3	* AWS_Alien_Energy
	DC.B	20	* AWS_Alien_Bad_F
	DC.B	2	* AWS_Alien_F_Rate
	DC.B	-1	* AWS_Pal_Mod_Lin0
	DC.B	-1	* AWS_Pal_Mod_Lin1
	DC.B	-1	* AWS_Pal_Mod_Lin2
	DC.B	-1	* AWS_Pal_Mod_Lin3
	DC.B	-1	* AWS_Pal_Mod_Lin4
	DC.B	-1	* AWS_Pal_Mod_Lin5
	DC.W	-1	* AWS_Pal_Mod_Col1
	DC.W	-1	* AWS_Pal_Mod_Col2
	DC.W	-1	* AWS_Pal_Mod_Col3
	DC.W	-1	* AWS_Pal_Mod_Col7
	DC.W	-1	* AWS_Pal_Mod_Col5
	DC.W	-1	* AWS_Pal_Mod_Col4
	DC.W	-1	* AWS_Pal_Mod_Col6

DGMP_Plasma
	DC.W	TX_DG_Monte_Plat_1	* AWS_Table_X_Off
	DC.W	TY_DG_Monte_Plat_1	* AWS_Table_Y_Off
	DC.W	Anim_Plasma	* AWS_Table_Obj_Off
	DC.B	20	* AWS_Alien_Rate
	DC.B	3	* AWS_Alien_Num
	DC.W	3	* AWS_Alien_Energy
	DC.B	14	* AWS_Alien_Bad_F
	DC.B	2	* AWS_Alien_F_Rate
	DC.B	-1	* AWS_Pal_Mod_Lin0
	DC.B	-1	* AWS_Pal_Mod_Lin1
	DC.B	-1	* AWS_Pal_Mod_Lin2
	DC.B	-1	* AWS_Pal_Mod_Lin3
	DC.B	-1	* AWS_Pal_Mod_Lin4
	DC.B	-1	* AWS_Pal_Mod_Lin5
	DC.W	-1	* AWS_Pal_Mod_Col1
	DC.W	-1	* AWS_Pal_Mod_Col2
	DC.W	-1	* AWS_Pal_Mod_Col3
	DC.W	-1	* AWS_Pal_Mod_Col7
	DC.W	-1	* AWS_Pal_Mod_Col5
	DC.W	-1	* AWS_Pal_Mod_Col4
	DC.W	-1	* AWS_Pal_Mod_Col6

DGDP_Plasma_2
	DC.W	TX_DG_Descend_Plat_9 * AWS_Table_X_Off
	DC.W	TY_DG_Descend_Plat_9 * AWS_Table_Y_Off
	DC.W	Anim_Plasma	* AWS_Table_Obj_Off
	DC.B	40	* AWS_Alien_Rate
	DC.B	4	* AWS_Alien_Num
	DC.W	1	* AWS_Alien_Energy
	DC.B	20	* AWS_Alien_Bad_F
	DC.B	2	* AWS_Alien_F_Rate
	DC.B	-1	* AWS_Pal_Mod_Lin0
	DC.B	-1	* AWS_Pal_Mod_Lin1
	DC.B	-1	* AWS_Pal_Mod_Lin2
	DC.B	-1	* AWS_Pal_Mod_Lin3
	DC.B	-1	* AWS_Pal_Mod_Lin4
	DC.B	-1	* AWS_Pal_Mod_Lin5
	DC.W	-1	* AWS_Pal_Mod_Col1
	DC.W	-1	* AWS_Pal_Mod_Col2
	DC.W	-1	* AWS_Pal_Mod_Col3
	DC.W	-1	* AWS_Pal_Mod_Col7
	DC.W	-1	* AWS_Pal_Mod_Col5
	DC.W	-1	* AWS_Pal_Mod_Col4
	DC.W	-1	* AWS_Pal_Mod_Col6

DGDP_Plasma_3
	DC.W	TX_DG_Descend_Plat_2 * AWS_Table_X_Off
	DC.W	TY_DG_Descend_Plat_2 * AWS_Table_Y_Off
	DC.W	Anim_Plasma	* AWS_Table_Obj_Off
	DC.B	30	* AWS_Alien_Rate
	DC.B	2	* AWS_Alien_Num
	DC.W	1	* AWS_Alien_Energy
	DC.B	18	* AWS_Alien_Bad_F
	DC.B	1	* AWS_Alien_F_Rate
	DC.B	-1	* AWS_Pal_Mod_Lin0
	DC.B	-1	* AWS_Pal_Mod_Lin1
	DC.B	-1	* AWS_Pal_Mod_Lin2
	DC.B	-1	* AWS_Pal_Mod_Lin3
	DC.B	-1	* AWS_Pal_Mod_Lin4
	DC.B	-1	* AWS_Pal_Mod_Lin5
	DC.W	-1	* AWS_Pal_Mod_Col1
	DC.W	-1	* AWS_Pal_Mod_Col2
	DC.W	-1	* AWS_Pal_Mod_Col3
	DC.W	-1	* AWS_Pal_Mod_Col7
	DC.W	-1	* AWS_Pal_Mod_Col5
	DC.W	-1	* AWS_Pal_Mod_Col4
	DC.W	-1	* AWS_Pal_Mod_Col6

DGDP_Plasma_4
	DC.W	TX_DG_Descend_Plat_9 * AWS_Table_X_Off
	DC.W	TY_DG_Descend_Plat_9 * AWS_Table_Y_Off
	DC.W	Anim_Plasma	* AWS_Table_Obj_Off
	DC.B	20	* AWS_Alien_Rate
	DC.B	6	* AWS_Alien_Num
	DC.W	1	* AWS_Alien_Energy
	DC.B	20	* AWS_Alien_Bad_F
	DC.B	2	* AWS_Alien_F_Rate
	DC.B	-1	* AWS_Pal_Mod_Lin0
	DC.B	-1	* AWS_Pal_Mod_Lin1
	DC.B	-1	* AWS_Pal_Mod_Lin2
	DC.B	-1	* AWS_Pal_Mod_Lin3
	DC.B	-1	* AWS_Pal_Mod_Lin4
	DC.B	-1	* AWS_Pal_Mod_Lin5
	DC.W	-1	* AWS_Pal_Mod_Col1
	DC.W	-1	* AWS_Pal_Mod_Col2
	DC.W	-1	* AWS_Pal_Mod_Col3
	DC.W	-1	* AWS_Pal_Mod_Col7
	DC.W	-1	* AWS_Pal_Mod_Col5
	DC.W	-1	* AWS_Pal_Mod_Col4
	DC.W	-1	* AWS_Pal_Mod_Col6

BHBH_Cristal
	DC.W	TX_Boucle_HBH	* AWS_Table_X_Off
	DC.W	TY_Boucle_HBH	* AWS_Table_Y_Off
	DC.W	Anim_Cristal	* AWS_Table_Obj_Off
	DC.B	20	* AWS_Alien_Rate
	DC.B	5	* AWS_Alien_Num
	DC.W	5	* AWS_Alien_Energy
	DC.B	18	* AWS_Alien_Bad_F
	DC.B	2	* AWS_Alien_F_Rate
	DC.B	-1	* AWS_Pal_Mod_Lin0
	DC.B	-1	* AWS_Pal_Mod_Lin1
	DC.B	-1	* AWS_Pal_Mod_Lin2
	DC.B	-1	* AWS_Pal_Mod_Lin3
	DC.B	-1	* AWS_Pal_Mod_Lin4
	DC.B	-1	* AWS_Pal_Mod_Lin5
	DC.W	-1	* AWS_Pal_Mod_Col1
	DC.W	-1	* AWS_Pal_Mod_Col2
	DC.W	-1	* AWS_Pal_Mod_Col3
	DC.W	-1	* AWS_Pal_Mod_Col7
	DC.W	-1	* AWS_Pal_Mod_Col5
	DC.W	-1	* AWS_Pal_Mod_Col4
	DC.W	-1	* AWS_Pal_Mod_Col6

DGDP_Cristal
	DC.W	TX_DG_Descend_Plat_4 * AWS_Table_X_Off
	DC.W	TY_DG_Descend_Plat_4 * AWS_Table_Y_Off
	DC.W	Anim_Cristal	* AWS_Table_Obj_Off
	DC.B	30	* AWS_Alien_Rate
	DC.B	6	* AWS_Alien_Num
	DC.W	1	* AWS_Alien_Energy
	DC.B	16	* AWS_Alien_Bad_F
	DC.B	2	* AWS_Alien_F_Rate
	DC.B	-1	* AWS_Pal_Mod_Lin0
	DC.B	-1	* AWS_Pal_Mod_Lin1
	DC.B	-1	* AWS_Pal_Mod_Lin2
	DC.B	-1	* AWS_Pal_Mod_Lin3
	DC.B	-1	* AWS_Pal_Mod_Lin4
	DC.B	-1	* AWS_Pal_Mod_Lin5
	DC.W	-1	* AWS_Pal_Mod_Col1
	DC.W	-1	* AWS_Pal_Mod_Col2
	DC.W	-1	* AWS_Pal_Mod_Col3
	DC.W	-1	* AWS_Pal_Mod_Col7
	DC.W	-1	* AWS_Pal_Mod_Col5
	DC.W	-1	* AWS_Pal_Mod_Col4
	DC.W	-1	* AWS_Pal_Mod_Col6

DGC_Boulle
	DC.W	TX_DG_Crolle_2	* AWS_Table_X_Off
	DC.W	TY_DG_Crolle_2	* AWS_Table_Y_Off
	DC.W	Anim_Boulle	* AWS_Table_Obj_Off
	DC.B	40	* AWS_Alien_Rate
	DC.B	4	* AWS_Alien_Num
	DC.W	2	* AWS_Alien_Energy
	DC.B	30	* AWS_Alien_Bad_F
	DC.B	2	* AWS_Alien_F_Rate
	DC.B	-1	* AWS_Pal_Mod_Lin0
	DC.B	-1	* AWS_Pal_Mod_Lin1
	DC.B	-1	* AWS_Pal_Mod_Lin2
	DC.B	-1	* AWS_Pal_Mod_Lin3
	DC.B	-1	* AWS_Pal_Mod_Lin4
	DC.B	-1	* AWS_Pal_Mod_Lin5
	DC.W	-1	* AWS_Pal_Mod_Col1
	DC.W	-1	* AWS_Pal_Mod_Col2
	DC.W	-1	* AWS_Pal_Mod_Col3
	DC.W	-1	* AWS_Pal_Mod_Col7
	DC.W	-1	* AWS_Pal_Mod_Col5
	DC.W	-1	* AWS_Pal_Mod_Col4
	DC.W	-1	* AWS_Pal_Mod_Col6

DGMP_Boulle
	DC.W	TX_DG_Monte_Plat_5	* AWS_Table_X_Off
	DC.W	TY_DG_Monte_Plat_5	* AWS_Table_Y_Off
	DC.W	Anim_Boulle	* AWS_Table_Obj_Off
	DC.B	10	* AWS_Alien_Rate
	DC.B	6	* AWS_Alien_Num
	DC.W	3	* AWS_Alien_Energy
	DC.B	10	* AWS_Alien_Bad_F
	DC.B	1	* AWS_Alien_F_Rate
	DC.B	-1	* AWS_Pal_Mod_Lin0
	DC.B	-1	* AWS_Pal_Mod_Lin1
	DC.B	-1	* AWS_Pal_Mod_Lin2
	DC.B	-1	* AWS_Pal_Mod_Lin3
	DC.B	-1	* AWS_Pal_Mod_Lin4
	DC.B	-1	* AWS_Pal_Mod_Lin5
	DC.W	-1	* AWS_Pal_Mod_Col1
	DC.W	-1	* AWS_Pal_Mod_Col2
	DC.W	-1	* AWS_Pal_Mod_Col3
	DC.W	-1	* AWS_Pal_Mod_Col7
	DC.W	-1	* AWS_Pal_Mod_Col5
	DC.W	-1	* AWS_Pal_Mod_Col4
	DC.W	-1	* AWS_Pal_Mod_Col6

Pont_Boulle
	DC.W	TX_Pont	* AWS_Table_X_Off
	DC.W	TY_Pont	* AWS_Table_Y_Off
	DC.W	Anim_Boulle	* AWS_Table_Obj_Off
	DC.B	5	* AWS_Alien_Rate
	DC.B	6	* AWS_Alien_Num
	DC.W	1	* AWS_Alien_Energy
	DC.B	18	* AWS_Alien_Bad_F
	DC.B	2	* AWS_Alien_F_Rate
	DC.B	-1	* AWS_Pal_Mod_Lin0
	DC.B	-1	* AWS_Pal_Mod_Lin1
	DC.B	-1	* AWS_Pal_Mod_Lin2
	DC.B	-1	* AWS_Pal_Mod_Lin3
	DC.B	-1	* AWS_Pal_Mod_Lin4
	DC.B	-1	* AWS_Pal_Mod_Lin5
	DC.W	-1	* AWS_Pal_Mod_Col1
	DC.W	-1	* AWS_Pal_Mod_Col2
	DC.W	-1	* AWS_Pal_Mod_Col3
	DC.W	-1	* AWS_Pal_Mod_Col7
	DC.W	-1	* AWS_Pal_Mod_Col5
	DC.W	-1	* AWS_Pal_Mod_Col4
	DC.W	-1	* AWS_Pal_Mod_Col6



* ANIMATION TABLE
* ---------------


__	MACRO
\1	EQU     *-Anim_Base
	ENDM

Anim_Base


 __ Anim_Boulle
	DC.W	Obj_Boulle_1
	DC.W	Obj_Boulle_2
	DC.W	Obj_Boulle_3
	DC.W	Obj_Boulle_4
	DC.W	Obj_Boulle_5
	DC.W	Obj_Boulle_6
	DC.W	Obj_Boulle_7
	DC.W	Obj_Boulle_8
	DC.W	Obj_Boulle_9
	DC.W	-1

 __ Anim_Plasma
	DC.W	Obj_Plasma_1
	DC.W	Obj_Plasma_2
	DC.W	Obj_Plasma_3
	DC.W	Obj_Plasma_4
	DC.W	Obj_Plasma_5
	DC.W	Obj_Plasma_4
	DC.W	Obj_Plasma_3
	DC.W	Obj_Plasma_2
	DC.W	-1

 __ Anim_Cristal
	DC.W	Obj_Cristal_1
	DC.W	Obj_Cristal_1
	DC.W	Obj_Cristal_1
	DC.W	Obj_Cristal_1
	DC.W	Obj_Cristal_2
	DC.W	Obj_Cristal_2
	DC.W	Obj_Cristal_2
	DC.W	Obj_Cristal_3
	DC.W	Obj_Cristal_3
	DC.W	Obj_Cristal_3
	DC.W	Obj_Cristal_4
	DC.W	Obj_Cristal_4
	DC.W	Obj_Cristal_4
	DC.W	Obj_Cristal_4
	DC.W	Obj_Cristal_3
	DC.W	Obj_Cristal_3
	DC.W	Obj_Cristal_3
	DC.W	Obj_Cristal_2
	DC.W	Obj_Cristal_2
	DC.W	Obj_Cristal_2
	DC.W	-1

 __ Anim_Petite_Flamme
	DC.W	Obj_Petite_Flame_1
	DC.W	Obj_Petite_Flame_2
	DC.W	Obj_Petite_Flame_3
	DC.W	Obj_Petite_Flame_4
	DC.W	Obj_Petite_Flame_5
	DC.W	Obj_Petite_Flame_6
	DC.W	Obj_Petite_Flame_7
	DC.W	Obj_Petite_Flame_8
	DC.W	-1

 __ Anim_Spectre
	DC.W	Obj_Spectre_1
	DC.W	Obj_Spectre_1
	DC.W	Obj_Spectre_2
	DC.W	Obj_Spectre_2
	DC.W	-1






***************************************************************************

*                 ROUTINES

***************************************************************************



* MONSTRE VOLANT + TIR MISSILE GUIDE
* ----------------------------------


	RSRESET
R_VM_Mode	RS.W	1	* 0=Init 1=Monstre Folow
R_VM_Anim_Delay	RS.W	1
R_VM_Launch_Delay	RS.W	1	           1
R_VM_Fire_Mode	RS.W	1	* 0 none  4 2
R_VM_Target_X	RS.W	1                              3
R_VM_Target_Y	RS.W	1
R_VM_Time	RS.W	1


R_Volant_Missile
	move.l	Rout_Param_Ptr(a0),a1
	move.l	Rout_Awo_Ptr(a0),a2
	lea	Rout_Variables(a0),a3
	move	R_VM_Mode(a3),d0
	bne	.no_init
	move.l	#$00010000,(a2)+
	move	#256+200,Awo_Alien_X(a2)
	move	#220,Awo_Alien_Y(a2)
	move	#Obj_Volant_Missile_1,Awo_Alien_Obj_Off(a2)
	move	#20,AWO_Alien_Energy(a2)
	clr.l	Awo_Alien_Status(a2)
	clr     R_VM_Fire_Mode(a3)
	clr     R_VM_Time(a3)
	move	#25*5,R_VM_Launch_Delay(a3)
	addq	#1,R_VM_Mode(a3)
	bra	.end
.no_init
	move.l	#$00010000,(a2)+
	lea	AWO_Len(a2),a4
	subq	#1,d0
	bne	.end		* MODE 1
	tst	Die(D)
	bne	.stop_fire
	addq	#1,R_VM_Anim_Delay(a3)
	btst	#2,R_VM_Anim_Delay+1(a3)
	beq	.anim2
	move	#Obj_Volant_Missile_1,Awo_Alien_Obj_Off(a2)
	bra	.anim_end
.anim2
	move	#Obj_Volant_Missile_2,Awo_Alien_Obj_Off(a2)
.anim_end
	addq	#1,R_VM_Launch_Delay(a3)
	cmp     #25*7,R_VM_Launch_Delay(a3)
	bne	.next
.stop_fire
	move.b	AWO_Alien_Status(a4),d1
                  and	#$f,d1
	bne	.next
	move.b	#1,AWO_Alien_Status(a4)
.next
	cmp     #25*8,R_VM_Launch_Delay(a3)
	beq	.init_fire
                  move	R_VM_Fire_Mode(a3),d1
	beq	.no_fire
	move	#2,-4(a2)
	subq	#1,d1
	beq	.fmode1
	subq	#1,d1
	beq	.fmode2
	subq	#1,d1
	beq	.fmode3
.fmode4				* left
	subq	#2,AWO_Alien_X(a4)
	move	#Obj_Tir_7,Awo_Alien_Obj_Off(a4)
	move	AWO_Alien_X(a4),d1
	cmp	R_VM_Target_X(a3),d1
	bgt	.no_fire
	bra	.tacke_desision_fy
.fmode1				* up
	subq	#2,AWO_Alien_Y(a4)
	move	#Obj_Tir_1,Awo_Alien_Obj_Off(a4)
	move	AWO_Alien_Y(a4),d1
	cmp	R_VM_Target_Y(a3),d1
	bgt	.no_fire
	bra	.tacke_desision_fx
.fmode2				* right
	addq	#2,AWO_Alien_X(a4)
	move	#Obj_Tir_3,Awo_Alien_Obj_Off(a4)
	move	AWO_Alien_X(a4),d1
	cmp	R_VM_Target_X(a3),d1
	blt	.no_fire
	bra	.tacke_desision_fy
.fmode3				* down
	addq	#2,AWO_Alien_Y(a4)
	move	#Obj_Tir_5,Awo_Alien_Obj_Off(a4)
	move	AWO_Alien_Y(a4),d1
	cmp	R_VM_Target_Y(a3),d1
	bgt	.tacke_desision_fx
.no_fire
	cmp	#25*35,R_VM_Time(a3)
	bgt	.end
	move	AWO_Alien_Y(a2),d1
	sub	#40,d1
	cmp	Sorcerer_Y(D),d1
	beq	.cont
	bgt	.plus
	addq	#1,AWO_Alien_Y(a2)
	bra	.cont
.plus
	subq	#1,AWO_Alien_Y(a2)
.cont
	move	AWO_Alien_X(a2),d1
	sub	#100,d1
	cmp	Sorcerer_X(D),d1
	beq	.end
	bgt	.plus2
	addq	#1,AWO_Alien_X(a2)
	bra	.end
.plus2
	subq	#1,AWO_Alien_X(a2)
.end
	lea	R_VM_Time(a3),a4
	addq	#1,(a4)
	cmp	#25*45,(a4)
                  blt	.no_close
	move.l	#-1,(a0)	* CLOSE
	move	#-1,-4(a2)
	tst	Rout_Mod_Pal_Counter(D)
	bne	.no_close_col
	move.l	#-1,Rout_Pal_Ptr(D)
	st	Refresh_Pal+1(D)
.no_close_col
.no_close
	cmp	#25*35,(a4)
	blt	.no_exit
	subq	#1,AWO_Alien_Y(a2)
.no_exit
	rts


.init_fire
                  cmp.b	#$f,AWO_Alien_Status(a2)
	beq	.end
	clr     R_VM_Launch_Delay(a3)
	move	Awo_Alien_X(a2),Awo_Alien_X(a4)
	move	Awo_Alien_Y(a2),Awo_Alien_Y(a4)
	move	#10,AWO_Alien_Energy(a4)
	clr.l	Awo_Alien_Status(a4)
.tacke_desision_fy
	move	Sorcerer_X(D),d1
	add	#16,d1
	move	Sorcerer_Y(D),d2
	add	#40,d2
	move	d1,R_VM_Target_X(a3)
	move	d2,R_VM_Target_Y(a3)
	cmp     AWO_Alien_Y(a4),d2
	beq	.y
                  blt	.plus3
	cmp	#4,R_VM_Fire_Mode(a3)
	beq	.oleft
	move	#Obj_Tir_4,Awo_Alien_Obj_Off(a4)
	move	#3,R_VM_Fire_Mode(a3)	* down
	bra	.end
.oleft
	move	#Obj_Tir_6,Awo_Alien_Obj_Off(a4)
	move	#3,R_VM_Fire_Mode(a3)	* down
	bra	.end
.plus3
	cmp	#4,R_VM_Fire_Mode(a3)
	beq	.oleft2
	move	#Obj_Tir_2,Awo_Alien_Obj_Off(a4)
	move	#1,R_VM_Fire_Mode(a3)	* up
	bra	.end
.oleft2
	move	#Obj_Tir_8,Awo_Alien_Obj_Off(a4)
	move	#1,R_VM_Fire_Mode(a3)	* up
	bra	.end
.y
	cmp     AWO_Alien_X(a4),d1
	bne	.ok2
	clr	R_VM_Fire_Mode(a3)
.ok2
	bgt	.plus4
	cmp	#1,R_VM_Fire_Mode(a3)
	beq	.oup
	move	#Obj_Tir_6,Awo_Alien_Obj_Off(a4)
	move	#4,R_VM_Fire_Mode(a3)	* left
	bra	.end
.oup
	move	#Obj_Tir_8,Awo_Alien_Obj_Off(a4)
	move	#4,R_VM_Fire_Mode(a3)	* left
	bra	.end
.plus4
	cmp	#1,R_VM_Fire_Mode(a3)
	beq	.oup2
	move	#Obj_Tir_4,Awo_Alien_Obj_Off(a4)
	move	#2,R_VM_Fire_Mode(a3)	* right
                  bra	.end
.oup2
	move	#Obj_Tir_2,Awo_Alien_Obj_Off(a4)
	move	#2,R_VM_Fire_Mode(a3)	* right
                  bra	.end

.tacke_desision_fx
	move	Sorcerer_X(D),d1
	add	#16,d1
	move	Sorcerer_Y(D),d2
	add	#40,d2
	move	d1,R_VM_Target_X(a3)
	move	d2,R_VM_Target_Y(a3)
	cmp     AWO_Alien_X(a4),d1
	beq	.y2
                  blt	.plus5
	cmp	#1,R_VM_Fire_Mode(a3)
	beq	.oup3
	move	#Obj_Tir_4,Awo_Alien_Obj_Off(a4)
	move	#2,R_VM_Fire_Mode(a3)	* right
                  bra	.end
.oup3
	move	#Obj_Tir_2,Awo_Alien_Obj_Off(a4)
	move	#2,R_VM_Fire_Mode(a3)	* right
                  bra	.end
.plus5
	cmp	#1,R_VM_Fire_Mode(a3)
	beq	.oup4
	move	#Obj_Tir_6,Awo_Alien_Obj_Off(a4)
	move	#4,R_VM_Fire_Mode(a3)	* left
	bra	.end
.oup4
	move	#Obj_Tir_8,Awo_Alien_Obj_Off(a4)
	move	#4,R_VM_Fire_Mode(a3)	* left
	bra	.end
.y2
	cmp     AWO_Alien_Y(a4),d2
	bgt	.plus6
	cmp	#4,R_VM_Fire_Mode(a3)
	beq	.oleft3
	move	#Obj_Tir_2,Awo_Alien_Obj_Off(a4)
	move	#1,R_VM_Fire_Mode(a3)	* up
	bra	.end
.oleft3
	move	#Obj_Tir_8,Awo_Alien_Obj_Off(a4)
	move	#1,R_VM_Fire_Mode(a3)	* up
	bra	.end
.plus6
	cmp	#4,R_VM_Fire_Mode(a3)
	beq	.oleft4
	move	#Obj_Tir_4,Awo_Alien_Obj_Off(a4)
	move	#3,R_VM_Fire_Mode(a3)	* down
	bra	.end
.oleft4
	move	#Obj_Tir_6,Awo_Alien_Obj_Off(a4)
	move	#3,R_VM_Fire_Mode(a3)	* down
	bra	.end



* DROITE GAUCHE RAPIDE
* --------------------


	RSRESET
R_R_Mode	RS.W    1
R_R_Anim_D_Ptr	RS.L	1

	RSRESET
P_R_Anim_Ptr	RS.W	1
P_R_Speed	RS.W	1
P_R_Pal_Ptr	RS.L	1
P_R_Y	RS.W	1

Dummy_Pal
	DC.B	1	* Mod_Lin0
	DC.B	1	* Mod_Lin1
	DC.B	1	* Mod_Lin2
	DC.B	1	* Mod_Lin3
	DC.B	1	* Mod_Lin4
	DC.B	1	* Mod_Lin5
	DC.W	-1	* Mod_Col1
	DC.W	-1	* Mod_Col2
	DC.W	-1	* Mod_Col3
	DC.W	-1	* Mod_Col4
	DC.W	-1	* Mod_Col5
	DC.W	-1	* Mod_Col6
	DC.W	-1	* Mod_Col7

R_Rapide
	move.l	Rout_Param_Ptr(a0),a1
	move.l	Rout_Awo_Ptr(a0),a2
	lea	Rout_Variables(a0),a3

	move	R_R_Mode(a3),d0
	bne	.no_init
	move.l	#$00010000,(a2)+
	move	#256+340,Awo_Alien_X(a2)
	move	P_R_Y(a1),Awo_Alien_Y(a2)
                  lea	Anim_Base,a4
	add	P_R_Anim_Ptr(a1),a4
	move.l	a4,R_R_Anim_D_ptr(a3)
	move	(a4),Awo_Alien_Obj_Off(a2)
	move	#2,AWO_Alien_Energy(a2)
	clr.l	Awo_Alien_Status(a2)
	addq	#1,R_R_Mode(a3)
	bra	.end
.no_init
	move.l	#$00010000,(a2)+
	move	P_R_Speed(a1),d1
	sub	d1,AWO_Alien_X(a2)
                  move.l	R_R_Anim_D_Ptr(a3),a4
.reread
	addq.l	#2,R_R_Anim_D_Ptr(a3)
	move	(a4),d1
	bpl	.ok
                  lea	Anim_Base,a4
	add	P_R_Anim_Ptr(a1),a4
	move.l	a4,R_R_Anim_D_ptr(a3)
	bra	.reread
.ok
	move    d1,AWO_Alien_Obj_Off(a2)

	cmp	#200,AWO_Alien_X(a2)
	bgt	.end
	move.l	#-1,(a0)	* CLOSE
	move	#-1,-4(a2)
	tst	Rout_Mod_Pal_Counter(D)
	bne	.no_close_col
	move.l	#-1,Rout_Pal_Ptr(D)
	st	Refresh_Pal+1(D)
.no_close_col
.end
	rts



* SOL FONSSE SUR LE PERSO
* -----------------------


	RSRESET
R_SK_Mode	RS.W    1
R_SK_Shape_Num	RS.W	1

R_SK_Shape
	DC.W	Obj_Sol_Kamikaze_1
	DC.W	Obj_Sol_Kamikaze_2
	DC.W	Obj_Sol_Kamikaze_3
	DC.W	Obj_Sol_Kamikaze_4
	DC.W	Obj_Sol_Kamikaze_3
	DC.W	Obj_Sol_Kamikaze_2

R_Sol_Kamikaze
	move.l	Rout_Param_Ptr(a0),a1
	move.l	Rout_Awo_Ptr(a0),a2
	lea	Rout_Variables(a0),a3

	move	R_sk_Mode(a3),d0
	bne	.no_init
	move.l	#$00010000,(a2)+
	move	#256+340,Awo_Alien_X(a2)
	move	#256+190,Awo_Alien_Y(a2)
	move	#Obj_Sol_Kamikaze_1,Awo_Alien_Obj_Off(a2)
	move	#3,AWO_Alien_Energy(a2)
;	move.l	#$00160000,Awo_Alien_Status(a2)
	clr.l	Awo_Alien_Status(a2)
	addq	#1,R_sk_Mode(a3)
	bra	.end
.no_init
	move.l	#$00010000,(a2)+
	addq	#1,R_SK_Shape_Num(a3)
	cmp	#6,R_SK_Shape_Num(a3)
	bne	.ok
	clr	R_SK_Shape_Num(a3)
.ok
	move	R_SK_Shape_Num(a3),d1
	add	d1,d1
	lea	R_SK_Shape,a1
	move	(a1,d1.w),Awo_Alien_Obj_Off(a2)
	subq	#2,AWO_Alien_X(a2)
	subq	#1,d0
	bne	.mode2
	move    Sorcerer_Y(D),d1
	cmp	#256+120,d1
	blt	.end
	addq	#1,R_SK_Mode(a3)
	bra	.end
.mode2
	subq	#8,AWO_Alien_X(a2)
.end
	cmp	#220,AWO_Alien_X(a2)
	bgt	.no_close_col
	move.l	#-1,(a0)	* CLOSE
	move	#-1,-4(a2)
	tst	Rout_Mod_Pal_Counter(D)
	bne	.no_close_col
	move.l	#-1,Rout_Pal_Ptr(D)
	st	Refresh_Pal+1(D)
.no_close_col
	rts



* COLONNE DE FLAMME
* -----------------


	RSRESET
R_CF_Mode	RS.W    1
R_CF_Shape_Num_0	RS.W	1
R_CF_Shape_Num_1	RS.W	1
R_CF_Shape_Num_2	RS.W	1
R_CF_Shape_Num_3	RS.W	1
R_CF_Hight_Num	RS.W	1
R_CF_Hight_Delay	RS.W	1

R_CF_Shape
	DC.W	Obj_Grande_Flamme_1
	DC.W	Obj_Grande_Flamme_2
	DC.W	Obj_Grande_Flamme_3
	DC.W	Obj_Grande_Flamme_4
	DC.W	Obj_Grande_Flamme_5
	DC.W	Obj_Grande_Flamme_6
	DC.W	Obj_Grande_Flamme_7
	DC.W	Obj_Grande_Flamme_8
R_CF_Hight
	DC.W    1
	DC.W    1
	DC.W    1
	DC.W    1
	DC.W    1
	DC.W    1
	DC.W	1
	DC.W    2
	DC.W    3
	DC.W    4
	DC.W    4
	DC.W    4
	DC.W    4
	DC.W    4
	DC.W    3
	DC.W    2

R_Colonne_Flamme
	move.l	Rout_Param_Ptr(a0),a1
	move.l	Rout_Awo_Ptr(a0),a2
	lea	Rout_Variables(a0),a3

	move	R_CF_Mode(a3),d0
	bne	.no_init
	move.l	#$00010000,(a2)+
	lea	(a2),a4
	move	#256+190,d2
	moveq	#3,d1
.init_loop
	move	#256+360,Awo_Alien_X(a4)
	move	d2,Awo_Alien_Y(a4)
	move	#Obj_Grande_Flamme_1,Awo_Alien_Obj_Off(a4)
	move	#32767,AWO_Alien_Energy(a4)
	clr.l	Awo_Alien_Status(a4)
	lea	AWO_Len(a4),a4
	sub	#35,d2
	dbra	d1,.init_loop
	move.l	#$00000002,R_CF_Shape_Num_0
	move.l	#$00040006,R_CF_Shape_Num_2
	addq	#1,R_CF_Mode(a3)
	clr	R_CF_Hight_Num(a3)
	clr	R_CF_Hight_Delay(a3)
	bra	.end
.no_init
                  lea	R_CF_Shape_Num_0(a3),a1
                  lea	4(a2),a2
                  move.l	a2,a4
	moveq	#3,d2
.loop
	addq	#2,(a1)
	and	#$f,(a1)
	move	(a1)+,d1
	lea	R_CF_Shape,C
	move	(C,d1.w),Awo_Alien_Obj_Off(a4)
	subq	#2,AWO_Alien_X(a4)
	lea	AWO_Len(a4),a4
	dbra	d2,.loop
	lea	Custom,C

                  addq	#1,R_CF_Hight_Delay(a3)
	cmp	#3,R_CF_Hight_Delay(a3)
	bne	.end
	clr	R_CF_Hight_Delay(a3)
	addq	#2,R_CF_Hight_Num(a3)
	and	#$1f,R_CF_Hight_Num(a3)
	move	R_CF_Hight_Num(a3),d1
	lea     R_CF_Hight,a4
	move	(a4,d1.w),-4(a2)
.end
	cmp	#200,AWO_Alien_X(a2)
	bgt	.no_close_col
	move.l	#-1,(a0)	* CLOSE
	move	#-1,-4(a2)
	tst	Rout_Mod_Pal_Counter(D)
	bne	.no_close_col
	move.l	#-1,Rout_Pal_Ptr(D)
	st	Refresh_Pal+1(D)
.no_close_col
	rts



* ARAIGNEE DESCEND DE SON FIL
* ---------------------------


	RSRESET
R_A_Mode	RS.W    1
R_A_Anim_Step	RS.W	1
R_A_Y_Mode	RS.W	1

	RSRESET
P_A_Y_Start	RS.W	1
P_A_Step	RS.W	1

R_Araignee
	move.l	Rout_Param_Ptr(a0),a1
	move.l	Rout_Awo_Ptr(a0),a2
	lea	Rout_Variables(a0),a3

	move	R_A_Mode(a3),d0
	bne	.no_init
	move.l	#$00010000,(a2)+
	move	#256+340,Awo_Alien_X(a2)
	move	P_A_Y_Start(a1),Awo_Alien_Y(a2)
	move	#Obj_Araignee,Awo_Alien_Obj_Off(a2)
	move	#10,AWO_Alien_Energy(a2)
	clr.l	Awo_Alien_Status(a2)
	addq	#1,R_A_Mode(a3)
	clr	R_A_Y_Mode(a3)
	bra	.end
.no_init
	move.l	#$00010000,(a2)+
	tst     R_A_Y_Mode(a3)
	bne	.dec
                  move	P_A_Step(a1),d1
                  add	d1,Awo_Alien_Y(a2)
	cmp	#340,Awo_Alien_Y(a2)
	blt	.cont3
                  st	R_A_Y_Mode+1(a3)
	bra	.cont3
.dec
                  move	P_A_Step(a1),d1
                  sub	d1,Awo_Alien_Y(a2)
	cmp	#150,Awo_Alien_Y(a2)
	bgt	.cont3
                  clr	R_A_Y_Mode(a3)
.cont3
	subq	#2,AWO_Alien_X(a2)
	cmp	#200,AWO_Alien_X(a2)
	bgt	.end
	move.l	#-1,(a0)	* CLOSE
	move	#-1,-4(a2)
	tst	Rout_Mod_Pal_Counter(D)
	bne	.no_close_col
	move.l	#-1,Rout_Pal_Ptr(D)
	st	Refresh_Pal+1(D)
.no_close_col
.end
	rts



* GROS MONSTRE LARGUEUR DE BOMBE
* ------------------------------


	RSRESET
R_B_Table_Pos0	RS.B	1
R_B_Table_Pos1	RS.B	1
R_B_Table_Pos2	RS.B	1
R_B_Table_Pos3	RS.B	1
R_B_Mode	RS.W	1	* 0=Init 1=Dragon
R_B_Anim_Step	RS.W	1
R_B_Anim_Delay	RS.W	1
R_B_Launch_Delay	RS.W	1
R_B_Bomb_Num	RS.W	1
R_B_AWO_Index	RS.W	1


R_Bomber
	move.l	Rout_Param_Ptr(a0),a1
	move.l	Rout_Awo_Ptr(a0),a2
	lea	Rout_Variables(a0),a3

	move	R_B_Mode(a3),d0
	bne	.no_init
	move.l	#$00010000,(a2)+
	move	#256+340,Awo_Alien_X(a2)
	move	#256+32,Awo_Alien_Y(a2)
	move	#Obj_Sac,Awo_Alien_Obj_Off(a2)
	move	#15,AWO_Alien_Energy(a2)
	clr.l	Awo_Alien_Status(a2)
	addq	#1,R_B_Mode(a3)
	clr	R_B_Launch_Delay(a3)
	clr	R_B_AWO_Index(a3)
	move.b	#$0f,AWO_Alien_Status+AWO_Len(a2)
	move.b	#$0f,AWO_Alien_Status+AWO_Len*2(a2)
	move.b	#$0f,AWO_Alien_Status+AWO_Len*3(a2)
	move.b	#$0f,AWO_Alien_Status+AWO_Len*4(a2)
	move.b	#$0f,AWO_Alien_Status+AWO_Len*5(a2)
	bra	.end
.no_init
	move.l	#$00050000,(a2)+    	* MODE 1  ALLWAYS
	subq	#2,AWO_Alien_X(a2)
	cmp	#200,AWO_Alien_X(a2)
	bgt	.no_end
	move.l	#-1,(a0)	* CLOSE
	move	#-1,-4(a2)
	tst	Rout_Mod_Pal_Counter(D)
	bne	.no_close_col
	move.l	#-1,Rout_Pal_Ptr(D)
	st	Refresh_Pal+1(D)
.no_close_col
.no_end
	move	AWO_Alien_X(a2),d4
	move	R_B_Bomb_Num(a3),d1
	cmp	#4,d1
	beq	.no_new
	move.b	AWO_Alien_Status(a2),d2
	and	#$f,d2
	cmp	#$f,d2
	beq	.no_new
	addq	#1,R_B_launch_Delay(a3)
	cmp	#24,R_B_launch_Delay(a3)
	bne	.no_new
	clr	R_B_Launch_Delay(a3)

	addq	#1,R_B_Bomb_Num(a3)		* New Bomb
	add	#AWO_Len,R_B_AWO_Index(a3)
	move	R_B_AWO_Index(a3),d2
	lea	(a2,d2.w),a4
	move	#Obj_Boulle_1,AWO_Alien_Obj_Off(a4)
	move	#3,AWO_Alien_Energy(a4)
	move	#$00ff,AWO_Alien_Status(a4)
	clr.l	AWO_Alien_X(a4)
                  clr.b	R_B_Table_Pos0(a3,d1.w)
.no_new
	tst	d1
	beq	.end
	moveq	#0,d2
	lea	AWO_Len(a2),a2
.loop
	moveq	#0,d3
	move.b	R_B_Table_Pos0(a3,d2.w),d3
	bmi	.loop_end
	addq.b	#1,R_B_Table_Pos0(a3,d2.w)
	lea	Sin_Table1,a4
	move.b	(a4,d3.w),d5
	bpl	.ok
	st	R_B_Table_Pos0(a3,d2.w)
	bra	.loop_end
.ok
                  ext	d5
	sub	#256+172,d5
	neg	d5
	move	d5,AWO_Alien_Y(a2)
	move	d4,d5
                  sub	d3,d5
	sub	#30,d5
	move	d5,AWO_Alien_X(a2)
.loop_end
	lea	AWO_Len(a2),a2
	addq	#1,d2
	dbra	d1,.loop
.end
	rts



* SOL SAUTE GUIDE
* ---------------


	RSRESET
R_SG_Mode	RS.W    1

	RSRESET
P_SG_Launch	RS.W	1

R_Sol_Guide
	move.l	Rout_Param_Ptr(a0),a1
	move.l	Rout_Awo_Ptr(a0),a2
	lea	Rout_Variables(a0),a3

	move	R_SG_Mode(a3),d0
	bne	.no_init
	move.l	#$00010000,(a2)+
	move	#256+320,Awo_Alien_X(a2)
	move	#256+178,Awo_Alien_Y(a2)
	move	#Obj_Sol_Guide_0,Awo_Alien_Obj_Off(a2)
	move	#5,AWO_Alien_Energy(a2)
	clr.l	Awo_Alien_Status(a2)
	addq	#1,R_SG_Mode(a3)
	bra	.end
.no_init
	move.l	#$00010000,(a2)+
	subq	#1,d0
	beq	.mode1
	subq	#1,d0
	beq	.mode2
	subq	#1,d0
	beq	.mode3
	subq	#1,d0
	beq	.mode4
	subq	#1,d0
	beq	.mode5
	subq	#1,d0
	beq	.mode6
.mode1
	subq	#2,AWO_Alien_X(a2)
	move	AWO_Alien_X(a2),d0
	cmp	P_SG_Launch(a1),d0
	bne	.end
                  st	d2
                  move	Sorcerer_X(D),d1
	add	#20,d1
	sub	d1,d0
	bpl	.ok
	neg	d0
	moveq	#0,d2
.ok
	move	#350-40,d1
	sub	Sorcerer_Y(D),d1

                  cmp	#40,d0
	bgt	.no3
	move	#4,R_SG_Mode(a3)
	bra	.end
.no3
	tst	d2
	beq	.plus
	sub	d1,d0
	bpl	.ok2
	neg	d0
.ok2
	cmp	#70,d0
	bgt	.no2
	move	#3,R_SG_Mode(a3)
	bra	.end
.no2
	move	#2,R_SG_Mode(a3)
	bra	.end
.plus
	sub	d1,d0
	bpl	.ok3
	neg	d0
.ok3
	cmp	#70,d0
	bgt	.no4
	move	#5,R_SG_Mode(a3)
	bra	.end
.no4
	move	#6,R_SG_Mode(a3)
	bra	.end
.mode2
	move	#Obj_Sol_Guide_1,Awo_Alien_Obj_Off(a2)
	subq	#3,Awo_Alien_X(a2)
	subq	#1,Awo_Alien_Y(a2)
	bra	.end
.mode3
	move	#Obj_Sol_Guide_2,Awo_Alien_Obj_Off(a2)
	subq	#3,Awo_Alien_X(a2)
	subq	#3,Awo_Alien_Y(a2)
	bra	.end
.mode4
	move	#Obj_Sol_Guide_3,Awo_Alien_Obj_Off(a2)
	subq	#3,Awo_Alien_Y(a2)
	bra	.end
.mode5
	move	#Obj_Sol_Guide_4,Awo_Alien_Obj_Off(a2)
	addq	#3,Awo_Alien_X(a2)
	subq	#3,Awo_Alien_Y(a2)
	bra	.end
.mode6
	move	#Obj_Sol_Guide_5,Awo_Alien_Obj_Off(a2)
	addq	#3,Awo_Alien_X(a2)
	subq	#1,Awo_Alien_Y(a2)
.end
	move	Awo_Alien_X(a2),d0
	move	Awo_Alien_Y(a2),d1
	cmp	#200,d0
	blt	.close
	cmp	#256+330,d0
	bgt	.close
	cmp	#200,d1
	blt	.close
	rts
.close
	move.l	#-1,(a0)	* CLOSE
	move	#-1,-4(a2)
	tst	Rout_Mod_Pal_Counter(D)
	bne	.no_close_col
	move.l	#-1,Rout_Pal_Ptr(D)
	st	Refresh_Pal+1(D)
.no_close_col
	rts



* DRAGON
* ------


	RSRESET
R_D_Mode	RS.W	1	* 0=Init 1=Monstre Folow
R_D_Langue_Delay	RS.W	1
R_D_Langue_Step	RS.W	1
R_D_Shape	RS.W	1

	RSRESET
P_D_Y	RS.W	1


Dragon_Shape
	DC.W	Obj_Dragon_1
	DC.W	Obj_Dragon_1
	DC.W	Obj_Dragon_1
	DC.W	Obj_Dragon_1
	DC.W	Obj_Dragon_1
	DC.W	Obj_Dragon_1
	DC.W	Obj_Dragon_1
	DC.W	Obj_Dragon_2
	DC.W	Obj_Dragon_2
	DC.W	Obj_Dragon_2
Langue_Shape
                  DC.W	Obj_Fire_1
                  DC.W	Obj_Fire_1
                  DC.W	Obj_Fire_1
                  DC.W	Obj_Fire_1
                  DC.W	Obj_Fire_1
                  DC.W	Obj_Fire_1
                  DC.W	Obj_Fire_1
                  DC.W	Obj_Fire_1
                  DC.W	Obj_Fire_1
                  DC.W	Obj_Fire_1
                  DC.W	Obj_Fire_1
                  DC.W	Obj_Fire_1
                  DC.W	Obj_Fire_2
                  DC.W	Obj_Fire_3
                  DC.W	Obj_Fire_4
                  DC.W	Obj_Fire_5
                  DC.W	Obj_Fire_6
                  DC.W	Obj_Fire_7
                  DC.W	Obj_Fire_8

R_Dragon
	move.l	Rout_Param_Ptr(a0),a1
	move.l	Rout_Awo_Ptr(a0),a2
	lea	Rout_Variables(a0),a3

	move	R_D_Mode(a3),d0
	bne	.no_init
	move.l	#$00010000,(a2)+
	move	#256+350,Awo_Alien_X(a2)
	move	P_D_Y(a1),Awo_Alien_Y(a2)
	move	#Obj_Dragon_1,Awo_Alien_Obj_Off(a2)
	move	#8,AWO_Alien_Energy(a2)
	move.l	#$000a0000,Awo_Alien_Status(a2)
	addq	#1,R_D_Mode(a3)
                  rts
.no_init
	move.l	#$00010000,(a2)+
	addq	#2,R_D_Shape(a3)
	cmp	#20,R_D_Shape(a3)
	bne	.no
	clr	R_D_Shape(a3)
.no
	move	R_D_Shape(a3),d1
	lea	Dragon_Shape,a4
	move	(a4,d1.w),Awo_Alien_Obj_Off(a2)

	subq	#2,Awo_Alien_X(a2)
	cmp	#180,Awo_Alien_X(a2)
	ble	.close

	cmp	#2,d0
	beq	.mode2

	addq	#1,R_D_langue_Delay(a3)
	cmp	#30,R_D_langue_Delay(a3)
	bne	.end
                  move.b	AWO_Alien_Status(a2),d1
	and	#$f,d1
	cmp	#$f,d1
	beq	.end
	clr	R_D_langue_Delay(a3)
	move.l	#$00020000,-4(a2)
	lea	AWO_Len(a2),a4
	move    Awo_Alien_X(a2),d1
	sub	#190,d1
	move	d1,Awo_Alien_X(a4)
	move    Awo_Alien_Y(a2),Awo_Alien_Y(a4)
	move	#Obj_Fire_1,Awo_Alien_Obj_Off(a4)
	move	#100,AWO_Alien_Energy(a4)
	clr.l	Awo_Alien_Status(a4)
	addq	#1,R_D_Mode(a3)
	move	#-2,R_D_Langue_Step(a3)
	bra	.end
.mode2
                  move.b	AWO_Alien_Status(a2),d1
	and	#$f,d1
	bne	.end_l
	move.l	#$00020000,-4(a2)
	lea	AWO_Len(a2),a4
	subq	#2,Awo_Alien_X(a4)
	cmp	#Obj_Fire_8,Awo_Alien_Obj_Off(a4)
	bne	.skip
	sub	#12,Awo_Alien_X(a4)
.skip
	cmp	#130,Awo_Alien_X(a4)
                  ble	.end_l
	cmp	#Obj_Fire_8,Awo_Alien_Obj_Off(a4)
	beq	.end
	addq	#2,R_D_Langue_Step(a3)
	lea     Langue_Shape,a2
	move	R_D_Langue_Step(a3),d1
	move	(a2,d1.w),Awo_Alien_Obj_Off(a4)
	rts
.end_l
	subq	#1,R_D_Mode(a3)
.end
                  rts
.close
	move.l	#-1,(a0)	* CLOSE
	move	#-1,-4(a2)
	tst	Rout_Mod_Pal_Counter(D)
	bne	.no_close_col
	move.l	#-1,Rout_Pal_Ptr(D)
	st	Refresh_Pal+1(D)
.no_close_col
	rts



* MONSTRE FINAL
* -------------


	RSRESET
R_F_Mode	RS.W	1	* 0=Init 1=Monstre Folow
R_F_Masse_Delay	RS.W	1
R_F_Masse_Step	RS.W	1
R_F_Sens	RS.W	1

Masse_Shape
                  DC.W	Obj_Final_1
                  DC.W	Obj_Final_1
                  DC.W	Obj_Final_1
                  DC.W	Obj_Final_1
                  DC.W	Obj_Final_1
                  DC.W	Obj_Final_1
                  DC.W	Obj_Final_1
                  DC.W	Obj_Final_1
                  DC.W	Obj_Final_1
                  DC.W	Obj_Final_1
                  DC.W	Obj_Final_2
                  DC.W	Obj_Final_3
                  DC.W	Obj_Final_4
                  DC.W	Obj_Final_5
                  DC.W	Obj_Final_6
                  DC.W	Obj_Final_6
                  DC.W	Obj_Final_5
                  DC.W	Obj_Final_4
                  DC.W	Obj_Final_3
                  DC.W	Obj_Final_2

R_Final
	move.l	Rout_Param_Ptr(a0),a1
	move.l	Rout_Awo_Ptr(a0),a2
	lea	Rout_Variables(a0),a3

	move	R_F_Mode(a3),d0
	bne	.no_init
	move.l	#$00010000,(a2)+
	move	#256+240,Awo_Alien_X(a2)
	move	#256+300,Awo_Alien_Y(a2)
	move	#Obj_Final_0,Awo_Alien_Obj_Off(a2)
	move	#200,AWO_Alien_Energy(a2)
	move.l	#$000a0000,Awo_Alien_Status(a2)
	addq	#1,R_F_Mode(a3)
	clr	R_F_Sens(a3)
                  rts
.no_init
	move.l	#$00010000,(a2)+
	lea	Awo_len(a2),a4
                  move.b	AWO_Alien_Status(a2),d1
	and	#$f,d1
	cmp	#$f,d1
	beq	.close
	cmp	#2,d0
	beq	.mode2
	tst	R_F_Sens(a3)
	bne	.descend
	subq	#3,Awo_Alien_Y(a2)
	cmp	#256+104,Awo_Alien_Y(a2)
	bgt	.cont
	addq	#1,R_F_Sens(a3)
	bra	.cont
.descend
	addq	#3,Awo_Alien_Y(a2)
	cmp	#256+230,Awo_Alien_Y(a2)
	blt	.cont
	subq	#1,R_F_Sens(a3)
.cont
	move	Sorcerer_X(D),d1
	add	#200,d1
	cmp     Awo_Alien_X(a2),d1
	beq	.cont2
	blt	.gch
	cmp	#256+260,Awo_Alien_X(a2)
	beq	.cont2
	addq	#1,Awo_Alien_X(a2)
	bra	.cont2
.gch
	subq	#1,Awo_Alien_X(a2)
.cont2
	addq	#1,R_F_Masse_Delay(a3)
	cmp	#25,R_F_Masse_Delay(a3)
	bne	.end
	clr	R_F_Masse_Delay(a3)
	clr     R_F_Masse_Step(a3)
	addq	#1,R_F_Mode(a3)
	move    Awo_Alien_X(a2),d1
	sub	#210,d1
	move	d1,Awo_Alien_X(a4)
	move    Awo_Alien_Y(a2),Awo_Alien_Y(a4)
	move	#Obj_Final_1,Awo_Alien_Obj_Off(a4)
	move	#-1,AWO_Alien_Energy(a4)
	clr.l	Awo_Alien_Status(a4)
	bra	.end
.mode2
	move	#2,-4(a2)
	addq	#2,R_F_Masse_Step(a3)
	cmp	#40,R_F_Masse_Step(a3)
	bne	.cont3
	subq	#1,R_F_Mode(a3)
	rts
.cont3
	move	R_F_Masse_Step(a3),d1
	lea     Masse_Shape,a3
	move	(a3,d1.w),Awo_Alien_Obj_Off(a4)
.end
                  rts
.close
	move.l	#-1,(a0)	* CLOSE
	move	#-1,-4(a2)
	move	#25,Quit_Delay(D)
	st	Clean_Up(D)
	rts







***************************************************************************

*                 BINARY DATA

***************************************************************************



Relative_Tracks
	RINCBIN	Game/lmontagnes.rtb
Absolute_Tracks
	RINCBIN	Game/lmontagnes.atb
Sin_Table1
	RINCBIN	Game/Sin_Table1.bin
Sin_Table2
	RINCBIN	Game/Sin_Table2.bin
Sin_Table3
	RINCBIN	Game/Sin_Table3.bin




