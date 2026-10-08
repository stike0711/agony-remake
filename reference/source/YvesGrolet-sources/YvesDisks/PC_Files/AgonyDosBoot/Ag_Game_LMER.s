
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
*                               S E A                                     *
*                               -----                                     *
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
	START_A	Poisson_Bl_1,280+256,220+256

                  WAIT	$42
	START_A	Poisson_Bl_3,260+256,230+256

                  WAIT	$50
	START_A	Poisson_Bl_2,250+256,250+256

                  WAIT	$55
	START_A	Poisson_Bl_1,270+256,240+256

                  WAIT	$60
	START_A	Poisson_Bl_2,265+256,250+256

                  WAIT	$70
	START_A	Poisson_Bl_1,200+256,230+256

                  WAIT	$80
	START_A	Poisson_Bl_3,280+256,245+256

                  WAIT	$90
	START_A	Poisson_Bl_2,260+256,220+256

	WAIT	$100
	START_A DGDP_Full_7c_2,256+$120,198

	WAIT	$180
 	START_A DGDP_Full_7c_1,256+$100,230

	WAIT	$200
 	START_A DGDP_Full_7c_1,256+$c0,240

	WAIT	$240
	START_C R_Sol_Crache
	PAR     45
	PAR_END

	WAIT	$280
	START_C R_Sol_Crache
	PAR     40
	PAR_END

	WAIT	$300
	START_A DGDP_Feuillage_7c,256+300,230

	WAIT	$380
	START_A DGDP_Bestiolle_1,256+200,240

                  WAIT	$400
	START_C	R_Araignee
	PAR	150
	PAR     4
	PAR_END

                  WAIT	$460
	START_C	R_Araignee
	PAR     200
	PAR     3
	PAR_END

                  WAIT	$4c0
	START_C	R_Araignee
	PAR     180
	PAR     1
	PAR_END

                  WAIT	$500
	START_C	R_Araignee
	PAR     190
	PAR     3
	PAR_END

	IFNE	ASM_Demo_Mode=2	* DEMO PAGE
	WAIT	$546
	START_C	Demo_Page
	PAR	0
	PAR	150
                  PAR_END
	ENDC

	WAIT	$640
	START_C R_Transporteur
	PAR     150+256
	PAR_END

	IFNE	ASM_Demo_Mode=2	* DEMO PAGE
	WAIT	$6a4
	START_C	Demo_Page
	PAR     1
	PAR	150
                  PAR_END
	ENDC

	WAIT	$700
	START_A DGDP_Feuillage_7c,256+300,230

	WAIT	$760
	START_A DGS_Feuillage_7c,256+300,290

	IFNE	ASM_Demo_Mode=2	* DEMO PAGE
	WAIT	$7b2
	START_C	Demo_Page
	PAR     2
	PAR	150
                  PAR_END
	ENDC

	WAIT	$8a0
	START_A	DGMP_Boulle,256+250,256+208

                  WAIT	$960
	START_A	Poisson_Bl_1,280+256,220+256

                  WAIT	$965
	START_A	Poisson_Bl_3,260+256,230+256

                  WAIT	$a00
	START_A	Poisson_3,280+256,220+256

                  WAIT	$a10
	START_A	Poisson_2,260+256,235+256

                  WAIT	$a20
	START_A	Poisson_3,250+256,250+256

                  WAIT	$a30
	START_A	Poisson_1,270+256,240+256

                  WAIT	$a40
	START_A	Poisson_2,265+256,250+256

	WAIT	$a45
 	START_A DGDP_Full_7c_3,256+300,250

                  WAIT	$a50
	START_A	Poisson_1,200+256,230+256

                  WAIT	$a60
	START_A	Poisson_2,300+256,225+256

                  WAIT	$a70
	START_A	Poisson_3,260+256,200+256

                  WAIT	$a80
	START_A	Poisson_2,275+256,220+256

                  WAIT	$b00
	START_A	Poisson_2,260+256,230+256

	WAIT	$b05
 	START_A DGDP_Full_7c_3,256+275,260

                  WAIT	$b20
	START_A	Poisson_1,255+256,210+256

                  WAIT	$b30
	START_A	Poisson_3,270+256,240+256

                  WAIT	$b40
	START_A	Poisson_2,240+256,250+256

                  WAIT	$a50
	START_A	Poisson_3,215+256,230+256

                  WAIT	$b60
	START_A	Poisson_1,280+256,205+256

                  WAIT	$b70
	START_A	Poisson_2,272+256,225+256

                  WAIT	$b90
	START_A	Poisson_3,260+256,232+256

	WAIT	$ba0
 	START_A DGDP_Full_7c_3,256+300,260

                  WAIT	$bb0
	START_A	Poisson_2,200+256,220+256

                  WAIT	$bd0
	START_A	Poisson_1,255+256,255+256

                  WAIT	$d00
	START_A	Poisson_Bl_2,300+256,230+256

                  WAIT	$d05
	START_A DGDP_Boulle,256+200,240

                  WAIT	$d10
	START_A	Poisson_Bl_1,280+256,220+256

	WAIT	$e60
 	START_A DGDP_Fantome,256+300,256+130

	WAIT	$e65
	START_C	R_Tir_Etoile
	PAR     200+256
	PAR	80+256
	PAR_END

	WAIT	$f80
	START_C	R_Spectre	* Guided Spectre, Ground Start
	PAR	200+256	* Sp. Launch X
	PAR	25	* Sp. Fire Rate
	PAR	2	* X Speed
	PAR	2	* Y Speed
                  PAR_END

	WAIT	$1000
	START_A	GDDP_Boulle,256,240

	WAIT	$1020
	START_A	DGDP_Bestiolle_2,256+300,260

	WAIT	$1040
	START_C	R_Rapide
	PAR	Anim_Bestiolle
	PAR     8
	PAR_L	R_R_Pal
                  PAR	256+130
	PAR_END

	WAIT	$1060
	START_C	R_Rapide
	PAR	Anim_Bestiolle
	PAR     7
	PAR_L	R_R_Pal
                  PAR	256+130
	PAR_END

	WAIT	$1080
	START_C	R_Rapide
	PAR	Anim_Bestiolle
	PAR     6
	PAR_L	R_R_Pal
                  PAR	256+130
	PAR_END

	IFNE	ASM_Demo_Mode=2	* DEMO PAGE
	WAIT	$109a
	START_C	Demo_Page
	PAR     3
	PAR	150
                  PAR_END
	ENDC

	WAIT	$1100
	START_A DGDP_Feuillage_7c,256+300,230

	WAIT	$1140
 	START_A DGDP_Grosse_Tete,256+300,256+120

	WAIT	$11a0
 	START_A DGDP_Grosse_Tete,256+300,256+130

	WAIT	$11d0
	START_C	R_Tir_Etoile
	PAR     150+256
	PAR	80+256
	PAR_END

	WAIT	$12c0
 	START_A DGDP_Fantome,256+300,256+115

	WAIT	$1320
 	START_A DGDP_Fantome2,256+308,256+135

	WAIT	$1340
 	START_A DGDP_Full_7c_3,256+300,250

	IFNE	ASM_Demo_Mode=2	* DEMO PAGE
	WAIT	$1388
	START_C	Demo_Page
	PAR     4
	PAR	150
                  PAR_END
	ENDC

                  WAIT	$1400
	START_A	Poisson_Bl_1,280+256,220+256

                  WAIT	$1420
	START_A	Poisson_Bl_3,260+256,230+256

                  WAIT	$1430
	START_A	Poisson_Bl_1,270+256,240+256

                  WAIT	$1440
	START_A	Poisson_Bl_1,250+256,250+256

                  WAIT	$1450
	START_A	Poisson_Bl_2,265+256,250+256

                  WAIT	$1460
	START_A	Poisson_Bl_1,200+256,230+256

                  WAIT	$1470
	START_A	Poisson_Bl_3,280+256,245+256

                  WAIT	$1480
	START_A	Poisson_Bl_1,260+256,220+256

                  WAIT	$1490
	START_A	Poisson_Bl_1,280+256,220+256

                  WAIT	$14a0
	START_A	Poisson_Bl_3,260+256,230+256

                  WAIT	$14b0
	START_A	Poisson_Bl_1,270+256,240+256

                  WAIT	$14c0
	START_A	Poisson_Bl_1,250+256,250+256

                  WAIT	$14d0
	START_A	Poisson_Bl_2,265+256,250+256

	WAIT	$1500
  	START_A DGDP_Boulle_2,256+150,240

	WAIT	$15d0
 	START_A DGMP_Full_7c,256+180,256+208

	IFNE	ASM_Demo_Mode=2	* DEMO PAGE
	WAIT	$1644
	START_C	Demo_Page
	PAR     5
	PAR	150
                  PAR_END
	ENDC

	WAIT	$16a0
 	START_A DGDP_Fantome,256+300,256+115

	WAIT	$1700
 	START_A DGDP_Fantome2,256+308,256+135

	WAIT	$1720
	START_C	R_Bomber
                  PAR_END

	WAIT	$1740
 	START_A DGDP_Fantome,256+310,256+115

	WAIT	$1780
 	START_A DGDP_Fantome,256+308,256+120

	WAIT	$18a0
 	START_A DGDP_Fantome2,256+308,256+135

                  WAIT	$1a00
	START_A	Poisson_3,280+256,220+256

                  WAIT	$1a10
	START_A	Poisson_2,260+256,235+256

                  WAIT	$1a20
	START_A	Poisson_3,250+256,250+256

                  WAIT	$1a30
	START_A	Poisson_1,270+256,240+256

                  WAIT	$1a40
	START_A	Poisson_2,265+256,250+256

	WAIT	$1a45
 	START_A DGS_Bestiolle,256+275,300

                  WAIT	$1a50
	START_A	Poisson_1,200+256,230+256

                  WAIT	$1a60
	START_A	Poisson_2,300+256,225+256

                  WAIT	$1a70
	START_A	Poisson_3,260+256,200+256

                  WAIT	$1a80
	START_A	Poisson_2,275+256,220+256

                  WAIT	$1b00
	START_A	Poisson_2,260+256,230+256

	WAIT	$1b05
 	START_A DGS_Bestiolle,256+275,290

                  WAIT	$1b20
	START_A	Poisson_1,255+256,210+256

                  WAIT	$1b30
	START_A	Poisson_3,270+256,240+256

                  WAIT	$1b40
	START_A	Poisson_2,240+256,250+256

                  WAIT	$1a50
	START_A	Poisson_3,215+256,230+256

                  WAIT	$1b60
	START_A	Poisson_1,280+256,205+256

                  WAIT	$1b70
	START_A	Poisson_2,272+256,225+256

                  WAIT	$1b90
	START_A	Poisson_3,260+256,232+256

	WAIT	$1ba0
 	START_A DGS_Bestiolle,256+300,300

                  WAIT	$1ba5
	START_A	Poisson_1,255+256,255+256

	WAIT	$1cc0
	START_C	R_Volant_Grossi
	PAR	256+150
	PAR     3
	PAR_END

	IFNE	ASM_Demo_Mode=2	* DEMO PAGE
	WAIT	$1d4c
	START_C	Demo_Page
	PAR     6
	PAR	150
                  PAR_END
	ENDC

	WAIT	$1d6e
 	START_A DGDP_Full_7c_4,256+300,230

	WAIT	$1d70
 	START_A DGDP_Full_7c_4,256+300,256+20

	WAIT	$1d60
	START_C	R_Volant_Grossi
	PAR	256+158
	PAR     4
	PAR_END

	WAIT	$1da0
	START_C	R_Volant_Grossi
	PAR	256+160
	PAR     3
	PAR_END

                  WAIT	$1e40
	START_C	R_Araignee
	PAR     200
	PAR     2
	PAR_END

                  WAIT	$1ec0
	START_C	R_Araignee
	PAR     180
	PAR     1
	PAR_END

	WAIT	$1f00
	START_C R_Sol_Crache
	PAR     45
	PAR_END

                  WAIT	$1f40
	START_C	R_Araignee
	PAR     220
	PAR     2
	PAR_END

	WAIT	$1f80
	START_C R_Sol_Crache
	PAR     35
	PAR_END

                  WAIT	$1fc0
	START_C	R_Araignee
	PAR     190
	PAR     3
	PAR_END

	IFNE	ASM_Demo_Mode=2	* DEMO PAGE
	WAIT	$2008
	START_C	Demo_Page
	PAR     7
	PAR	150
                  PAR_END
	ENDC

	WAIT	$2180
 	START_A DGMP_Full_7c,256+180,256+208

	WAIT	$2200
	START_C	R_Volant_missile
	PAR_END

	WAIT	$22f0
                  START_C	R_Final
	PAR_END


	SL_END



