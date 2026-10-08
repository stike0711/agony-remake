
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
*                            M A R S H E S                                *
*                            -------------                                *
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
	WAIT	$10
	START_A DGDP_Monster_3,256+300,256

	WAIT	$60
	START_A DGMS_Monster,256+250,256+200

	WAIT	$100
	START_A DGMP_Monster,256+280,256+200

	WAIT	$140
	START_C	R_Rapide
	PAR	Anim_Speedy
	PAR     8
	PAR_L   Dummy_Pal
                  PAR	256+100
	PAR_END

	WAIT	$150
	START_C	R_Rapide
	PAR	Anim_Speedy
	PAR     9
	PAR_L   Dummy_Pal
                  PAR	256+70
	PAR_END

	WAIT	$160
	START_C	R_Rapide
	PAR	Anim_Speedy
	PAR     10
	PAR_L   Dummy_Pal
                  PAR	256+40
	PAR_END

	WAIT	$1c0
	START_A DGDP_Monster_1,256+300,256

	WAIT	$200
	START_A DGDP_Monster_2,256+300,256+50

	WAIT	$240
	START_A DGDP_Monster_1,256+300,256+100

	WAIT	$280
	START_C	R_Tir_Etoile
	PAR     200+256
	PAR	80+256
	PAR_END

	WAIT	$300
	START_A DGDP_Monster_2,256+300,256+50

	WAIT	$340
	START_A DGDP_Monster_2,256+300,256+100

	WAIT	$380
	START_A DGDP_Monster_2,256+300,256+140

	WAIT	$3c0
	START_C	R_Jumper
	PAR_END

	WAIT	$3d0
	START_A BDGD_Monster,256+380,256+60

	WAIT	$500
	START_C	R_Sol_Kamikaze
	PAR_END

	WAIT	$540
	START_A DGDP_Monster_3,256+180,240

	WAIT	$580
	START_A DGDP_Monster_3,256+200,240

	WAIT	$585
	START_C R_Transporteur
	PAR     150+256
	PAR_END

	WAIT	$700
	START_R	Awsrt0

	WAIT	$720
	START_R	Awsrt1

	WAIT	$780
	START_C	R_Kamikaze
	PAR	25*6
	PAR     3
	PAR	2
	PAR_END

	WAIT	$790
	START_C	R_Kamikaze
	PAR	25*7
	PAR     2
	PAR     3
	PAR_END

	WAIT	$600
	START_A DGDP_Monster_1,256+300,256

	WAIT	$700
	START_A DGDC_Monster,256+300,256

	WAIT	$780
	START_A DGDP_Monster_3,256+300,256

 	WAIT	$880
	START_A DGDP_Monster_2,256+300,256+50

	WAIT	$8c0
	START_C R_Sol_Crache
	PAR     45
	PAR_END

	WAIT	$900
	START_C R_Sol_Crache
	PAR     40
	PAR_END

	WAIT	$940
	START_C R_Sol_Crache
	PAR     45
	PAR_END

	WAIT	$980
	START_C R_Sol_Crache
	PAR     50
	PAR_END

 	WAIT	$a00
	START_A DGDP_Monster_4,256+180,240

 	WAIT	$a80
	START_A DGDP_Monster_4,256+200,240

	WAIT	$b00
	START_C	R_Rapide
	PAR	Anim_Speedy
	PAR     10
	PAR_L   Dummy_Pal
                  PAR	256+40
	PAR_END

	WAIT	$b20
	START_C	R_Rapide
	PAR	Anim_Speedy
	PAR     9
	PAR_L   Dummy_Pal
                  PAR	256+80
	PAR_END

	WAIT	$b40
	START_C	R_Rapide
	PAR	Anim_Speedy
	PAR     8
	PAR_L   Dummy_Pal
                  PAR	256+120
	PAR_END

	WAIT	$b60
	START_C	R_Rapide
	PAR	Anim_Speedy
	PAR     7
	PAR_L   Dummy_Pal
                  PAR	256+160
	PAR_END

	WAIT	$b80
	START_A DGDP_Monster_1,256+300,256

	WAIT	$bb0
	START_A DGDP_Monster_1,256+300,256+50

	WAIT	$be0
	START_A DGDP_Monster_1,256+300,256+100

	WAIT	$c00
	START_C	R_Tir_Etoile
	PAR     180+256
	PAR	60+256
	PAR_END

	WAIT	$c80
	START_A Rond_Monster,256+300,256+10

	WAIT	$f00
	START_C	R_Jumper
	PAR_END

	WAIT	$f40
	START_C	R_Jumper
	PAR_END

	WAIT	$f80
	START_C	R_Jumper
	PAR_END

	WAIT	$fc0
	START_C	R_Jumper
	PAR_END

	WAIT	$1000
	START_C	R_Jumper
	PAR_END

 	WAIT	$1020
	START_A DGDP_Monster_4,256+200,240

	WAIT	$1040
	START_C	R_Volant_missile
	PAR_END

 	WAIT	$1050
	START_A DGDP_Monster_4,256+200,240

	WAIT	$1060
	START_C	R_Kamikaze
	PAR	25*7
	PAR     3
	PAR     3
	PAR_END

 	WAIT	$1100
	START_A DGDP_Monster_4,256+200,240

	WAIT	$1180
	START_C	R_Sol_Kamikaze
	PAR_END

	WAIT	$11c0
	START_C	R_Spectre	* Guided Spectre, Ground Start
	PAR	180+256	* Sp. Launch X
	PAR	25	* Sp. Fire Rate
	PAR	2	* X Speed
	PAR	1	* Y Speed
                  PAR_END

	WAIT	$1200
	START_C	R_Sol_Kamikaze
	PAR_END

	WAIT	$1210
	START_R	Awsrt2

	WAIT	$1220
	START_R	Awsrt3

	WAIT	$1240
	START_C	R_Spectre	* Guided Spectre, Ground Start
	PAR	180+256	* Sp. Launch X
	PAR	25	* Sp. Fire Rate
	PAR	2	* X Speed
	PAR	1	* Y Speed
                  PAR_END

	WAIT	$12c0
	START_C R_Transporteur
	PAR     130+256
	PAR_END

	WAIT	$12e0
	START_R	Awsrt4

	WAIT	$1300
	START_R	Awsrt5

	WAIT	$1320
	START_R	Awsrt6

	WAIT	$1360
	START_R	Awsrt7

	WAIT	$13d0
	START_R	Awsrt8

	WAIT	$14e0
	START_R	Awsrt9

	WAIT	$1500	* ??
	START_R	Awsrt10

	WAIT	$1520
	START_R	Awsrt11

	WAIT	$1540
	START_C	R_Sol_Kamikaze
	PAR_END

	WAIT	$1580
	START_C	R_Jumper
                  PAR_END

	WAIT	$15c0
	START_C	R_Sol_Kamikaze
	PAR_END

	WAIT	$15e0
	START_R	Awsrt12

	WAIT	$1600
	START_C	R_Jumper
                  PAR_END

	WAIT	$1680
	START_R	Awsrt13

	WAIT	$16a0
	START_R	Awsrt14

	WAIT	$16e0
	START_R	Awsrt15

	WAIT	$1700
	START_R	Awsrt16

	WAIT	$17c0
	START_C	R_Kamikaze
	PAR	25*6
	PAR     3
	PAR	2
	PAR_END

	WAIT	$17d0
	START_C	R_Kamikaze
	PAR	25*6
	PAR     2
	PAR     3
	PAR_END

	WAIT	$17e0
	START_C	R_Kamikaze
	PAR	25*6
	PAR     2
	PAR     1
	PAR_END

 	WAIT	$18a0
	START_A DGDP_Monster_4,256+200,240

	WAIT	$18f0
	START_C	R_Tir_Etoile
	PAR     180+256
	PAR	60+256
	PAR_END

	WAIT	$18f8
	START_A Rond_Monster,256+300,256+10

	WAIT	$1900
	START_C	R_Sol_Kamikaze
	PAR_END

	WAIT	$1940
	START_C	R_Sol_Kamikaze
	PAR_END

	WAIT	$1980
	START_C	R_Sol_Kamikaze
	PAR_END

	WAIT	$1b40
	START_C	R_Sol_Etoile
	PAR     140+256
	PAR_END

	WAIT	$1b80
	START_C	R_Sol_Etoile
	PAR     145+256
	PAR_END

	WAIT	$1bc0
	START_C	R_Sol_Etoile
	PAR     150+256
	PAR_END

	WAIT	$1c00
	START_C	R_Sol_Etoile
	PAR     155+256
	PAR_END

 	WAIT	$1c80
	START_A DGMS_Monster,256+230,256+200

	WAIT	$1d00
	START_C R_Sol_Crache
	PAR     45
	PAR_END

	WAIT	$1d40
	START_C	R_Spectre	* Guided Spectre, Ground Start
	PAR	180+256	* Sp. Launch X
	PAR	25	* Sp. Fire Rate
	PAR	3	* X Speed
	PAR	2	* Y Speed
                  PAR_END

	WAIT	$1d80
	START_C R_Sol_Crache
	PAR     40
	PAR_END

	WAIT	$1dc0
	START_C	R_Spectre	* Guided Spectre, Ground Start
	PAR	150+256	* Sp. Launch X
	PAR	25	* Sp. Fire Rate
	PAR	3	* X Speed
	PAR	3	* Y Speed
                  PAR_END

	WAIT	$1e40
	START_C	R_Volant_missile
	PAR_END

	WAIT	$1e60
	START_C	R_Volant_missile
	PAR_END

	WAIT	$1e80
	START_C R_Jumper
	PAR_END

	WAIT	$1ec0
	START_C	R_Spectre	* Guided Spectre, Ground Start
	PAR	180+256	* Sp. Launch X
	PAR	25	* Sp. Fire Rate
	PAR	3	* X Speed
	PAR	2	* Y Speed
                  PAR_END

	WAIT	$1900
	START_C R_Jumper
	PAR_END

	WAIT	$1940
	START_C	R_Spectre	* Guided Spectre, Ground Start
	PAR	150+256	* Sp. Launch X
	PAR	25	* Sp. Fire Rate
	PAR	3	* X Speed
	PAR	3	* Y Speed
                  PAR_END

 	WAIT	$1980
	START_A DGDC_Monster,256+250,256

	WAIT	$2000
	START_C	R_Kamikaze
	PAR	25*6
	PAR     3
	PAR     3
	PAR_END

	WAIT	$20a0
	START_R	Awsrt17

	WAIT	$20e0
	START_R	Awsrt18

	WAIT	$2100
	START_A BDGD_Monster,256+380,256+60

	WAIT	$2300
	START_C	R_Final
	PAR_END

	SL_END