* RELATIVE TRACKS START STRUCT
* ----------------------------


	INCLUDE	Game/Lmer_Rtr.s



* ABSOLUTE TRACKS START STRUCT
* ----------------------------


Poisson_Bl_1
	DC.W	TX_Saut_1	* AWS_Table_X_Off
	DC.W	TY_Saut_1	* AWS_Table_Y_Off
	DC.W	Anim_Poisson_Bleu	* AWS_Table_Obj_Off
	DC.B	60	* AWS_Alien_Rate
	DC.B	2	* AWS_Alien_Num
	DC.W	1	* AWS_Alien_Energy
	DC.B	255	* AWS_Alien_Bad_F
	DC.B	0	* AWS_Alien_F_Rate
	DC.B	-1	* AWS_Pal_Mod_Lin0
	DC.B	-1	* AWS_Pal_Mod_Lin1
	DC.B	-1	* AWS_Pal_Mod_Lin2
	DC.B	1	* AWS_Pal_Mod_Lin3
	DC.B	1	* AWS_Pal_Mod_Lin4
	DC.B	1	* AWS_Pal_Mod_Lin5
	DC.W	$858	* AWS_Pal_Mod_Col1
	DC.W	-1	* AWS_Pal_Mod_Col2
	DC.W	-1	* AWS_Pal_Mod_Col3
	DC.W	$543	* AWS_Pal_Mod_Col4
	DC.W	$405	* AWS_Pal_Mod_Col5
	DC.W	$637	* AWS_Pal_Mod_Col6
	DC.W	-1	* AWS_Pal_Mod_Col7

Poisson_Bl_2
	DC.W	TX_Saut_2	* AWS_Table_X_Off
	DC.W	TY_Saut_2	* AWS_Table_Y_Off
	DC.W	Anim_Poisson_Bleu	* AWS_Table_Obj_Off
	DC.B	50	* AWS_Alien_Rate
	DC.B	3	* AWS_Alien_Num
	DC.W	1	* AWS_Alien_Energy
	DC.B	255	* AWS_Alien_Bad_F
	DC.B	0	* AWS_Alien_F_Rate
	DC.B	-1	* AWS_Pal_Mod_Lin0
	DC.B	-1	* AWS_Pal_Mod_Lin1
	DC.B	-1	* AWS_Pal_Mod_Lin2
	DC.B	1	* AWS_Pal_Mod_Lin3
	DC.B	1	* AWS_Pal_Mod_Lin4
	DC.B	1	* AWS_Pal_Mod_Lin5
	DC.W	$858	* AWS_Pal_Mod_Col1
	DC.W	-1	* AWS_Pal_Mod_Col2
	DC.W	-1	* AWS_Pal_Mod_Col3
	DC.W	$543	* AWS_Pal_Mod_Col4
	DC.W	$405	* AWS_Pal_Mod_Col5
	DC.W	$637	* AWS_Pal_Mod_Col6
	DC.W	-1	* AWS_Pal_Mod_Col7

Poisson_Bl_3
	DC.W	TX_Saut_3	* AWS_Table_X_Off
	DC.W	TY_Saut_3	* AWS_Table_Y_Off
	DC.W	Anim_Poisson_Bleu	* AWS_Table_Obj_Off
	DC.B	30	* AWS_Alien_Rate
	DC.B	4	* AWS_Alien_Num
	DC.W	1	* AWS_Alien_Energy
	DC.B	255	* AWS_Alien_Bad_F
	DC.B	0	* AWS_Alien_F_Rate
	DC.B	-1	* AWS_Pal_Mod_Lin0
	DC.B	-1	* AWS_Pal_Mod_Lin1
	DC.B	-1	* AWS_Pal_Mod_Lin2
	DC.B	1	* AWS_Pal_Mod_Lin3
	DC.B	1	* AWS_Pal_Mod_Lin4
	DC.B	1	* AWS_Pal_Mod_Lin5
	DC.W	$858	* AWS_Pal_Mod_Col1
	DC.W	-1	* AWS_Pal_Mod_Col2
	DC.W	-1	* AWS_Pal_Mod_Col3
	DC.W	$543	* AWS_Pal_Mod_Col4
	DC.W	$405	* AWS_Pal_Mod_Col5
	DC.W	$637	* AWS_Pal_Mod_Col6
	DC.W	-1	* AWS_Pal_Mod_Col7
Poisson_1
	DC.W	TX_Saut_1	* AWS_Table_X_Off
	DC.W	TY_Saut_1	* AWS_Table_Y_Off
	DC.W	Anim_Poisson	* AWS_Table_Obj_Off
	DC.B	50	* AWS_Alien_Rate
	DC.B	3	* AWS_Alien_Num
	DC.W	1	* AWS_Alien_Energy
	DC.B	255	* AWS_Alien_Bad_F
	DC.B	0	* AWS_Alien_F_Rate
	DC.B	-1	* AWS_Pal_Mod_Lin0
	DC.B	-1	* AWS_Pal_Mod_Lin1
	DC.B	1	* AWS_Pal_Mod_Lin2
	DC.B	1	* AWS_Pal_Mod_Lin3
	DC.B	1	* AWS_Pal_Mod_Lin4
	DC.B	1	* AWS_Pal_Mod_Lin5
	DC.W	$986	* AWS_Pal_Mod_Col1
	DC.W	$765	* AWS_Pal_Mod_Col2
	DC.W	$321	* AWS_Pal_Mod_Col3
	DC.W	$543	* AWS_Pal_Mod_Col4
	DC.W	$554	* AWS_Pal_Mod_Col5
	DC.W	$733	* AWS_Pal_Mod_Col6
	DC.W	$986	* AWS_Pal_Mod_Col7

Poisson_2
	DC.W	TX_Saut_2	* AWS_Table_X_Off
	DC.W	TY_Saut_2	* AWS_Table_Y_Off
	DC.W	Anim_Poisson	* AWS_Table_Obj_Off
	DC.B	60	* AWS_Alien_Rate
	DC.B	2	* AWS_Alien_Num
	DC.W	1	* AWS_Alien_Energy
	DC.B	255	* AWS_Alien_Bad_F
	DC.B	0	* AWS_Alien_F_Rate
	DC.B	-1	* AWS_Pal_Mod_Lin0
	DC.B	-1	* AWS_Pal_Mod_Lin1
	DC.B	1	* AWS_Pal_Mod_Lin2
	DC.B	1	* AWS_Pal_Mod_Lin3
	DC.B	1	* AWS_Pal_Mod_Lin4
	DC.B	1	* AWS_Pal_Mod_Lin5
	DC.W	$986	* AWS_Pal_Mod_Col1
	DC.W	$765	* AWS_Pal_Mod_Col2
	DC.W	$321	* AWS_Pal_Mod_Col3
	DC.W	$543	* AWS_Pal_Mod_Col4
	DC.W	$554	* AWS_Pal_Mod_Col5
	DC.W	$733	* AWS_Pal_Mod_Col6
	DC.W	$986	* AWS_Pal_Mod_Col7

Poisson_3
	DC.W	TX_Saut_3	* AWS_Table_X_Off
	DC.W	TY_Saut_3	* AWS_Table_Y_Off
	DC.W	Anim_Poisson	* AWS_Table_Obj_Off
	DC.B	40	* AWS_Alien_Rate
	DC.B	3	* AWS_Alien_Num
	DC.W	1	* AWS_Alien_Energy
	DC.B	255	* AWS_Alien_Bad_F
	DC.B	0	* AWS_Alien_F_Rate
	DC.B	-1	* AWS_Pal_Mod_Lin0
	DC.B	-1	* AWS_Pal_Mod_Lin1
	DC.B	1	* AWS_Pal_Mod_Lin2
	DC.B	1	* AWS_Pal_Mod_Lin3
	DC.B	1	* AWS_Pal_Mod_Lin4
	DC.B	1	* AWS_Pal_Mod_Lin5
	DC.W	$986	* AWS_Pal_Mod_Col1
	DC.W	$765	* AWS_Pal_Mod_Col2
	DC.W	$321	* AWS_Pal_Mod_Col3
	DC.W	$543	* AWS_Pal_Mod_Col4
	DC.W	$554	* AWS_Pal_Mod_Col5
	DC.W	$733	* AWS_Pal_Mod_Col6
	DC.W	$986	* AWS_Pal_Mod_Col7

DGDP_Full_7c_1
	DC.W	TX_DG_Descend_Plat_5 * AWS_Table_X_Off
	DC.W	TY_DG_Descend_Plat_5 * AWS_Table_Y_Off
	DC.W	Anim_Full_7c	* AWS_Table_Obj_Off
	DC.B	20	* AWS_Alien_Rate
	DC.B	2	* AWS_Alien_Num
	DC.W	1	* AWS_Alien_Energy
	DC.B	255	* AWS_Alien_Bad_F
	DC.B	0	* AWS_Alien_F_Rate
	DC.B	1	* AWS_Pal_Mod_Lin0
	DC.B	1	* AWS_Pal_Mod_Lin1
	DC.B	1	* AWS_Pal_Mod_Lin2
	DC.B	-1	* AWS_Pal_Mod_Lin3
	DC.B	-1	* AWS_Pal_Mod_Lin4
	DC.B	-1	* AWS_Pal_Mod_Lin5
	DC.W	$c86	* AWS_Pal_Mod_Col2
	DC.W	$a44	* AWS_Pal_Mod_Col3
	DC.W	$321	* AWS_Pal_Mod_Col7
	DC.W	$834	* AWS_Pal_Mod_Col5
	DC.W	$c65	* AWS_Pal_Mod_Col4
	DC.W	$514	* AWS_Pal_Mod_Col6
	DC.W	$dc5	* AWS_Pal_Mod_Col1

DGDP_Full_7c_2
	DC.W	TX_DG_Descend_Plat_4 * AWS_Table_X_Off
	DC.W	TY_DG_Descend_Plat_4 * AWS_Table_Y_Off
	DC.W	Anim_Full_7c	* AWS_Table_Obj_Off
	DC.B	20	* AWS_Alien_Rate
	DC.B	3	* AWS_Alien_Num
	DC.W	1	* AWS_Alien_Energy
	DC.B	255	* AWS_Alien_Bad_F
	DC.B	0	* AWS_Alien_F_Rate
	DC.B	1	* AWS_Pal_Mod_Lin0
	DC.B	1	* AWS_Pal_Mod_Lin1
	DC.B	1	* AWS_Pal_Mod_Lin2
	DC.B	1	* AWS_Pal_Mod_Lin3
	DC.B	-1	* AWS_Pal_Mod_Lin4
	DC.B	-1	* AWS_Pal_Mod_Lin5
	DC.W	$c86	* AWS_Pal_Mod_Col2
	DC.W	$a44	* AWS_Pal_Mod_Col3
	DC.W	$321	* AWS_Pal_Mod_Col7
	DC.W	$834	* AWS_Pal_Mod_Col5
	DC.W	$c65	* AWS_Pal_Mod_Col4
	DC.W	$514	* AWS_Pal_Mod_Col6
	DC.W	$dc5	* AWS_Pal_Mod_Col1

DGDP_Full_7c_3
	DC.W	TX_DG_Descend_Plat_7 * AWS_Table_X_Off
	DC.W	TY_DG_Descend_Plat_7 * AWS_Table_Y_Off
	DC.W	Anim_Full_7c	* AWS_Table_Obj_Off
	DC.B	20	* AWS_Alien_Rate
	DC.B	3	* AWS_Alien_Num
	DC.W	1	* AWS_Alien_Energy
	DC.B	14	* AWS_Alien_Bad_F
	DC.B	2	* AWS_Alien_F_Rate
	DC.B	1	* AWS_Pal_Mod_Lin0
	DC.B	1	* AWS_Pal_Mod_Lin1
	DC.B	-1	* AWS_Pal_Mod_Lin2
	DC.B	-1	* AWS_Pal_Mod_Lin3
	DC.B	-1	* AWS_Pal_Mod_Lin4
	DC.B	-1	* AWS_Pal_Mod_Lin5
	DC.W	$c86	* AWS_Pal_Mod_Col2
	DC.W	$a44	* AWS_Pal_Mod_Col3
	DC.W	$321	* AWS_Pal_Mod_Col7
	DC.W	$834	* AWS_Pal_Mod_Col5
	DC.W	$c65	* AWS_Pal_Mod_Col4
	DC.W	$514	* AWS_Pal_Mod_Col6
	DC.W	$dc5	* AWS_Pal_Mod_Col1

DGDP_Full_7c_4
	DC.W	TX_DG_Descend_Plat_6 * AWS_Table_X_Off
	DC.W	TY_DG_Descend_Plat_6 * AWS_Table_Y_Off
	DC.W	Anim_Full_7c	* AWS_Table_Obj_Off
	DC.B	20	* AWS_Alien_Rate
	DC.B	4	* AWS_Alien_Num
	DC.W	1	* AWS_Alien_Energy
	DC.B	14	* AWS_Alien_Bad_F
	DC.B	2	* AWS_Alien_F_Rate
	DC.B	1	* AWS_Pal_Mod_Lin0
	DC.B	1	* AWS_Pal_Mod_Lin1
	DC.B	1	* AWS_Pal_Mod_Lin2
	DC.B	-1	* AWS_Pal_Mod_Lin3
	DC.B	-1	* AWS_Pal_Mod_Lin4
	DC.B	-1	* AWS_Pal_Mod_Lin5
	DC.W	$c86	* AWS_Pal_Mod_Col2
	DC.W	$a44	* AWS_Pal_Mod_Col3
	DC.W	$321	* AWS_Pal_Mod_Col7
	DC.W	$834	* AWS_Pal_Mod_Col5
	DC.W	$c65	* AWS_Pal_Mod_Col4
	DC.W	$514	* AWS_Pal_Mod_Col6
	DC.W	$dc5	* AWS_Pal_Mod_Col1

DGMP_Full_7c
	DC.W	TX_DG_Monte_Plat_5	* AWS_Table_X_Off
	DC.W	TY_DG_Monte_Plat_5  * AWS_Table_Y_Off
	DC.W	Anim_Full_7c	* AWS_Table_Obj_Off
	DC.B	10	* AWS_Alien_Rate
	DC.B	8	* AWS_Alien_Num
	DC.W	1	* AWS_Alien_Energy
	DC.B	14	* AWS_Alien_Bad_F
	DC.B	3	* AWS_Alien_F_Rate
	DC.B	1	* AWS_Pal_Mod_Lin0
	DC.B	1	* AWS_Pal_Mod_Lin1
	DC.B	1	* AWS_Pal_Mod_Lin2
	DC.B	1	* AWS_Pal_Mod_Lin3
	DC.B	1	* AWS_Pal_Mod_Lin4
	DC.B	1	* AWS_Pal_Mod_Lin5
	DC.W	$c86	* AWS_Pal_Mod_Col2
	DC.W	$a44	* AWS_Pal_Mod_Col3
	DC.W	$321	* AWS_Pal_Mod_Col7
	DC.W	$834	* AWS_Pal_Mod_Col5
	DC.W	$c65	* AWS_Pal_Mod_Col4
	DC.W	$514	* AWS_Pal_Mod_Col6
	DC.W	$dc5	* AWS_Pal_Mod_Col1

DGDP_Feuillage_7c
	DC.W	TX_DG_Descend_Plat_3 * AWS_Table_X_Off
	DC.W	TY_DG_Descend_Plat_3 * AWS_Table_Y_Off
	DC.W	Anim_Feuillage_7c	* AWS_Table_Obj_Off
	DC.B	30	* AWS_Alien_Rate
	DC.B	4	* AWS_Alien_Num
	DC.W	1	* AWS_Alien_Energy
	DC.B	255	* AWS_Alien_Bad_F
	DC.B	0	* AWS_Alien_F_Rate
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