* RELATIVE TRACKS START STRUCT
* ----------------------------


	INCLUDE	Game/lmarais_Rtr.s



* ABSOLUTE TRACKS START STRUCT
* ----------------------------


DGDP_Monster_1
	DC.W	TX_DG_Descend_Plat_1 * AWS_Table_X_Off
	DC.W	TY_DG_Descend_Plat_1 * AWS_Table_Y_Off
	DC.W	Anim_Monster_1	* AWS_Table_Obj_Off
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

DGDP_Monster_2
	DC.W	TX_DG_Descend_Plat_2 * AWS_Table_X_Off
	DC.W	TY_DG_Descend_Plat_2 * AWS_Table_Y_Off
	DC.W	Anim_Monster_2	* AWS_Table_Obj_Off
	DC.B	30	* AWS_Alien_Rate
	DC.B	4	* AWS_Alien_Num
	DC.W	2	* AWS_Alien_Energy
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

DGDP_Monster_3
	DC.W	TX_DG_Descend_Plat_4 * AWS_Table_X_Off
	DC.W	TY_DG_Descend_Plat_4 * AWS_Table_Y_Off
	DC.W	Anim_Monster_3	* AWS_Table_Obj_Off
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

DGDC_Monster
	DC.W	TX_DG_Descend_Crolle * AWS_Table_X_Off
	DC.W	TY_DG_Descend_Crolle * AWS_Table_Y_Off
	DC.W	Anim_Transporte	* AWS_Table_Obj_Off
	DC.B	30	* AWS_Alien_Rate
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

DGDP_Monster_4
	DC.W	TX_DG_Descend_Plat_9 * AWS_Table_X_Off
	DC.W	TY_DG_Descend_Plat_9 * AWS_Table_Y_Off
	DC.W	Anim_Monster_2	* AWS_Table_Obj_Off
	DC.B	20	* AWS_Alien_Rate
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

DGMS_Monster
	DC.W	TX_DG_Monte_Sin	* AWS_Table_X_Off
	DC.W	TY_DG_Monte_Sin	* AWS_Table_Y_Off
	DC.W	Anim_Monster_3	* AWS_Table_Obj_Off
	DC.B	30	* AWS_Alien_Rate
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

BDGD_Monster
	DC.W	TX_Boucle_DGD	* AWS_Table_X_Off
	DC.W	TY_Boucle_DGD	* AWS_Table_Y_Off
	DC.W	Anim_Kamikaze	* AWS_Table_Obj_Off
	DC.B	25	* AWS_Alien_Rate
	DC.B	6	* AWS_Alien_Num
	DC.W	5	* AWS_Alien_Energy
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

Rond_Monster
	DC.W	TX_Rond	* AWS_Table_X_Off
	DC.W	TY_Rond	* AWS_Table_Y_Off
	DC.W	Anim_Tir_Etoile	* AWS_Table_Obj_Off
	DC.B	30	* AWS_Alien_Rate
	DC.B	10	* AWS_Alien_Num
	DC.W	10	* AWS_Alien_Energy
	DC.B	40	* AWS_Alien_Bad_F
	DC.B	3	* AWS_Alien_F_Rate
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