GDDP_Feuillage_7c
	DC.W	TX_GD_Descend_Plat_1 * AWS_Table_X_Off
	DC.W	TY_GD_Descend_Plat_1 * AWS_Table_Y_Off
	DC.W	Anim_Feuillage_7c	* AWS_Table_Obj_Off
	DC.B	30	* AWS_Alien_Rate
	DC.B	5	* AWS_Alien_Num
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
	DC.W	-1	* AWS_Pal_Mod_Col4
	DC.W	-1	* AWS_Pal_Mod_Col5
	DC.W	-1	* AWS_Pal_Mod_Col6
	DC.W	-1	* AWS_Pal_Mod_Col7

DGS_Feuillage_7c
	DC.W	TX_DG_Sin_1	* AWS_Table_X_Off
	DC.W	TY_DG_Sin_1	* AWS_Table_Y_Off
	DC.W	Anim_Feuillage_7c	* AWS_Table_Obj_Off
	DC.B	40	* AWS_Alien_Rate
	DC.B	3	* AWS_Alien_Num
	DC.W	1	* AWS_Alien_Energy
	DC.B	255	* AWS_Alien_Bad_F
	DC.B	0	* AWS_Alien_F_Rate
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

BHBH_Feuillage_7c
	DC.W	TX_Boucle_HBH	* AWS_Table_X_Off
	DC.W	TY_Boucle_HBH	* AWS_Table_Y_Off
	DC.W	Anim_Feuillage_7c	* AWS_Table_Obj_Off
	DC.B	30	* AWS_Alien_Rate
	DC.B	4	* AWS_Alien_Num
	DC.W	1	* AWS_Alien_Energy
	DC.B	25	* AWS_Alien_Bad_F
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

DGDP_Fantome
	DC.W	TX_DG_Descend_Plat_7 * AWS_Table_X_Off
	DC.W	TY_DG_Descend_Plat_7 * AWS_Table_Y_Off
	DC.W	Anim_Fantome	* AWS_Table_Obj_Off
	DC.B	30	* AWS_Alien_Rate
	DC.B	4	* AWS_Alien_Num
	DC.W	1	* AWS_Alien_Energy
	DC.B	16	* AWS_Alien_Bad_F
	DC.B	3	* AWS_Alien_F_Rate
	DC.B	-1	* AWS_Pal_Mod_Lin0
	DC.B	-1	* AWS_Pal_Mod_Lin1
	DC.B	-1	* AWS_Pal_Mod_Lin2
	DC.B	1	* AWS_Pal_Mod_Lin3
	DC.B	1	* AWS_Pal_Mod_Lin4
	DC.B	1	* AWS_Pal_Mod_Lin5
	DC.W	$557	* AWS_Pal_Mod_Col1
	DC.W	-1	* AWS_Pal_Mod_Col2
	DC.W	-1	* AWS_Pal_Mod_Col3
	DC.W	$0543	* AWS_Pal_Mod_Col4
	DC.W	-1	* AWS_Pal_Mod_Col5
	DC.W	$77a	* AWS_Pal_Mod_Col6
	DC.W	-1	* AWS_Pal_Mod_Col7

DGDP_Fantome2
	DC.W	TX_DG_Descend_Plat_6 * AWS_Table_X_Off
	DC.W	TY_DG_Descend_Plat_6 * AWS_Table_Y_Off
	DC.W	Anim_Fantome	* AWS_Table_Obj_Off
	DC.B	30	* AWS_Alien_Rate
	DC.B	3	* AWS_Alien_Num
	DC.W	2	* AWS_Alien_Energy
	DC.B	10	* AWS_Alien_Bad_F
	DC.B	2	* AWS_Alien_F_Rate
	DC.B	-1	* AWS_Pal_Mod_Lin0
	DC.B	-1	* AWS_Pal_Mod_Lin1
	DC.B	-1	* AWS_Pal_Mod_Lin2
	DC.B	1	* AWS_Pal_Mod_Lin3
	DC.B	1	* AWS_Pal_Mod_Lin4
	DC.B	1	* AWS_Pal_Mod_Lin5
	DC.W	$557	* AWS_Pal_Mod_Col1
	DC.W	-1	* AWS_Pal_Mod_Col2
	DC.W	-1	* AWS_Pal_Mod_Col3
	DC.W	$0543	* AWS_Pal_Mod_Col4
	DC.W	-1	* AWS_Pal_Mod_Col5
	DC.W	$77a	* AWS_Pal_Mod_Col6
	DC.W	-1	* AWS_Pal_Mod_Col7

DGDP_Grosse_Tete
	DC.W	TX_DG_Descend_Plat_7 * AWS_Table_X_Off
	DC.W	TY_DG_Descend_Plat_7 * AWS_Table_Y_Off
	DC.W	Anim_Bestiolle	* AWS_Table_Obj_Off
	DC.B	30	* AWS_Alien_Rate
	DC.B	4	* AWS_Alien_Num
	DC.W	1	* AWS_Alien_Energy
	DC.B	16	* AWS_Alien_Bad_F
	DC.B	2	* AWS_Alien_F_Rate
	DC.B	-1	* AWS_Pal_Mod_Lin0
	DC.B	-1	* AWS_Pal_Mod_Lin1
	DC.B	-1	* AWS_Pal_Mod_Lin2
	DC.B	1	* AWS_Pal_Mod_Lin3
	DC.B	1	* AWS_Pal_Mod_Lin4
	DC.B	1	* AWS_Pal_Mod_Lin5
	DC.W	$da7	* AWS_Pal_Mod_Col1
	DC.W	-1	* AWS_Pal_Mod_Col2
	DC.W	-1	* AWS_Pal_Mod_Col3
	DC.W	-1	* AWS_Pal_Mod_Col4
	DC.W	-1	* AWS_Pal_Mod_Col5
	DC.W	-1	* AWS_Pal_Mod_Col6
	DC.W	-1	* AWS_Pal_Mod_Col7

DGDP_Bestiolle_1
	DC.W	TX_DG_Descend_Plat_8 * AWS_Table_X_Off
	DC.W	TY_DG_Descend_Plat_8 * AWS_Table_Y_Off
	DC.W	Anim_Bestiolle	* AWS_Table_Obj_Off
	DC.B	12	* AWS_Alien_Rate
	DC.B	6	* AWS_Alien_Num
	DC.W	1	* AWS_Alien_Energy
	DC.B	255	* AWS_Alien_Bad_F
	DC.B	0	* AWS_Alien_F_Rate
	DC.B	1	* AWS_Pal_Mod_Lin0
	DC.B	1	* AWS_Pal_Mod_Lin1
	DC.B	1	* AWS_Pal_Mod_Lin2
	DC.B	1	* AWS_Pal_Mod_Lin3
	DC.B	1	* AWS_Pal_Mod_Lin4
	DC.B	1	* AWS_Pal_Mod_Lin5
	DC.W	$da7	* AWS_Pal_Mod_Col1
	DC.W	-1	* AWS_Pal_Mod_Col2
	DC.W	-1	* AWS_Pal_Mod_Col3
	DC.W	-1	* AWS_Pal_Mod_Col4
	DC.W	-1	* AWS_Pal_Mod_Col5
	DC.W	-1	* AWS_Pal_Mod_Col6
	DC.W	-1	* AWS_Pal_Mod_Col7

DGDP_Bestiolle_2
	DC.W	TX_DG_Descend_Plat_2 * AWS_Table_X_Off
	DC.W	TY_DG_Descend_Plat_2 * AWS_Table_Y_Off
	DC.W	Anim_Bestiolle_2 * AWS_Table_Obj_Off
	DC.B	12	* AWS_Alien_Rate
	DC.B	6	* AWS_Alien_Num
	DC.W	1	* AWS_Alien_Energy
	DC.B	18	* AWS_Alien_Bad_F
	DC.B	6	* AWS_Alien_F_Rate
	DC.B	1	* AWS_Pal_Mod_Lin0
	DC.B	1	* AWS_Pal_Mod_Lin1
	DC.B	1	* AWS_Pal_Mod_Lin2
	DC.B	-1	* AWS_Pal_Mod_Lin3
	DC.B	-1	* AWS_Pal_Mod_Lin4
	DC.B	-1	* AWS_Pal_Mod_Lin5
	DC.W	$da7	* AWS_Pal_Mod_Col1
	DC.W	-1	* AWS_Pal_Mod_Col2
	DC.W	-1	* AWS_Pal_Mod_Col3
	DC.W	-1	* AWS_Pal_Mod_Col4
	DC.W	-1	* AWS_Pal_Mod_Col5
	DC.W	-1	* AWS_Pal_Mod_Col6
	DC.W	-1	* AWS_Pal_Mod_Col7

DGS_Bestiolle
	DC.W	TX_DG_Sin_1	* AWS_Table_X_Off
	DC.W	TY_DG_Sin_1	* AWS_Table_Y_Off
	DC.W	Anim_Bestiolle_2 * AWS_Table_Obj_Off
	DC.B	20	* AWS_Alien_Rate
	DC.B	3	* AWS_Alien_Num
	DC.W	2	* AWS_Alien_Energy
	DC.B	18	* AWS_Alien_Bad_F
	DC.B	2	* AWS_Alien_F_Rate
	DC.B	1	* AWS_Pal_Mod_Lin0
	DC.B	1	* AWS_Pal_Mod_Lin1
	DC.B	-1	* AWS_Pal_Mod_Lin2
	DC.B	-1	* AWS_Pal_Mod_Lin3
	DC.B	-1	* AWS_Pal_Mod_Lin4
	DC.B	-1	* AWS_Pal_Mod_Lin5
	DC.W	$da7	* AWS_Pal_Mod_Col2
	DC.W	-1	* AWS_Pal_Mod_Col3
	DC.W	-1	* AWS_Pal_Mod_Col7
	DC.W	-1	* AWS_Pal_Mod_Col5
	DC.W	-1	* AWS_Pal_Mod_Col4
	DC.W	-1	* AWS_Pal_Mod_Col6
	DC.W	-1	* AWS_Pal_Mod_Col1

DGDP_Boulle
	DC.W	TX_DG_Descend_Plat_8 * AWS_Table_X_Off
	DC.W	TY_DG_Descend_Plat_8 * AWS_Table_Y_Off
	DC.W	Anim_Boulle	* AWS_Table_Obj_Off
	DC.B	12	* AWS_Alien_Rate
	DC.B	6	* AWS_Alien_Num
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
	DC.W	-1	* AWS_Pal_Mod_Col4
	DC.W	-1	* AWS_Pal_Mod_Col5
	DC.W	-1	* AWS_Pal_Mod_Col6
	DC.W	-1	* AWS_Pal_Mod_Col7

DGDP_Boulle_2
	DC.W	TX_DG_Descend_Plat_9 * AWS_Table_X_Off
	DC.W	TY_DG_Descend_Plat_9 * AWS_Table_Y_Off
	DC.W	Anim_Boulle	* AWS_Table_Obj_Off
	DC.B	12	* AWS_Alien_Rate
	DC.B	6	* AWS_Alien_Num
	DC.W	2	* AWS_Alien_Energy
	DC.B	12	* AWS_Alien_Bad_F
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

DGMP_Boulle
	DC.W	TX_DG_Monte_Plat_5	* AWS_Table_X_Off
	DC.W	TY_DG_Monte_Plat_5	* AWS_Table_Y_Off
	DC.W	Anim_Boulle	* AWS_Table_Obj_Off
	DC.B	8	* AWS_Alien_Rate
	DC.B	8	* AWS_Alien_Num
	DC.W	1	* AWS_Alien_Energy
	DC.B	12	* AWS_Alien_Bad_F
	DC.B	4	* AWS_Alien_F_Rate
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

GDDP_Boulle
	DC.W	TX_GD_Descend_Plat_3 * AWS_Table_X_Off
	DC.W	TY_GD_Descend_Plat_3 * AWS_Table_Y_Off
	DC.W	Anim_Boulle	* AWS_Table_Obj_Off
	DC.B	10	* AWS_Alien_Rate
	DC.B	6	* AWS_Alien_Num
	DC.W	1	* AWS_Alien_Energy
	DC.B	255	* AWS_Alien_Bad_F
	DC.B	0	* AWS_Alien_F_Rate
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




* ANIMATION TABLE
* ---------------


__	MACRO
\1	EQU     *-Anim_Base
	ENDM

Anim_Base


 __ Anim_Transporte
	DC.W	Obj_Transporte_1
	DC.W	Obj_Transporte_2
	DC.W	Obj_Transporte_3
	DC.W	-1

 __ Anim_Boulle
	DC.W	Obj_Boulle
	DC.W	-1
 __ Anim_Boulle2
	DC.W	Obj_Boulle2
	DC.W	-1

 __ Anim_Poisson
	DC.W	Obj_Poisson3
	DC.W	-1

 __ Anim_Poisson_Bleu
	DC.W	Obj_Poisson1
	DC.W	Obj_Poisson1
	DC.W	Obj_Poisson1
	DC.W	Obj_Poisson1
	DC.W	Obj_Poisson1
	DC.W	Obj_Poisson2
	DC.W	Obj_Poisson2
	DC.W	Obj_Poisson2
	DC.W	-1

 __ Anim_Full_7c
	DC.W	Obj_Full_7c
	DC.w	-1

 __ Anim_Feuillage_7c
	DC.W	Obj_Feuillage_1
	DC.W	Obj_Feuillage_1
	DC.W	Obj_Feuillage_2
	DC.W	Obj_Feuillage_2
	DC.W	Obj_Feuillage_3
	DC.W	Obj_Feuillage_3
	DC.W	Obj_Feuillage_4
	DC.W	Obj_Feuillage_4
	DC.W	Obj_Feuillage_3
	DC.W	Obj_Feuillage_3
	DC.W	Obj_Feuillage_2
	DC.W	Obj_Feuillage_2
	DC.w	-1


 __ Anim_Bestiolle
	DC.W	Obj_Volant_Missile_1
	DC.W	Obj_Volant_Missile_1
	DC.W	Obj_Volant_Missile_1
	DC.W	Obj_Volant_Missile_2
	DC.W	Obj_Volant_Missile_2
	DC.W	Obj_Volant_Missile_2
	DC.W	-1

 __ Anim_Bestiolle_2
	DC.W	Obj_Transporte_1
	DC.W	Obj_Transporte_2
	DC.W	Obj_Transporte_3
	DC.W	-1

 __ Anim_Fantome
	DC.W	Obj_Fantome
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

R_S_Pal
	DC.B	-1	* Mod_Lin0
	DC.B	-1	* Mod_Lin1
	DC.B	-1	* Mod_Lin2
	DC.B	-1	* Mod_Lin3
	DC.B	-1	* Mod_Lin4
	DC.B	1	* Mod_Lin5
	DC.W	$d96	* AWS_Pal_Mod_Col1
	DC.W	-1	* AWS_Pal_Mod_Col2
	DC.W	-1	* AWS_Pal_Mod_Col3
	DC.W	$964	* AWS_Pal_Mod_Col4
	DC.W	$554	* AWS_Pal_Mod_Col5
	DC.W	$733	* AWS_Pal_Mod_Col6
	DC.W	$986	* AWS_Pal_Mod_Col7

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
	move.l	#R_S_Pal,Rout_Pal_Ptr(D)
                  st	Refresh_Pal+1(D)
	addq	#1,Rout_Mod_Pal_Counter(D)
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
	subq	#1,Rout_Mod_Pal_Counter(D)
	tst	Rout_Mod_Pal_Counter(D)
	bne	.no_close_col
	move.l	#-1,Rout_Pal_Ptr(D)
	st	Refresh_Pal+1(D)
.no_close_col
	move.b	#1,AWO_ALien_Status(a4)
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

R_B_Pal
	DC.B	1	* Mod_Lin0
	DC.B	1	* Mod_Lin1
	DC.B	1	* Mod_Lin2
	DC.B	-1	* Mod_Lin3
	DC.B	-1	* Mod_Lin4
	DC.B	-1	* Mod_Lin5
	DC.W	-1	* AWS_Pal_Mod_Col1
	DC.W	-1	* AWS_Pal_Mod_Col2
	DC.W	-1	* AWS_Pal_Mod_Col3
	DC.W	-1	* AWS_Pal_Mod_Col4
	DC.W	-1	* AWS_Pal_Mod_Col5
	DC.W	-1	* AWS_Pal_Mod_Col6
	DC.W	-1	* AWS_Pal_Mod_Col7
	DC.W	-1	* Mod_Col7


R_Bomber
	move.l	Rout_Param_Ptr(a0),a1
	move.l	Rout_Awo_Ptr(a0),a2
	lea	Rout_Variables(a0),a3

	move	R_B_Mode(a3),d0
	bne	.no_init
;	move.l	#R_B_Pal,Rout_Pal_Ptr(D)	* MODE 0
;               	st	Refresh_Pal+1(D)
;	addq	#1,Rout_Mod_Pal_Counter(D)
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
;	subq	#1,Rout_Mod_Pal_Counter(D)
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
	move	#Obj_Boulle,AWO_Alien_Obj_Off(a4)
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

R_TE_Pal
	DC.B	1	* Mod_Lin0
	DC.B	1	* Mod_Lin1
	DC.B	1	* Mod_Lin2
	DC.B	-1	* Mod_Lin3
	DC.B	-1	* Mod_Lin4
	DC.B	-1	* Mod_Lin5
	DC.W	$0da7	* Mod_Col1
	DC.W	-1	* Mod_Col2
	DC.W	-1	* Mod_Col3
	DC.W	-1	* Mod_Col4
	DC.W	-1	* Mod_Col5
	DC.W	-1	* Mod_Col6
	DC.W	-1	* Mod_Col7

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
	move.l	#R_TE_Pal,Rout_Pal_Ptr(D)	* MODE 0
                  st	Refresh_Pal+1(D)
	addq	#1,Rout_Mod_Pal_Counter(D)
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
	subq	#1,Rout_Mod_Pal_Counter(D)
	tst	Rout_Mod_Pal_Counter(D)
	bne	.no_close_col
	move.l	#-1,Rout_Pal_Ptr(D)
	st	Refresh_Pal+1(D)
.no_close_col
.end
	lea	Rel_Start+32768,D
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

R_T_Pal
	DC.B	-1	* Mod_Lin0
	DC.B	-1	* Mod_Lin1
	DC.B	-1	* Mod_Lin2
	DC.B	1	* Mod_Lin3
	DC.B	1	* Mod_Lin4
	DC.B	1	* Mod_Lin5
	DC.W	$c97	* Mod_Col1
	DC.W	-1	* Mod_Col2
	DC.W	-1	* Mod_Col3
	DC.W	$0543	* Mod_Col4
	DC.W	-1	* Mod_Col5
	DC.W	$0fb9	* Mod_Col6
	DC.W	-1	* Mod_Col7

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
	DC.B	1	* AWS_Pal_Mod_Lin0
	DC.B	1	* AWS_Pal_Mod_Lin1
	DC.B	1	* AWS_Pal_Mod_Lin2
	DC.B	-1	* AWS_Pal_Mod_Lin3
	DC.B	-1	* AWS_Pal_Mod_Lin4
	DC.B	-1	* AWS_Pal_Mod_Lin5
	DC.W	$0da7	* AWS_Pal_Mod_Col1
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
	DC.B	1	* AWS_Pal_Mod_Lin0
	DC.B	1	* AWS_Pal_Mod_Lin1
	DC.B	1	* AWS_Pal_Mod_Lin2
	DC.B	-1	* AWS_Pal_Mod_Lin3
	DC.B	-1	* AWS_Pal_Mod_Lin4
	DC.B	-1	* AWS_Pal_Mod_Lin5
	DC.W	$0da7	* AWS_Pal_Mod_Col1
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
	move.l	#R_T_Pal,Rout_Pal_Ptr(D)	* MODE 0
                  st	Refresh_Pal+1(D)
	addq	#1,Rout_Mod_Pal_Counter(D)
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
	subq	#1,Rout_Mod_Pal_Counter(D)
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