DGMP_Monster
	DC.W	TX_DG_Monte_Plat_2	* AWS_Table_X_Off
	DC.W	TY_DG_Monte_Plat_2	* AWS_Table_Y_Off
	DC.W	Anim_Tir_Etoile	* AWS_Table_Obj_Off
	DC.B	20	* AWS_Alien_Rate
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



* ANIMATION TABLE
* ---------------


__	MACRO
\1	EQU     *-Anim_Base
	ENDM

Anim_Base


 __ Anim_Monster_1
	DC.W	Obj_Monster_1
	DC.W	-1

 __ Anim_Monster_2
	DC.W	Obj_Monster_2
	DC.W	-1

 __ Anim_Monster_3
	DC.W	Obj_Monster_3
	DC.W	-1

 __ Anim_Speedy
	DC.W	Obj_Speedy
	DC.W	-1

 __ Anim_Kamikaze
	DC.W	Obj_Kamikaze
	DC.W	-1

 __ Anim_Transporte
	DC.W	Obj_Transporte_1
	DC.W	Obj_Transporte_2
	DC.W	Obj_Transporte_3
	DC.W	-1

 __ Anim_Tir_Etoile
	DC.W	Obj_Tir_Etoile_1
	DC.W	Obj_Tir_Etoile_2
	DC.W	Obj_Tir_Etoile_3
	DC.W	Obj_Tir_Etoile_4
	DC.W	Obj_Tir_Etoile_5
	DC.W	Obj_Tir_Etoile_6
	DC.W	Obj_Tir_Etoile_7
	DC.W	Obj_Tir_Etoile_8
	DC.W	Obj_Tir_Etoile_9
	DC.W	-1






***************************************************************************

*                 ROUTINES

***************************************************************************



* SPECTRE + FIOLLE
* ----------------


	RSRESET
R_S_Mode	RS.W	1	* 0=Init 1=Fiole 2=Sp.Anim+Fiole 3=Sp.+Fiole
R_S_Anim_Step	RS.W	1
R_S_Anim_Delay	RS.W	1
R_S_Target_X	RS.W	1
R_S_Target_Y	RS.W	1
R_S_Target_Delay	RS.W	1
R_S_Time	RS.W	1

	RSRESET
P_S_Launch_X      RS.W	1
P_S_Fire_Rate	RS.W	1
P_S_X_Speed	RS.W	1
P_S_Y_Speed	RS.W	1

R_Spectre_Shape
	DC.W	Obj_Spectre_1
	DC.W	Obj_Spectre_2
	DC.W	Obj_Spectre_3
	DC.W	Obj_Spectre_4
	DC.W	Obj_Spectre_5

R_Spectre
	move.l	Rout_Param_Ptr(a0),a1
	move.l	Rout_Awo_Ptr(a0),a2
	lea	Rout_Variables(a0),a3
	move	R_S_Mode(a3),d0
	bne	.no_init
                                                              * MODE 0
	move.l	#$00010000,(a2)+
	move	#256+300,Awo_Alien_X(a2)
	move	#256+160,Awo_Alien_Y(a2)
	move	#Obj_Spectre_Pot,Awo_Alien_Obj_Off(a2)
	move	#5,AWO_Alien_Energy(a2)
	clr.l	Awo_Alien_Status(a2)
	addq	#1,R_S_Mode(a3)
	bra	.end
.no_init
	move.l	#$00010000,(a2)+    	* MODE 1  ALLWAYS
	lea	AWO_Len(a2),a4
	subq	#2,AWO_Alien_X(a2)
	move.b 	AWO_Alien_Status(a2),d1
	and	#$f,d1
	beq	.no_close
	cmp	#200,AWO_Alien_X(a2)
	blt	.close
.no_close
	move	P_S_Launch_X(a1),d1
	cmp	AWO_Alien_X(a2),d1
	bne	.no_start
	move.b 	AWO_Alien_Status(a2),d1
	and	#$f,d1
	bne	.no_start
 	move	#2,R_S_Mode(a3)
	move	#2,-4(a2)
	move    AWO_Alien_X(a2),AWO_Alien_X(a4)
	move    AWO_Alien_Y(a2),AWO_Alien_Y(a4)
	move	#Obj_Spectre_1,Awo_Alien_Obj_Off(a4)
	move	#2,AWO_Alien_Energy(a4)
	clr.l	Awo_Alien_Status(a4)
	move.b	P_S_Fire_Rate+1(a1),AWO_Alien_F_Rt_S(a4)
	clr	R_S_Anim_Step(a3)
	clr	R_S_Anim_Delay(a3)
	bra	.end
.no_start
                  subq	#2,d0
	bne	.no_mode2

	move	#2,-4(a2)		* MODE 2
	subq	#2,AWO_Alien_X(a4)
	eor     #1,R_S_Anim_Delay(a3)
	bne	.no
	lea     R_Spectre_Shape,a2
	move	R_S_Anim_Step(a3),d1
	addq	#2,R_S_Anim_Step(a3)
	move	(a2,d1.w),AWO_Alien_Obj_Off(a4)
	cmp	#2*4,d1
	bne	.no
	addq	#1,R_S_Mode(a3)
	move	#1,R_S_Target_Delay(a3)
	clr	R_S_Time(a3)
.no
	bra	.end
.no_mode2
                  subq	#1,d0
	bne	.end

	move	#2,-4(a2)		* MODE 3
	eor     #1,R_S_Anim_Delay(a3)
	beq	.cont2
	cmp	#Obj_Spectre_5,AWO_Alien_Obj_Off(a4)
	beq	.cont
	move	#Obj_Spectre_5,AWO_Alien_Obj_Off(a4)
	bra	.cont2
.cont
	move	#Obj_Spectre_4,AWO_Alien_Obj_Off(a4)
.cont2
                  subq	#1,R_S_Target_Delay(a3)
	bne	.cont3
	move	#18,R_S_Target_Delay(a3)
	move    Sorcerer_X(D),d1
                  add	#16,d1
	move	d1,R_S_Target_X(a3)
	move    Sorcerer_Y(D),d1
                  add	#40,d1
	move	d1,R_S_Target_Y(a3)
.cont3
	move	P_S_X_Speed(a1),d2
	move	AWO_Alien_X(a4),d1
	move	R_S_Target_X(a3),d3
	move	d3,d4
	sub	d1,d3
	bpl	.ok
	neg	d3
.ok
	cmp     d2,d3
	bgt	.ok2
	move    #1,R_S_Target_Delay(a3)
.ok2
	cmp	d4,d1
	blt	.cont4
	sub	d2,AWO_Alien_X(a4)
	bra	.cont5
.cont4
	add	d2,AWO_Alien_X(a4)