R_SC_Pal
	DC.B	-1	* Mod_Lin0
	DC.B	-1	* Mod_Lin1
	DC.B	-1	* Mod_Lin2
	DC.B	1	* Mod_Lin3
	DC.B	1	* Mod_Lin4
	DC.B	1	* Mod_Lin5
	DC.W	$aa6	* Mod_Col1
	DC.W	-1	* Mod_Col2
	DC.W	-1	* Mod_Col3
	DC.W	$543	* Mod_Col4
	DC.W	-1	* Mod_Col5
	DC.W	$dc8	* Mod_Col6
	DC.W	-1	* Mod_Col7

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
	move.l	#R_SC_Pal,Rout_Pal_Ptr(D)	* MODE 0
                  st	Refresh_Pal+1(D)
	addq	#1,Rout_Mod_Pal_Counter(D)
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
	subq	#1,Rout_Mod_Pal_Counter(D)
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

R_VM_Pal
	DC.B	1	* Mod_Lin0
	DC.B	1	* Mod_Lin1
	DC.B	1	* Mod_Lin2
	DC.B	1	* Mod_Lin3
	DC.B	1	* Mod_Lin4
	DC.B	1	* Mod_Lin5
	DC.W	$7aa	* Mod_Col1
	DC.W	-1	* Mod_Col2
	DC.W	-1	* Mod_Col3
	DC.W	-1	* Mod_Col4
	DC.W	-1	* Mod_Col5
	DC.W	-1	* Mod_Col6
	DC.W	-1	* Mod_Col7

R_Volant_Missile
	move.l	Rout_Param_Ptr(a0),a1
	move.l	Rout_Awo_Ptr(a0),a2
	lea	Rout_Variables(a0),a3
	move	R_VM_Mode(a3),d0
	bne	.no_init
	move.l	#R_VM_Pal,Rout_Pal_Ptr(D)	* MODE 0
                  st	Refresh_Pal+1(D)
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
	subq	#3,AWO_Alien_X(a4)
	move	#Obj_Tir_7,Awo_Alien_Obj_Off(a4)
	move	AWO_Alien_X(a4),d1
	cmp	R_VM_Target_X(a3),d1
	bgt	.no_fire
	bra	.tacke_desision_fy
.fmode1				* up
	subq	#3,AWO_Alien_Y(a4)
	move	#Obj_Tir_1,Awo_Alien_Obj_Off(a4)
	move	AWO_Alien_Y(a4),d1
	cmp	R_VM_Target_Y(a3),d1
	bgt	.no_fire
	bra	.tacke_desision_fx
.fmode2				* right
	addq	#3,AWO_Alien_X(a4)
	move	#Obj_Tir_3,Awo_Alien_Obj_Off(a4)
	move	AWO_Alien_X(a4),d1
	cmp	R_VM_Target_X(a3),d1
	blt	.no_fire
	bra	.tacke_desision_fy
.fmode3				* down
	addq	#3,AWO_Alien_Y(a4)
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



* MONSTRE VOLANT GROSSI SI TOUCHE
* -------------------------------


	RSRESET
R_VG_Mode	RS.W    1

	RSRESET
P_VG_Y	RS.W	1
P_VG_Speed	RS.W	1

R_VG_Pal
	DC.B	-1	* Mod_Lin0
	DC.B	-1	* Mod_Lin1
	DC.B	-1	* Mod_Lin2
	DC.B	1	* Mod_Lin3
	DC.B	1	* Mod_Lin4
	DC.B	1	* Mod_Lin5
	DC.W	$0c97	* Mod_Col1
	DC.W	$0765	* Mod_Col2
	DC.W	$0321	* Mod_Col3
	DC.W	$0432	* Mod_Col4
	DC.W	$0554	* Mod_Col5
	DC.W	$0fb9	* Mod_Col6
	DC.W	$0986	* Mod_Col7

R_Volant_Grossi
	move.l	Rout_Param_Ptr(a0),a1
	move.l	Rout_Awo_Ptr(a0),a2
	lea	Rout_Variables(a0),a3

	move	R_VG_Mode(a3),d0
	bne	.no_init
	move.l	#R_VG_Pal,Rout_Pal_Ptr(D)	* MODE 0
                  st	Refresh_Pal+1(D)
	addq	#1,Rout_Mod_Pal_Counter(D)
	move.l	#$00010000,(a2)+
	move	#256+340,Awo_Alien_X(a2)
	move	P_VG_Y(a1),Awo_Alien_Y(a2)
	move	#Obj_Grossi_1,Awo_Alien_Obj_Off(a2)
	move	#10,AWO_Alien_Energy(a2)
	clr.l	Awo_Alien_Status(a2)
	addq	#1,R_VG_Mode(a3)
	bra	.end
.no_init
	move.l	#$00010000,(a2)+
	move	P_VG_Speed(a1),d1
	sub	d1,AWO_Alien_X(a2)
	cmp	#200,AWO_Alien_X(a2)
	bgt	.no_end
	move.l	#-1,(a0)	* CLOSE
	move	#-1,-4(a2)
	subq	#1,Rout_Mod_Pal_Counter(D)
	tst	Rout_Mod_Pal_Counter(D)
	bne	.no_close_col
	move.l	#-1,Rout_Pal_Ptr(D)
	st	Refresh_Pal+1(D)
.no_close_col
.no_end
	move	AWO_Alien_Energy(a2),d1
	cmp	#7,d1
	bge	.phase1
	cmp	#3,d1
	bge	.phase2
	move	#Obj_Grossi_3,Awo_Alien_Obj_Off(a2)
	bra	.end
.phase2
	move	#Obj_Grossi_2,Awo_Alien_Obj_Off(a2)
	bra	.end
.phase1
	move	#Obj_Grossi_1,Awo_Alien_Obj_Off(a2)
.end
	rts



* REBONDIT SUR LE SOL
* -------------------


	RSRESET
R_J_Mode	RS.W    1

R_J_Pal
	DC.B	1	* Mod_Lin0
	DC.B	1	* Mod_Lin1
	DC.B	1	* Mod_Lin2
	DC.B	1	* Mod_Lin3
	DC.B	1	* Mod_Lin4
	DC.B	1	* Mod_Lin5
	DC.W	$0da7	* Mod_Col1
	DC.W	$0765	* Mod_Col2
	DC.W	$0321	* Mod_Col3
	DC.W	$0432	* Mod_Col4
	DC.W	$0554	* Mod_Col5
	DC.W	$0fed	* Mod_Col6
	DC.W	$0986	* Mod_Col7

R_Jumper
	move.l	Rout_Param_Ptr(a0),a1
	move.l	Rout_Awo_Ptr(a0),a2
	lea	Rout_Variables(a0),a3

	move	R_J_Mode(a3),d0
	bne	.no_init
	move.l	#R_J_Pal,Rout_Pal_Ptr(D)	* MODE 0
                  st	Refresh_Pal+1(D)
	move.l	#$00010000,(a2)+
	move	#256+340,Awo_Alien_X(a2)
	move	#256+190,Awo_Alien_Y(a2)
	move	#Obj_Grossi_1,Awo_Alien_Obj_Off(a2)
	move	#10,AWO_Alien_Energy(a2)
	clr.l	Awo_Alien_Status(a2)
	addq	#1,R_J_Mode(a3)
	bra	.end
.no_init
	move.l	#$00010000,(a2)+
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
	move	AWO_Alien_Energy(a2),d1
	cmp	#7,d1
	bge	.phase1
	cmp	#3,d1
	bge	.phase2
	move	#Obj_Grossi_3,Awo_Alien_Obj_Off(a2)
	bra	.end
.phase2
	move	#Obj_Grossi_2,Awo_Alien_Obj_Off(a2)
	bra	.end
.phase1
	move	#Obj_Grossi_1,Awo_Alien_Obj_Off(a2)
.end
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

R_A_Pal
	DC.B	1	* Mod_Lin0
	DC.B	1	* Mod_Lin1
	DC.B	1	* Mod_Lin2
	DC.B	1	* Mod_Lin3
	DC.B	1	* Mod_Lin4
	DC.B	1	* Mod_Lin5
	DC.W	$aa6	* Mod_Col1
	DC.W	-1	* Mod_Col2
	DC.W	-1	* Mod_Col3
	DC.W	-1	* Mod_Col4
	DC.W	-1	* Mod_Col5
	DC.W	-1	* Mod_Col6
	DC.W	-1	* Mod_Col7

R_Araignee
	move.l	Rout_Param_Ptr(a0),a1
	move.l	Rout_Awo_Ptr(a0),a2
	lea	Rout_Variables(a0),a3

	move	R_A_Mode(a3),d0
	bne	.no_init
	move.l	#R_A_Pal,Rout_Pal_Ptr(D)	* MODE 0
                  st	Refresh_Pal+1(D)
	addq	#1,Rout_Mod_Pal_Counter(D)
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
	subq	#1,Rout_Mod_Pal_Counter(D)
	tst	Rout_Mod_Pal_Counter(D)
	bne	.no_close_col
	move.l	#-1,Rout_Pal_Ptr(D)
	st	Refresh_Pal+1(D)