.cont5
	move	P_S_Y_Speed(a1),d2
	move	AWO_Alien_Y(a4),d1
	move	R_S_Target_Y(a3),d3
	move	d3,d4
	sub	d1,d3
	bpl	.ok3
	neg	d3
.ok3
	cmp     d2,d3
	bgt	.ok4
	move    #1,R_S_Target_Delay(a3)
.ok4
	cmp	d4,d1
	blt	.cont6
	sub	d2,AWO_Alien_Y(a4)
	bra	.cont7
.cont6
	add	d2,AWO_Alien_Y(a4)
.cont7
	addq	#1,R_S_Time(a3)
	cmp	#25*8,R_S_Time(a3)
	bne	.end
.close
	move.l	#-1,(a0)	* CLOSE
	move	#-1,-4(a2)

	tst	Rout_Mod_Pal_Counter(D)
	bne	.no_close_col
	move.l	#-1,Rout_Pal_Ptr(D)
	st	Refresh_Pal+1(D)
.no_close_col
	move.b	#1,AWO_ALien_Status(a4)
.end
	rts



* TIR EN ETOILE
* -------------


	RSRESET
R_TE_Mode	RS.W	1	* 0=Init 1=Monstre 2=M.+Tir
R_TE_Anim_Step	RS.W	1
R_TE_Anim_Delay	RS.W	1
R_TE_Fire_Step	RS.W	1
R_TE_Fire_X	RS.W	1
R_TE_Fire_Y	RS.W	1

	RSRESET
P_TE_Launch_X	RS.W	1
P_TE_Pos_Y	RS.W	1

R_Tir_Etoile_Shape
	DC.W	Obj_Tir_Etoile_1
	DC.W	Obj_Tir_Etoile_2
	DC.W	Obj_Tir_Etoile_3
	DC.W	Obj_Tir_Etoile_4
	DC.W	Obj_Tir_Etoile_5
	DC.W	Obj_Tir_Etoile_6
	DC.W	Obj_Tir_Etoile_7
	DC.W	Obj_Tir_Etoile_8
	DC.W	Obj_Tir_Etoile_9

R_Tir_Etoile
	move.l	Rout_Param_Ptr(a0),a1
	move.l	Rout_Awo_Ptr(a0),a2
	lea	Rout_Variables(a0),a3
	move	R_TE_Mode(a3),d0
	bne	.no_init
	move.l	#$00010000,(a2)+
	move	#256+300,Awo_Alien_X(a2)
	move	P_TE_Pos_Y(a1),Awo_Alien_Y(a2)
	move	#Obj_Tir_Etoile_1,Awo_Alien_Obj_Off(a2)
	move	#50,AWO_Alien_Energy(a2)
	clr.l	Awo_Alien_Status(a2)
	addq	#1,R_TE_Mode(a3)
	bra	.end
.no_init
	move.l	#$00010000,(a2)+    	* MODE 1  ALLWAYS
	lea	AWO_Len(a2),a4
	eor	#1,R_TE_Anim_Delay(a3)
	beq	.no_anim
	move	R_TE_Anim_Step(a3),d1
	addq	#2,R_TE_Anim_Step(a3)
	lea	R_Tir_Etoile_Shape,D
	move	(D,d1.w),AWO_Alien_Obj_Off(a2)
	lea	Rel_Start+32768,D
	cmp	#8*2,d1
	bne	.no_anim
	clr	R_TE_Anim_Step(a3)
.no_anim
	subq	#1,d0
	bne	.no_start
	subq	#2,AWO_Alien_X(a2)
	move	P_TE_Launch_X(a1),d1
	cmp	AWO_Alien_X(a2),d1
	bne	.no_start
 	addq	#1,R_TE_Mode(a3)
	move.l	a4,D
	moveq	#7,d1
.init_loop
	move	#10,AWO_Alien_Energy(D)
	clr.l	Awo_Alien_Status(D)
	move.b	#-1,AWO_Alien_F_Rt_S(D)
	lea	AWO_Len(D),D
	dbra	d1,.init_loop
	lea	Rel_Start+32768,D
	move	#Obj_Tir_1,Awo_Alien_Obj_Off(a4)
	move	#Obj_Tir_2,Awo_Alien_Obj_Off+AWO_Len(a4)
	move	#Obj_Tir_3,Awo_Alien_Obj_Off+AWO_Len*2(a4)
	move	#Obj_Tir_4,Awo_Alien_Obj_Off+AWO_Len*3(a4)
	move	#Obj_Tir_5,Awo_Alien_Obj_Off+AWO_Len*4(a4)
	move	#Obj_Tir_6,Awo_Alien_Obj_Off+AWO_Len*5(a4)
	move	#Obj_Tir_7,Awo_Alien_Obj_Off+AWO_Len*6(a4)
	move	#Obj_Tir_8,Awo_Alien_Obj_Off+AWO_Len*7(a4)
	clr	R_TE_Fire_Step(a3)
	move	AWO_Alien_X(a2),R_TE_Fire_X(a3)
	move	AWO_Alien_Y(a2),R_TE_Fire_Y(a3)
	bra	.end
.no_start
                  subq	#1,d0
	bne	.end
	move	#9,-4(a2)
	addq	#3,R_TE_Fire_Step(a3)
	move	R_TE_Fire_Step(a3),d1
	cmp	#25*4,d1
	bgt	.cont
	subq	#1,AWO_Alien_X(a2)
	bra	.cont2
.cont
	subq	#2,AWO_Alien_Y(a2)
	subq	#4,AWO_Alien_X(a2)
.cont2
	move	R_TE_Fire_X(a3),d2
	move	R_TE_Fire_Y(a3),d3
                  move	d3,d4
                  sub	d1,d4
	move	d2,AWO_Alien_X(a4)
	move	d4,AWO_Alien_y(a4)
	lea	AWO_Len(a4),a4

	move	d2,d4
                  move	d3,d5
                  add	d1,d4
	sub	d1,d5
	move	d4,AWO_Alien_X(a4)
	move	d5,AWO_Alien_y(a4)
	lea	AWO_Len(a4),a4

	move	d2,d4
	add	d1,d4
	move	d4,AWO_Alien_X(a4)
	move	d3,AWO_Alien_y(a4)
	lea	AWO_Len(a4),a4

	move	d2,d4
                  move	d3,d5
                  add	d1,d4
	add	d1,d5
	move	d4,AWO_Alien_X(a4)
	move	d5,AWO_Alien_y(a4)
	lea	AWO_Len(a4),a4

	move	d3,d4
	add	d1,d4
	move	d2,AWO_Alien_X(a4)
	move	d4,AWO_Alien_y(a4)
	lea	AWO_Len(a4),a4

	move	d2,d4
                  move	d3,d5
                  sub	d1,d4
	add	d1,d5
	move	d4,AWO_Alien_X(a4)
	move	d5,AWO_Alien_y(a4)
	lea	AWO_Len(a4),a4

	move	d2,d4
	sub	d1,d4
	move	d4,AWO_Alien_X(a4)
	move	d3,AWO_Alien_y(a4)
	lea	AWO_Len(a4),a4

	move	d2,d4
                  move	d3,d5
                  sub	d1,d4
	sub	d1,d5
	move	d4,AWO_Alien_X(a4)
	move	d5,AWO_Alien_y(a4)
	lea	AWO_Len(a4),a4

	move	AWO_Alien_X(a2),d1
	cmp	#256-32,d1
	bgt	.end
	move.l	#-1,(a0)	* CLOSE
	move	#-1,-4(a2)
	tst	Rout_Mod_Pal_Counter(D)
	bne	.no_close_col
	move.l	#-1,Rout_Pal_Ptr(D)
	st	Refresh_Pal+1(D)
.no_close_col
.end
	lea	Rel_Start+32768,D
	rts



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



* MONSTRE VOLANT KAMIKAZE
* -----------------------


	RSRESET
R_VK_Mode	RS.W	1	* 0=Init 1=Monstre Folow
R_VK_Target_X	RS.W	1                              3
R_VK_Target_Y	RS.W	1
R_VK_Time	RS.W	1

	RSRESET
P_VK_Launch_Time	RS.W	1
P_VK_X_Speed	RS.W	1
P_VK_Y_Speed	RS.W	1


R_Kamikaze
	move.l	Rout_Param_Ptr(a0),a1
	move.l	Rout_Awo_Ptr(a0),a2
	lea	Rout_Variables(a0),a3
	move	R_VK_Mode(a3),d0
	bne	.no_init
	move.l	#$00010000,(a2)+
	move	#256+300,Awo_Alien_X(a2)
	move	#200,Awo_Alien_Y(a2)
	move	#Obj_Kamikaze,Awo_Alien_Obj_Off(a2)
	move	#20,AWO_Alien_Energy(a2)
	clr.l	Awo_Alien_Status(a2)
	clr     R_VK_Time(a3)
	addq	#1,R_VK_Mode(a3)
                  rts
.no_init
	move.l	#$00010000,(a2)+
	move    P_VK_Launch_Time(a1),d5
	move	d5,d6
	add	#50,d6
	lea	R_VK_Time(a3),a4
	addq	#1,(a4)
	cmp     (a4),d5
	blt	.cont7

	move	P_VK_X_Speed(a1),d2
	move	AWO_Alien_X(a2),d1
	move	Sorcerer_X(D),d3
	add	#150,d3
	move	d3,d4
	sub	d1,d3
	bpl	.ok
	neg	d3
.ok
	cmp	d2,d3
	ble	.cont5
	cmp	d4,d1
	blt	.cont4
	sub	d2,AWO_Alien_X(a2)
	bra	.cont5
.cont4
	add	d2,AWO_Alien_X(a2)
.cont5
	move	P_VK_Y_Speed(a1),d2
	move	AWO_Alien_Y(a2),d1
	move	Sorcerer_Y(D),d3
	add	#40,d3
	move	d3,d4
	sub	d1,d3
	bpl	.ok2
	neg	d3
.ok2
	cmp	d2,d3
	ble	.cont7
	cmp	d4,d1
	blt	.cont6
	sub	d2,AWO_Alien_Y(a2)
	bra	.cont7
.cont6
	add	d2,AWO_Alien_Y(a2)
.cont7
	cmp	(a4),d6
	bgt	.no_close
	subq	#8,AWO_Alien_X(a2)
	cmp	#200,AWO_Alien_X(a2)
	bgt	.no_close
	move.l	#-1,(a0)	* CLOSE
	move	#-1,-4(a2)
	tst	Rout_Mod_Pal_Counter(D)
	bne	.no_close_col
	move.l	#-1,Rout_Pal_Ptr(D)
	st	Refresh_Pal+1(D)
.no_close_col
.no_close
	rts



* TRANSPORTEUR
* ------------


	RSRESET
R_T_Mode	RS.W	1	* 0=Init 1=Monstre 2=Vibre
R_T_Anim_Step	RS.W	1
R_T_Anim_Delay	RS.W	1
R_T_Time	RS.W	1

	RSRESET
P_T_Launch_X	RS.W	1

R_Transporteur_Shape
	DC.W	Obj_Transporteur_1
	DC.W	Obj_Transporteur_2
	DC.W	Obj_Transporteur_3
	DC.W	Obj_Transporteur_2

R_T_Transporteur1
	DC.W	TX_Transporteur1	* AWS_Table_X_Off
	DC.W	TY_Transporteur1	* AWS_Table_Y_Off
	DC.W	Anim_Transporte	* AWS_Table_Obj_Off
	DC.B	20	* AWS_Alien_Rate
	DC.B	4	* AWS_Alien_Num
	DC.W	2	* AWS_Alien_Energy
	DC.B	80	* AWS_Alien_Bad_F
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
	DC.W	-1	* AWS_Pal_Mod_Col4
	DC.W	-1	* AWS_Pal_Mod_Col5
	DC.W	-1	* AWS_Pal_Mod_Col6
	DC.W	-1	* AWS_Pal_Mod_Col7

R_T_Transporteur2
	DC.W	TX_Transporteur2	* AWS_Table_X_Off
	DC.W	TY_Transporteur2	* AWS_Table_Y_Off
	DC.W	Anim_Transporte	* AWS_Table_Obj_Off
	DC.B	30	* AWS_Alien_Rate
	DC.B	4	* AWS_Alien_Num
	DC.W	2	* AWS_Alien_Energy
	DC.B	60	* AWS_Alien_Bad_F
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
	DC.W	-1	* AWS_Pal_Mod_Col4
	DC.W	-1	* AWS_Pal_Mod_Col5
	DC.W	-1	* AWS_Pal_Mod_Col6
	DC.W	-1	* AWS_Pal_Mod_Col7

R_Transporteur
	move.l	Rout_Param_Ptr(a0),a1
	move.l	Rout_Awo_Ptr(a0),a2
	lea	Rout_Variables(a0),a3
	move	R_T_Mode(a3),d0
	bne	.no_init
	move.l	#$00010000,(a2)+
	move	#256+320,Awo_Alien_X(a2)
	move	#144+256,Awo_Alien_Y(a2)
	move	#Obj_Transporteur_1,Awo_Alien_Obj_Off(a2)
	move	#-1,AWO_Alien_Energy(a2)
	clr.l	Awo_Alien_Status(a2)
	clr	R_T_Time(a3)
	addq	#1,R_T_Mode(a3)
	bra	.end