.no_close_col
.end
	rts



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

R_R_Pal
	DC.B	-1	* Mod_Lin0
	DC.B	-1	* Mod_Lin1
	DC.B	-1	* Mod_Lin2
	DC.B	1	* Mod_Lin3
	DC.B	1	* Mod_Lin4
	DC.B	1	* Mod_Lin5
	DC.W	$da7	* Mod_Col1
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
	move.l	P_R_Pal_Ptr(a1),Rout_Pal_Ptr(D)	* MODE 0
                  st	Refresh_Pal+1(D)
	addq	#1,Rout_Mod_Pal_Counter(D)
	move.l	#$00010000,(a2)+
	move	#256+340,Awo_Alien_X(a2)
	move	P_R_Y(a1),Awo_Alien_Y(a2)
                  lea	Anim_Base,a4
	add	P_R_Anim_Ptr(a1),a4
	move.l	a4,R_R_Anim_D_ptr(a3)
	move	(a4),Awo_Alien_Obj_Off(a2)
	move	#3,AWO_Alien_Energy(a2)
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
	subq	#1,Rout_Mod_Pal_Counter(D)
	tst	Rout_Mod_Pal_Counter(D)
	bne	.no_close_col
	move.l	#-1,Rout_Pal_Ptr(D)
	st	Refresh_Pal+1(D)
.no_close_col
.end
	rts



* MONSTRE FINAL
* -------------


	RSRESET
R_F_Mode	RS.W	1
R_F_Time	RS.W    1
R_F_Step	RS.W	1
R_F_Explo_Step	RS.W	1

R_T_Final_1
	DC.W	TX_Final_1	* AWS_Table_X_Off
	DC.W	TY_Final_1	* AWS_Table_Y_Off
	DC.W	Anim_Boulle2	* AWS_Table_Obj_Off
	DC.B	8	* AWS_Alien_Rate
	DC.B	6	* AWS_Alien_Num
	DC.W	4	* AWS_Alien_Energy
	DC.B	255	* AWS_Alien_Bad_F
	DC.B	0	* AWS_Alien_F_Rate
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
R_T_Final_2
	DC.W	TX_Final_2	* AWS_Table_X_Off
	DC.W	TY_Final_2	* AWS_Table_Y_Off
	DC.W	Anim_Boulle2	* AWS_Table_Obj_Off
	DC.B	8	* AWS_Alien_Rate
	DC.B	6	* AWS_Alien_Num
	DC.W	4	* AWS_Alien_Energy
	DC.B	255	* AWS_Alien_Bad_F
	DC.B	0	* AWS_Alien_F_Rate
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
R_T_Final_3
	DC.W	TX_Final_3	* AWS_Table_X_Off
	DC.W	TY_Final_3	* AWS_Table_Y_Off
	DC.W	Anim_Boulle2	* AWS_Table_Obj_Off
	DC.B	8	* AWS_Alien_Rate
	DC.B	6	* AWS_Alien_Num
	DC.W	4	* AWS_Alien_Energy
	DC.B	255	* AWS_Alien_Bad_F
	DC.B	0	* AWS_Alien_F_Rate
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

R_F_Pal_Flash
	DC.B	1	* Mod_Lin0
	DC.B	1	* Mod_Lin1
	DC.B	1	* Mod_Lin2
	DC.B	1	* Mod_Lin3
	DC.B	1	* Mod_Lin4
	DC.B	1	* Mod_Lin5
	DC.W	$fff	* Mod_Col1
	DC.W	$fff	* Mod_Col2
	DC.W	$fff	* Mod_Col3
	DC.W	$fff	* Mod_Col4
	DC.W	$fff	* Mod_Col5
	DC.W	$fff	* Mod_Col6
	DC.W	$fff	* Mod_Col7

R_F_Pal_Normal
	DC.B	-1	* Mod_Lin0
	DC.B	-1	* Mod_Lin1
	DC.B	-1	* Mod_Lin2
	DC.B	-1	* Mod_Lin3
	DC.B	-1	* Mod_Lin4
	DC.B	-1	* Mod_Lin5
	DC.W	-1	* Mod_Col1
	DC.W	-1	* Mod_Col2
	DC.W	-1	* Mod_Col3
	DC.W	-1	* Mod_Col4
	DC.W	-1	* Mod_Col5
	DC.W	-1	* Mod_Col6
	DC.W	-1	* Mod_Col7

R_F_Pal_Explo
	DC.B	1	* Mod_Lin0
	DC.B	1	* Mod_Lin1
	DC.B	1	* Mod_Lin2
	DC.B	1	* Mod_Lin3
	DC.B	1	* Mod_Lin4
	DC.B	1	* Mod_Lin5
	DC.W	-1	* Mod_Col1
	DC.W	$fa0	* Mod_Col2
	DC.W	-1	* Mod_Col3
	DC.W	$f50	* Mod_Col4
	DC.W	-1	* Mod_Col5
	DC.W	-1	* Mod_Col6
	DC.W	$ff0	* Mod_Col7

R_Final
	move.l	Rout_Param_Ptr(a0),a1
	move.l	Rout_Awo_Ptr(a0),a2
	lea	Rout_Variables(a0),a3

	move	R_F_Mode(a3),d1
	bne	.no_init
	cmp	#2,d1
	beq	.explo
	move.l	#$00010000,(a2)+
	move	#256+160,Awo_Alien_X(a2)
	move	#256+90,Awo_Alien_Y(a2)
	move	#Obj_Final,Awo_Alien_Obj_Off(a2)
	move	#130,AWO_Alien_Energy(a2)
	clr.l	Awo_Alien_Status(a2)
	move.b	#30,AWO_Alien_F_RT_S(a2)
	clr	Rout_Mod_Pal_Counter(D)
	addq	#1,R_F_Mode(a3)
	bra	R_end
.no_init
	move.l	#$00010000,(a2)+
                  move.b	AWO_Alien_Status(a2),d1
	and	#$f0,d1
	beq     .cont3
	cmp	#$20,d1
	bgt	.cont1
	move.l	#R_F_Pal_Flash,Rout_Pal_Ptr(D)
                  st	Refresh_Pal+1(D)
                  move	#1,Short_Phase(D)
	bra	.cont3
.cont1
	move.l	#R_F_Pal_Normal,Rout_Pal_Ptr(D)
                  st	Refresh_Pal+1(D)
                  move	#1,Short_Phase(D)
.cont3
                  move.b	AWO_Alien_Status(a2),d1
	and	#$f,d1
	beq	.cont2
	addq	#1,R_F_Mode(a3)
.explo
                  addq	#1,R_F_Explo_Step(a3)
                  move	R_F_Explo_Step(a3),d1
	cmp	#1,d1
	bne	.cont4
	move	#256+220,Awo_Alien_X(a2)
	move	#256+100,Awo_Alien_Y(a2)
	move	#Obj_Big_Explo_1,Awo_Alien_Obj_Off(a2)
	clr.l	Awo_Alien_Status(a2)
	move.b	#1,Awo_Alien_Status(a2)
.cont4
	cmp	#17,d1
	bne     .cont5
	move.l	#R_F_Pal_Flash,Rout_Pal_Ptr(D)
                  st	Refresh_Pal+1(D)
                  move	#1,Short_Phase(D)
	move	#1,Sound0_Req(D)
	move    #63,Sound0_Vol_Req(D)
	jsr	Sound_Start
.cont5
	cmp	#19,d1
	bne	.cont6
                  lea	Front_Screens,a1
	move.l	#Front_Screens_E,d2
.loop
	clr.l	(a1)+
	cmp.l	d2,a1
	blt	.loop
	lea	Track_Table-4(D),a1
	moveq	#7,d2
.track_loop
	lea	4(a1),a1
	bset	#7,(a1)
	dbra	d2,.track_loop
	move.l	R_F_AWO_Ptr1(D),a1
                  move.l	#-1,(a1)
	move.l	R_F_AWO_Ptr2(D),a1
                  move.l	#-1,(a1)
	move.l	R_F_AWO_Ptr3(D),a1
                  move.l	#-1,(a1)
.cont6
	cmp	#21,d1
	bne	.cont7
	move	#256+250,Awo_Alien_X(a2)
	move	#256+80,Awo_Alien_Y(a2)
	move	#Obj_Big_Explo_1,Awo_Alien_Obj_Off(a2)
	clr.l	Awo_Alien_Status(a2)
	move.b	#1,Awo_Alien_Status(a2)
	move.l	#R_F_Pal_Explo,Rout_Pal_Ptr(D)
                  st	Refresh_Pal+1(D)
                  move	#1,Short_Phase(D)
	move	#1,Sound0_Req(D)
	move    #63,Sound0_Vol_Req(D)
	jsr	Sound_Start
.cont7
	cmp	#35,d1
	bne	.cont8
	move	#256+200,Awo_Alien_X(a2)
	move	#256+110,Awo_Alien_Y(a2)
	move	#Obj_Big_Explo_2,Awo_Alien_Obj_Off(a2)
	clr.l	Awo_Alien_Status(a2)
	move.b	#1,Awo_Alien_Status(a2)
	move	#1,Sound0_Req(D)
	move    #63,Sound0_Vol_Req(D)
	jsr	Sound_Start