.no_init
	move.l	#$00010000,(a2)+    	* MODE 1  ALLWAYS
	subq	#1,d0
	bne	.no_mode1
	eor	#1,R_T_Anim_Delay(a3)
	beq	.no_anim
	move	R_T_Anim_Step(a3),d1
	addq	#2,R_T_Anim_Step(a3)
	lea	R_Transporteur_Shape,a4
	move	(a4,d1.w),AWO_Alien_Obj_Off(a2)
	cmp	#3*2,d1
	bne	.no_anim
	clr	R_T_Anim_Step(a3)
.no_anim
	subq	#1,AWO_Alien_X(a2)
	move	P_T_Launch_X(a1),d1
	cmp	AWO_Alien_X(a2),d1
	bne	.end
	addq	#1,R_T_Mode(a3)
                                               	* Launch
	move	P_T_Launch_X(a1),d5
	subq	#4,d5
                  moveq	#1,d4
.launch_loop
	tst	d4
	beq	.next
	move.l	#R_T_Transporteur1,d0
	or.l	#$40000000,d0
	bra	.next2
.next
	move.l	#R_T_Transporteur2,d0
	or.l	#$40000000,d0
.next2
	move	d5,d1
	move	#138+256,d2

	st	Refresh_Pal+1(D)
	lea	Track_Table-4(D),a1
.track_loop
	lea	4(a1),a1
	btst	#7,(a1)
	beq	.track_loop
                  bclr	#7,(a1)
	move.l	(a1),a1
	move.l	d0,TS_Aws_Ptr(a1)
	clr	TS_Alien_Num(a1)
	clr.b	TS_First_Alien(a1)
	move	d1,TS_X_Start(a1)
	move	d2,TS_Y_Start(a1)
	lea	AWO_Struct-AWO_size(D),a2
	move.l	d0,a3
.awo_loop
	lea	AWO_size(a2),a2
	tst	(a2)
	bpl	.awo_loop
	clr.l	(a2)
	move.l	a2,TS_Awo_Ptr(a1)

	move	AWS_Alien_Energy(a3),d1
	moveq	#0,d2
	move.b	AWS_Alien_F_Rate(a3),d3
	moveq	#31,d0
	addq	#4,a2
.init_loop
	move	d1,AWO_Alien_Energy(a2)
	clr.b	AWO_Alien_Status(a2)

	addq.b	#1,d2
	cmp.b	d2,d3
	bne	.no
	move.b	AWS_Alien_Bad_F(a3),AWO_Alien_F_Rt_S(a2)
	moveq	#0,d2
	bra	.cont
.no
	st      AWO_Alien_F_Rt_S(a2)
.cont
	clr.b	AWO_Alien_F_Rt_D(a2)

	lea	AWO_Len(a2),a2
	dbra	d0,.init_loop
	dbra	d4,.launch_loop
	bra	.end

.no_mode1
	move	R_T_Anim_Step(a3),d1	* MODE 2
	lea	R_Transporteur_Shape,a4
	addq	#2,R_T_Anim_Step(a3)
	move	(a4,d1.w),AWO_Alien_Obj_Off(a2)
	cmp	#3*2,d1
	bne	.no_clr
	clr	R_T_Anim_Step(a3)
.no_clr
	addq	#1,R_T_Time(a3)
	cmp	#25*6,R_T_Time(a3)
	bne	.no_explo
	move.b	#1,AWO_Alien_Status(a2)
.no_explo
	cmp	#25*7,R_T_Time(a3)
	bne	.end
	move.l	#-1,(a0)	* CLOSE
	move	#-1,-4(a2)
	tst	Rout_Mod_Pal_Counter(D)
	bne	.no_close_col
	move.l	#-1,Rout_Pal_Ptr(D)
	st	Refresh_Pal+1(D)
.no_close_col
.end
	rts



* PLANTE AU SOL CRACHE
* --------------------


	RSRESET
R_SC_Mode	RS.W	1	* 0=Init 1=Dragon
R_SC_Anim_Step	RS.W	1
R_SC_Anim_Delay	RS.W	1
R_SC_Launch_Delay	RS.W	1
R_SC_Fire_Step	RS.W	1

	RSRESET
P_SC_Fire_Rate	RS.W	1

R_Sol_Crache_Shape
	DC.W	Obj_Sol_Crache_1
	DC.W	Obj_Sol_Crache_1
	DC.W	Obj_Sol_Crache_1
	DC.W	Obj_Sol_Crache_1
	DC.W	Obj_Sol_Crache_1
	DC.W	Obj_Sol_Crache_1
	DC.W	Obj_Sol_Crache_1
	DC.W	Obj_Sol_Crache_1
	DC.W	Obj_Sol_Crache_2
	DC.W	Obj_Sol_Crache_3
	DC.W	Obj_Sol_Crache_2


R_Sol_Crache
	move.l	Rout_Param_Ptr(a0),a1
	move.l	Rout_Awo_Ptr(a0),a2
	lea	Rout_Variables(a0),a3

	move	R_SC_Mode(a3),d0
	bne	.no_init
	move.l	#$00010000,(a2)+
	move	#256+320,Awo_Alien_X(a2)
	move	#256+190,Awo_Alien_Y(a2)
	move	#Obj_Sol_Crache_1,Awo_Alien_Obj_Off(a2)
	move	#8,AWO_Alien_Energy(a2)
	clr.l	Awo_Alien_Status(a2)
	addq	#1,R_SC_Mode(a3)
	clr	R_SC_Launch_Delay(a3)
	bra	.end
.no_init
	move.l	#$00010000,(a2)+    	* MODE 1  ALLWAYS
	subq	#2,AWO_Alien_X(a2)
	cmp	#200,AWO_Alien_X(a2)
	bgt	.no_end
	move.l	#-1,(a0)		* CLOSE
	move	#-1,-4(a2)
	tst	Rout_Mod_Pal_Counter(D)
	bne	.no_close_col
	move.l	#-1,Rout_Pal_Ptr(D)
	st	Refresh_Pal+1(D)
.no_close_col
	rts
.no_end
	eor	#1,R_SC_Anim_Delay(a3)
	beq	.cont
	move	R_SC_Anim_Step(a3),d1
                  addq	#2,R_SC_Anim_Step(a3)
                  lea	R_Sol_Crache_Shape,a4
	move	(a4,d1.w),AWO_Alien_Obj_Off(a2)
	cmp	#2*10,d1
	bne	.cont
	clr	R_SC_Anim_Step(a3)
.cont
	addq	#1,R_SC_Launch_Delay(a3)
	move	R_SC_Launch_Delay(a3),d1
                  cmp     P_SC_Fire_Rate(a1),d1
	bne	.no_launch
 	move.b	AWO_Alien_Status(a2),d1
	and	#$f,d1
	bne	.no_launch
	clr	R_SC_Launch_Delay(a3)
                  move	#2,R_SC_Mode(a3)
	clr	R_SC_Fire_Step(a3)
	lea	AWO_Len(a2),a2
	move	#Obj_Fire_Ball,Awo_Alien_Obj_Off(a2)
	move	#2,AWO_Alien_Energy(a2)
	clr.l	Awo_Alien_Status(a2)
	bra	.end
.no_launch
	subq	#2,d0
	bne	.end
				* MODE 2 Fire
	move	#2,-4(a2)
	move	AWO_Alien_X(a2),d3
		lea	AWO_Len(a2),a2
	move	R_SC_Fire_Step(a3),d1
	addq	#1,R_SC_Fire_Step(a3)
	cmp	#38,d1
	bne	.ok
	move	#1,R_SC_Mode(a3)
	bra	.end
.ok
	lea	Sin_Table2,a4
	move	#150,d2
	sub.b	(a4,d1.w),d2
	add	#256,d2
	move	d2,AWO_Alien_Y(a2)
	add	d1,d1
	add	d1,d1
	add	d1,d1
	sub	d1,d3
	sub	#16,d3
	move	d3,AWO_Alien_X(a2)
.end
	rts



* SOL TIR EN ETOILE
* -----------------


	RSRESET
R_SE_Mode	RS.W	1	* 0=Init 1=Monstre 2=M.+Tir
R_SE_Fire_Step	RS.W	1
R_SE_Fire_X	RS.W	1
R_SE_Fire_Y	RS.W	1
R_SE_Anim_Step	RS.W	1

	RSRESET
P_SE_Launch_X	RS.W	1

R_SE_Shape
	DC.W	Obj_Sol_Etoile_1
	DC.W	Obj_Sol_Etoile_1
	DC.W	Obj_Sol_Etoile_2
	DC.W	Obj_Sol_Etoile_2
	DC.W	Obj_Sol_Etoile_3
	DC.W	Obj_Sol_Etoile_3
	DC.W	Obj_Sol_Etoile_4
	DC.W	Obj_Sol_Etoile_4
	DC.W	Obj_Sol_Etoile_5
	DC.W	Obj_Sol_Etoile_5
	DC.W	Obj_Sol_Etoile_6
	DC.W	Obj_Sol_Etoile_6
	DC.W	Obj_Sol_Etoile_7
	DC.W	Obj_Sol_Etoile_7
	DC.W	Obj_Sol_Etoile_8
	DC.W	Obj_Sol_Etoile_8
	DC.W	Obj_Sol_Etoile_9
	DC.W	Obj_Sol_Etoile_9
	DC.W	Obj_Sol_Etoile_10
	DC.W	Obj_Sol_Etoile_10

R_Sol_Etoile
	move.l	Rout_Param_Ptr(a0),a1
	move.l	Rout_Awo_Ptr(a0),a2
	lea	Rout_Variables(a0),a3
	move	R_SE_Mode(a3),d0
	bne	.no_init
	move.l	#$00010000,(a2)+
	move	#256+300,Awo_Alien_X(a2)
	move	#256+191,Awo_Alien_Y(a2)
	move	#Obj_Sol_Etoile_1,Awo_Alien_Obj_Off(a2)
	move	#10,AWO_Alien_Energy(a2)
	clr.l	Awo_Alien_Status(a2)
	addq	#1,R_SE_Mode(a3)
	bra	.end
.no_init
	move.l	#$00010000,(a2)+    	* MODE 1  ALLWAYS
	addq	#1,R_SE_Anim_Step(a3)
	cmp	#20,R_SE_Anim_Step(a3)
	bne	.cont3
	clr	R_SE_Anim_Step(a3)
.cont3
	move	R_SE_Anim_Step(a3),d1
	add	d1,d1
	lea	R_SE_Shape,a4
	move	(a4,d1.w),AWO_Alien_Obj_Off(a2)
	lea	AWO_Len(a2),a4
	subq	#2,AWO_Alien_X(a2)
	cmp	#200,AWO_Alien_X(a2)
	bgt	.no_close
	move.l	#-1,(a0)	* CLOSE
	move	#-1,-4(a2)
	tst	Rout_Mod_Pal_Counter(D)
	bne	.no_close_col
	move.l	#-1,Rout_Pal_Ptr(D)
	st	Refresh_Pal+1(D)
.no_close_col
 	rts
.no_close
                  cmp	#1,d0
	bne	.no_start
	move.b	AWO_Alien_Status(a2),d1
	and	#$f,d1
	bne	.no_start
	move	P_SE_Launch_X(a1),d1
	cmp	AWO_Alien_X(a2),d1
	ble	.no_start
	move	#2,R_SE_Mode(a3)
	move.l	a4,D
	moveq	#2,d1
.init_loop
	move	#10,AWO_Alien_Energy(D)
	clr.l	Awo_Alien_Status(D)
	move.b	#-1,AWO_Alien_F_Rt_S(D)
	lea	AWO_Len(D),D
	dbra	d1,.init_loop
	lea	Rel_Start+32768,D
	move	#Obj_Tir_1,Awo_Alien_Obj_Off(a4)
	move	#Obj_Tir_2,Awo_Alien_Obj_Off+AWO_Len(a4)
	move	#Obj_Tir_8,Awo_Alien_Obj_Off+AWO_Len*2(a4)
	clr	R_SE_Fire_Step(a3)
	move	AWO_Alien_X(a2),R_SE_Fire_X(a3)
	move	AWO_Alien_Y(a2),R_SE_Fire_Y(a3)
	bra	.end
.no_start
                  cmp	#2,d0
	bne	.end
	move	#4,-4(a2)
	addq	#3,R_SE_Fire_Step(a3)
	move	R_SE_Fire_Step(a3),d1
	move	R_SE_Fire_X(a3),d2
	move	R_SE_Fire_Y(a3),d3
                  move	d3,d4
                  sub	d1,d4
	move	d2,AWO_Alien_X(a4)
	move	d4,AWO_Alien_y(a4)
	lea	AWO_Len(a4),a4

	move	d2,d4
                  move	d3,d5
                  add	d1,d4
	sub	d1,d5
	move	d4,AWO_Alien_X(a4)
	move	d5,AWO_Alien_y(a4)
	lea	AWO_Len(a4),a4

	move	d2,d4
                  move	d3,d5
                  sub	d1,d4
	sub	d1,d5
	move	d4,AWO_Alien_X(a4)
	move	d5,AWO_Alien_y(a4)

.end
	rts



* SOL SAUTE SUR LE PERSO
* ----------------------


	RSRESET
R_J_Mode	RS.W    1


R_Jumper
	move.l	Rout_Param_Ptr(a0),a1
	move.l	Rout_Awo_Ptr(a0),a2
	lea	Rout_Variables(a0),a3

	move	R_J_Mode(a3),d0
	bne	.no_init
	move.l	#$00010000,(a2)+
	move	#256+340,Awo_Alien_X(a2)
	move	#256+190,Awo_Alien_Y(a2)
	move	#Obj_Jumper_1,Awo_Alien_Obj_Off(a2)
	move	#5,AWO_Alien_Energy(a2)
	clr.l	Awo_Alien_Status(a2)
	addq	#1,R_J_Mode(a3)
	bra	.end