.cont8
	cmp	#52,d1
	bne     R_End
	move	#256+250,Awo_Alien_X(a2)
	move	#256+120,Awo_Alien_Y(a2)
	move	#Obj_Big_Explo_3,Awo_Alien_Obj_Off(a2)
	clr.l	Awo_Alien_Status(a2)
	move.b	#1,Awo_Alien_Status(a2)
	move	#1,Sound0_Req(D)
	move    #63,Sound0_Vol_Req(D)
	jsr	Sound_Start
	move	#25,Quit_Delay(D)
	st	Clean_Up(D)
	bra	R_End
.cont2
                  addq	#1,R_F_Time(a3)
	cmp	#70,R_F_Time(a3)
	bne	R_end
                  clr	R_F_Time(a3)
                  tst	R_F_Step(a3)
	beq	Step_1
	subq	#1,R_F_Step(a3)
	beq	Step_2
Step_3
                  move	#0,R_F_Step(a3)
	move.l	#R_T_Final_3,d0
	or.l	#$40000000,d0
	move	#256+268,d1
	move	#256+100,d2

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
	move.l	d0,a4
.awo_loop
	lea	AWO_size(a2),a2
	tst	(a2)
	bpl	.awo_loop
	move.l	a2,R_F_AWO_Ptr1(D)
	clr.l	(a2)
	move.l	a2,TS_Awo_Ptr(a1)

	move	AWS_Alien_Energy(a4),d1
	moveq	#0,d2
	move.b	AWS_Alien_F_Rate(a4),d3
	moveq	#31,d0
	addq	#4,a2
.init_loop
	move	d1,AWO_Alien_Energy(a2)
	clr.b	AWO_Alien_Status(a2)

	addq.b	#1,d2
	cmp.b	d2,d3
	bne	.no
	move.b	AWS_Alien_Bad_F(a4),AWO_Alien_F_Rt_S(a2)
	moveq	#0,d2
	bra	.cont
.no
	st      AWO_Alien_F_Rt_S(a2)
.cont
	clr.b	AWO_Alien_F_Rt_D(a2)

	lea	AWO_Len(a2),a2
	dbra	d0,.init_loop
	bra	R_end
Step_2
                  move	#2,R_F_Step(a3)
	move.l	#R_T_Final_2,d0
	or.l	#$40000000,d0
	move	#256+268,d1
	move	#256+108,d2

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
	move.l	d0,a4
.awo_loop
	lea	AWO_size(a2),a2
	tst	(a2)
	bpl	.awo_loop
	move.l	a2,R_F_AWO_Ptr2(D)
	clr.l	(a2)
	move.l	a2,TS_Awo_Ptr(a1)

	move	AWS_Alien_Energy(a4),d1
	moveq	#0,d2
	move.b	AWS_Alien_F_Rate(a4),d3
	moveq	#31,d0
	addq	#4,a2
.init_loop
	move	d1,AWO_Alien_Energy(a2)
	clr.b	AWO_Alien_Status(a2)

	addq.b	#1,d2
	cmp.b	d2,d3
	bne	.no
	move.b	AWS_Alien_Bad_F(a4),AWO_Alien_F_Rt_S(a2)
	moveq	#0,d2
	bra	.cont
.no
	st      AWO_Alien_F_Rt_S(a2)
.cont
	clr.b	AWO_Alien_F_Rt_D(a2)

	lea	AWO_Len(a2),a2
	dbra	d0,.init_loop
	bra	R_end
Step_1
                  move	#1,R_F_Step(a3)
	move.l	#R_T_Final_1,d0
	or.l	#$40000000,d0
	move	#256+260,d1
	move	#256+108,d2

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
	move.l	d0,a4
.awo_loop
	lea	AWO_size(a2),a2
	tst	(a2)
	bpl	.awo_loop
	move.l	a2,R_F_AWO_Ptr3(D)
	clr.l	(a2)
	move.l	a2,TS_Awo_Ptr(a1)

	move	AWS_Alien_Energy(a4),d1
	moveq	#0,d2
	move.b	AWS_Alien_F_Rate(a4),d3
	moveq	#31,d0
	addq	#4,a2
.init_loop
	move	d1,AWO_Alien_Energy(a2)
	clr.b	AWO_Alien_Status(a2)

	addq.b	#1,d2
	cmp.b	d2,d3
	bne	.no
	move.b	AWS_Alien_Bad_F(a4),AWO_Alien_F_Rt_S(a2)
	moveq	#0,d2
	bra	.cont
.no
	st      AWO_Alien_F_Rt_S(a2)
.cont
	clr.b	AWO_Alien_F_Rt_D(a2)

	lea	AWO_Len(a2),a2
	dbra	d0,.init_loop
R_end
	rts



* DEMO PAGE
* ---------


	IFNE	ASM_Demo_Mode=2

	RSRESET
P_DP_Num	RS.W	1
P_DP_Delay	RS.W	1

Demo_Page
	move.l	Rout_Param_Ptr(a0),a1

	WAIT_SYNCH
	move	#%0111110111110000,Dmacon(C)
	move	#%0011111111011111,Intena(C)

	move.l	#Dummy_Cl,Cop1lc(C)
	move	d0,Copjmp1(C)
	moveq	#0,d0
	move.l	d0,Spr0data(C)
	move.l	d0,Spr1data(C)
	move.l	d0,Spr2data(C)
	move.l	d0,Spr3data(C)
	move.l	d0,Spr4data(C)
	move.l	d0,Spr5data(C)
	move.l	d0,Spr6data(C)
	move.l	d0,Spr7data(C)
	move.l	d0,Spr0datb(C)
	move.l	d0,Spr1datb(C)
	move.l	d0,Spr2datb(C)
	move.l	d0,Spr3datb(C)
	move.l	d0,Spr4datb(C)
	move.l	d0,Spr5datb(C)
	move.l	d0,Spr6datb(C)
	move.l	d0,Spr7datb(C)

	move.l	#$2c812cc1,Diwstrt(C)
	move.l	#$003800d0,Ddfstrt(C)
	clr.l	Bpl1mod(C)
	move	#%0001001000000000,Bplcon0(C)
	clr.l	Bplcon1(C)

	lea	Page_Cl+2,a2
	move.l  #Front_Screens,d0
	move	d0,4(a2)
	swap	d0
	move	d0,(a2)

	lea	Front_Screens,a4
	move	#2560,d0
.clr_loop
                  clr.l	(a4)+
	dbra	d0,.clr_loop

	move.l  #$00000fff,Color(C)

                  WAIT_SYNCH
	move.l	#Page_Cl,Cop1lc(C)
	move	d0,Copjmp1(C)
                  move	#%1000011111000000,Dmacon(C)

	lea	Font_L,a4
	lea	Text,a3
	move    P_DP_Num(a1),d0
	add	d0,d0
	add	(a3,d0.w),a3
.line_loop
	move	(a3)+,d0	* x1
	bmi	.page_end
	move	(a3)+,d1	* y1
.sentence_loop
	moveq	#0,d2
	move.b	(a3)+,d2
	bmi	.sentence_end
	cmp	#41,d2
	beq	.space

                 	move.l	#Font,d6
	move	d2,d3
	mulu	#84,d3
	add.l	d3,d6
	move.l	d6,Bltapt(C)
	move.l	#Front_Screens,d4
	move	d1,d3
	mulu	#40,d3
	add.l	d3,d4
	moveq	#0,d3
	move	d0,d3
	move	d0,d5
                  lsr	#3,d3
                  bclr	#0,d3
	add.l	d3,d4
	move.l	d4,Bltdpt(C)
	move.l	d4,Bltcpt(C)
	and	#%1111,d5
	ror	#4,d5
	move	d5,d4
	or	#$0bfa,d4
	move	d4,Bltcon0(C)
	move	d5,Bltcon1(C)
	move	#-2,Bltamod(C)
	move	#40-6,Bltcmod(C)
	move	#40-6,Bltdmod(C)
	move.l	#$ffff0000,Bltafwm(C)
	move	#64*20+3,Bltsize(C)
	WAIT_BLIT
.space
	addq	#1,d0
	moveq	#0,d3
	move.b	(a4,d2.w),d3
	add	d3,d0
                  bra	.sentence_loop
.sentence_end
	move.b	(a3),d0
	cmp.b	#$fe,d0
                  bne	.line_loop
	addq	#1,a3
                  bra	.line_loop
.page_end
	clr	Delay_Counter(D)
	move	P_DP_Delay(a1),d1
.wait_loop
	cmp	Delay_Counter(D),d1
	bne	.wait_loop

	move.l	#-1,(a0)	* CLOSE
	move.l	Rout_Awo_Ptr(a0),a2
	move	#-1,(a2)
	move.l	#_Dummy_Cl,Cop1lc(C)
	move	d0,Copjmp1(C)
	lea	Front_Screens,a4
	move	#12672,d0
.clr_loop2
                  clr.l	(a4)+
	dbra	d0,.clr_loop2
                  WAIT_SYNCH
	move.l	#$2d9000b0,Diwstrt(C)
	move.l	#$003800c8,Ddfstrt(C)
	move.l	#_Main_Cl,Cop1lc(C)
	move	d0,Copjmp1(C)
	move	#%1100000010111000,Intena(C)
                  move	#%1000011111100000,Dmacon(C)
	rts
	ENDC






***************************************************************************

*                 BINARY DATA

***************************************************************************



Relative_Tracks
	RINCBIN	Game/lmer.rtb
Absolute_Tracks
	RINCBIN	Game/lmer.atb
Sin_Table1
	RINCBIN	Game/Sin_Table1.bin
Sin_Table2
	RINCBIN	Game/Sin_Table2.bin
Sin_Table3
	RINCBIN	Game/Sin_Table3.bin