.no_init
	move.l	#$00010000,(a2)+
	subq	#2,AWO_Alien_X(a2)
	subq	#1,d0
	bne	.mode2
	move    Sorcerer_X(D),d1
	add	#128,d1
	cmp	AWO_Alien_X(a2),d1
	blt	.end
	addq	#1,R_J_Mode(a3)
	move	#Obj_Jumper_2,Awo_Alien_Obj_Off(a2)
	bra	.end
.mode2
	move	#Obj_Jumper_3,Awo_Alien_Obj_Off(a2)
	subq	#8,AWO_Alien_Y(a2)
	subq	#4,AWO_Alien_X(a2)
	cmp	#240,AWO_Alien_Y(a2)
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
	DC.W	Obj_Sol_Kamikaze_1
	DC.W	Obj_Sol_Kamikaze_2
	DC.W	Obj_Sol_Kamikaze_2
	DC.W	Obj_Sol_Kamikaze_3
	DC.W	Obj_Sol_Kamikaze_3

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



* MONSTRE FINAL
* -------------


	RSRESET
R_F_Mode	RS.W	1	* 0=Init 1=Monstre Folow
R_F_Langue_Delay	RS.W	1
R_F_Langue_Step	RS.W	1
R_F_Shape	RS.W	1

Final_Shape
	DC.W	Obj_Final_1
	DC.W	Obj_Final_2
	DC.W	Obj_Final_3
	DC.W	Obj_Final_4
	DC.W	Obj_Final_5
	DC.W	Obj_Final_6
	DC.W	Obj_Final_5
	DC.W	Obj_Final_4
	DC.W	Obj_Final_3
	DC.W	Obj_Final_2
Langue_Shape
                  DC.W	Obj_Langue_1
                  DC.W	Obj_Langue_1
                  DC.W	Obj_Langue_1
                  DC.W	Obj_Langue_1
                  DC.W	Obj_Langue_1
                  DC.W	Obj_Langue_1
                  DC.W	Obj_Langue_1
                  DC.W	Obj_Langue_1
                  DC.W	Obj_Langue_1
                  DC.W	Obj_Langue_1
                  DC.W	Obj_Langue_1
                  DC.W	Obj_Langue_1
                  DC.W	Obj_Langue_2
                  DC.W	Obj_Langue_3
                  DC.W	Obj_Langue_4
                  DC.W	Obj_Langue_5
                  DC.W	Obj_Langue_6
                  DC.W	Obj_Langue_7
                  DC.W	Obj_Langue_8
                  DC.W	Obj_Langue_7
                  DC.W	Obj_Langue_6
                  DC.W	Obj_Langue_5
                  DC.W	Obj_Langue_4
                  DC.W	Obj_Langue_3
                  DC.W	Obj_Langue_2
                  DC.W	Obj_Langue_1

R_Final
	move.l	Rout_Param_Ptr(a0),a1
	move.l	Rout_Awo_Ptr(a0),a2
	lea	Rout_Variables(a0),a3

	move	R_F_Mode(a3),d0
	bne	.no_init
	move.l	#$00010000,(a2)+
	move	#256+300,Awo_Alien_X(a2)
	move	#256+80,Awo_Alien_Y(a2)
	move	#Obj_Final_1,Awo_Alien_Obj_Off(a2)
	move	#170,AWO_Alien_Energy(a2)
	move.l	#$000c0000,Awo_Alien_Status(a2)
	addq	#1,R_F_Mode(a3)
                  rts
.no_init
	move.l	#$00010000,(a2)+
	addq	#2,R_F_Shape(a3)
	cmp	#20,R_F_Shape(a3)
	bne	.no
	clr	R_F_Shape(a3)
.no
	move	R_F_Shape(a3),d1
	lea	Final_Shape,a4
	move	(a4,d1.w),Awo_Alien_Obj_Off(a2)

                  move.b	AWO_Alien_Status(a2),d1
	and	#$f,d1
	cmp	#$f,d1
	beq	.close

	cmp	#2,d0
	beq	.mode2

	moveq	#2,d2
	move	AWO_Alien_X(a2),d1
	move	Sorcerer_X(D),d3
	add	#150,d3
	move	d3,d4
	sub	d1,d3
	bpl	.ok
	neg	d3
.ok
	cmp	d2,d3
	ble	.cont5
	cmp	d4,d1
	blt	.cont4
	sub	d2,AWO_Alien_X(a2)
	bra	.cont5
.cont4
	add	d2,AWO_Alien_X(a2)
.cont5
	moveq	#2,d2
	move	AWO_Alien_Y(a2),d1
	move	Sorcerer_Y(D),d3
	add	#40,d3
	move	d3,d4
	sub	d1,d3
	bpl	.ok2
	neg	d3
.ok2
	cmp	d2,d3
	ble	.cont7
	cmp	d4,d1
	blt	.cont6
	sub	d2,AWO_Alien_Y(a2)
	bra	.cont7
.cont6
	add	d2,AWO_Alien_Y(a2)
.cont7
	addq	#1,R_F_langue_Delay
	cmp	#50,R_F_langue_Delay
	bne	.end
	clr	R_F_langue_Delay
	move.l	#$00020000,-4(a2)
	lea	AWO_Len(a2),a4
	move    Awo_Alien_X(a2),d1
	sub	#140,d1
	move	d1,Awo_Alien_X(a4)
	move    Awo_Alien_Y(a2),Awo_Alien_Y(a4)
	move	#Obj_Langue_1,Awo_Alien_Obj_Off(a4)
	move	#100,AWO_Alien_Energy(a4)
	clr.l	Awo_Alien_Status(a4)
	addq	#1,R_F_Mode(a3)
	move	#-2,R_F_Langue_Step(a3)
	bra	.end
.mode2
                  move.b	AWO_Alien_Status(a2),d1
	and	#$f,d1
	beq	.ok3
	move.b	#1,AWO_Alien_Status(a4)
	bra	.end_l
.ok3
	move.l	#$00020000,-4(a2)
	lea	AWO_Len(a2),a4
	addq	#2,R_F_Langue_Step(a3)
	cmp	#52,R_F_Langue_Step(a3)
	beq	.end_l
	lea     Langue_Shape,a2
	move	R_F_Langue_Step(a3),d1
	move	(a2,d1.w),Awo_Alien_Obj_Off(a4)
	rts
.end_l
	subq	#1,R_F_Mode(a3)
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
	RINCBIN	Game/lmarais.rtb
Absolute_Tracks
	RINCBIN	Game/lmarais.atb
Sin_Table1
	RINCBIN	Game/Sin_Table1.bin
Sin_Table2
	RINCBIN	Game/Sin_Table2.bin
Sin_Table3
	RINCBIN	Game/Sin_Table3.bin




