
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
*                             F O R E S T                                 *
*                             -----------                                 *
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
	START_A DGDP_Full_7c,256+240,198

	WAIT	$30
	START_A DGDP_Full_7c,256+260,170

	WAIT	$40
	START_A DGMP_Bestiolle_2,256+300,256+200

	WAIT	$50
	START_A DGDP_Full_7c,256+280,198

	WAIT	$170
	START_C	R_Kamikaze
	PAR	25*7
	PAR	2
	PAR	2
	PAR_END

	WAIT	$1a0
	START_A DGMP_Bestiolle,256+240,256+200

	WAIT	$1b0
	START_A DGDP_Bestiolle_1,256+300,256

	WAIT	$200
	START_C	R_Sol_Etoile
	PAR     150+256
	PAR_END

	WAIT	$380
	START_A DGDP_Full_7c,256+240,198

	WAIT	$390
	START_A DGMP_Bestiolle_2,256+300,256+200

	WAIT	$3b0
	START_A DGDP_Full_7c,256+260,170

	WAIT	$410
	START_A DGDP_Full_7c,256+280,198

	WAIT	$570
	START_A DGDP_Bestiolle_1,256+300,256

                  WAIT	$580
	START_C	R_Araignee
	PAR	50
	PAR     2
	PAR_END

	WAIT	$5e0
	START_A DGDP_Bestiolle_2,256+300,300

	WAIT	$600
	START_A DGDP_Bestiolle_2,256+300,350

	WAIT	$620
	START_C	R_Spectre	* Guided Spectre, Ground Start
	PAR	200+256	* Sp. Launch X
	PAR	25	* Sp. Fire Rate
	PAR	2	* X Speed
	PAR	1	* Y Speed
                  PAR_END

	WAIT	$660
	START_C	R_Spectre	* Guided Spectre, Ground Start
	PAR	200+256	* Sp. Launch X
	PAR	25	* Sp. Fire Rate
	PAR	2	* X Speed
	PAR	3	* Y Speed
                  PAR_END

	WAIT	$680
	START_C	R_Rapide
	PAR	Anim_Speedy
	PAR     10
	PAR_L   Dummy_Pal
                  PAR	256+60
	PAR_END

	WAIT	$6a0
	START_C	R_Rapide
	PAR	Anim_Speedy
	PAR     8
	PAR_L	Dummy_Pal
                  PAR	256+120
	PAR_END

	IFNE	ASM_Demo_Mode=2	* DEMO PAGE
	WAIT	$6d6
	START_C	Demo_Page
	PAR	0
	PAR	150
                  PAR_END
	ENDC

	WAIT	$780
	START_A DGDP_Batman_1,256+300,200

	WAIT	$7c0
	START_C	R_Rapide
	PAR	Anim_Speedy
	PAR     8
	PAR_L	Dummy_Pal
                  PAR	256+140
	PAR_END

	WAIT	$800
	START_A DGDP_Bestiolle_5,256+250,230

	WAIT	$840
	START_C	R_Rapide
	PAR	Anim_Speedy
	PAR     10
	PAR_L	Dummy_Pal
                  PAR	256+176
	PAR_END

	WAIT	$880
	START_A DGS_Batman,256+300,256+40

	WAIT	$8c0
	START_C	R_Rapide
	PAR	Anim_Speedy
	PAR     8
	PAR_L	Dummy_Pal
                  PAR	256+140
	PAR_END

	WAIT	$900
	START_A DGDP_Bestiolle_5,256+200,230


	WAIT	$940
	START_C	R_Rapide
	PAR	Anim_Speedy
	PAR     10
	PAR_L	Dummy_Pal
                  PAR	256+176
	PAR_END

	WAIT	$980
	START_A DGS_Batman,256+300,256+80

	WAIT	$9c0
	START_C	R_Rapide
	PAR	Anim_Speedy
	PAR     8
	PAR_L	Dummy_Pal
                  PAR	256+140
	PAR_END

	IFNE	ASM_Demo_Mode=2	* DEMO PAGE
	WAIT	$9d0
	START_C	Demo_Page
	PAR     1
	PAR	150
                  PAR_END
	ENDC

	WAIT	$a40
	START_C	R_Rapide
	PAR	Anim_Speedy
	PAR     10
	PAR_L	Dummy_Pal
                  PAR	256+176
	PAR_END

	WAIT	$a50
	START_C	R_Rapide
	PAR	Anim_Speedy
	PAR     8
	PAR_L	Dummy_Pal
                  PAR	256+100
	PAR_END

	WAIT	$a60
	START_C	R_Rapide
	PAR	Anim_Speedy
	PAR     10
	PAR_L	Dummy_Pal
                  PAR	256+40
	PAR_END

	WAIT	$a70
	START_C	R_Rapide
	PAR	Anim_Speedy
	PAR     8
	PAR_L	Dummy_Pal
                  PAR	256+140
	PAR_END

	WAIT	$a80
	START_C	R_Rapide
	PAR	Anim_Speedy
	PAR     10
	PAR_L	Dummy_Pal
                  PAR	256+80
	PAR_END

	WAIT	$a90
	START_C	R_Rapide
	PAR	Anim_Speedy
	PAR     8
	PAR_L	Dummy_Pal
                  PAR	256+180
	PAR_END

	WAIT	$aa0
	START_C	R_Rapide
	PAR	Anim_Speedy
	PAR     10
	PAR_L	Dummy_Pal
                  PAR	256+20
	PAR_END

	WAIT	$ab0
	START_C	R_Rapide
	PAR	Anim_Speedy
	PAR     8
	PAR_L	Dummy_Pal
                  PAR	256+100
	PAR_END

	WAIT	$ac0
	START_C	R_Rapide
	PAR	Anim_Speedy
	PAR     10
	PAR_L	Dummy_Pal
                  PAR	256+80
	PAR_END

	WAIT	$b80
	START_A DGDP_Full_7c_2,256+300,256+40

	IFNE	ASM_Demo_Mode=2	* DEMO PAGE
	WAIT	$bb8
	START_C	Demo_Page
	PAR     2
	PAR	150
                  PAR_END
	ENDC

	WAIT	$bc0
	START_C	R_Rapide
	PAR	Anim_Speedy
	PAR     10
	PAR_L	Dummy_Pal
                  PAR	256+176
	PAR_END

	WAIT	$c70
	START_C	R_Sol_Etoile
	PAR     150+256
	PAR_END

	WAIT	$c80
	START_C	R_Rapide
	PAR	Anim_Speedy
	PAR     8
	PAR_L	Dummy_Pal
                  PAR	256+140
	PAR_END

	WAIT	$c90
	START_A DGDP_Bestiolle_3,256+300,256

	WAIT	$cf0
	START_A DGDP_Bestiolle_1,256+300,256

                  WAIT	$d00
	START_C	R_Araignee
	PAR     50
	PAR     3
	PAR_END

	WAIT	$d20
	START_A DGMP_Bestiolle,256+200,256+200

	WAIT	$d60
	START_C	R_Spectre	* Guided Spectre, Ground Start
	PAR	200+256	* Sp. Launch X
	PAR	25	* Sp. Fire Rate
	PAR	3	* X Speed
	PAR	2	* Y Speed
                  PAR_END

	IFNE	ASM_Demo_Mode=2	* DEMO PAGE
	WAIT	$dac
	START_C	Demo_Page
	PAR     3
	PAR	150
                  PAR_END
	ENDC

	WAIT	$e00
	START_A DGMP_Bestiolle_2,256+250,256+200

	WAIT	$e40
	START_C	R_Tir_Etoile
	PAR     200+256
	PAR	80+256
	PAR_END

	WAIT	$e00
	START_A DGS_Bestiolle,256+300,256+100

	WAIT	$ec0
	START_A DGDP_Feuillage_7c,256+300,256

                  WAIT	$f60
	START_C	R_Araignee
	PAR     50
	PAR     1
	PAR_END

	WAIT	$1180
	START_A DGDP_Feuillage_7c,256+300,256

	WAIT	$11a0
	START_A DGMP_Bestiolle,256+180,256+200

	WAIT	$11c0
	START_A DGMP_Bestiolle,256+240,256+200

	WAIT	$1200
	START_C	R_Volant_missile
	PAR_END

	WAIT	$1280
	START_A DGDP_Bestiolle_4,256+150,230

	WAIT	$12c0
	START_C	R_Kamikaze
	PAR	25*7
	PAR	2
	PAR	2
	PAR_END

	WAIT	$12d0
	START_C	R_Kamikaze
	PAR	25*7
	PAR     1
	PAR     1
	PAR_END

	IFNE	ASM_Demo_Mode=2	* DEMO PAGE
	WAIT	$12f0
	START_C	Demo_Page
	PAR     4
	PAR	150
                  PAR_END
	ENDC

	WAIT	$1300
	START_A DGDP_Bestiolle_3,256+300,230

	WAIT	$13c0
	START_C	R_Tir_Etoile
	PAR     210+256
	PAR	80+256
	PAR_END

	WAIT	$1400
	START_A DGS_Bestiolle,256+300,256+100

	IFNE	ASM_Demo_Mode=2	* DEMO PAGE
	WAIT	$14e6
	START_C	Demo_Page
	PAR     5
	PAR	150
                  PAR_END
	ENDC

	WAIT	$1500
	START_A DGDP_Feuillage_7c,256+300,256

	WAIT	$1540
	START_C	R_Volant_missile
	PAR_END

                  WAIT	$1680
	START_C	R_Araignee
	PAR     50
	PAR     3
	PAR_END

	IFNE	ASM_Demo_Mode=2	* DEMO PAGE
	WAIT	$16da
	START_C	Demo_Page
	PAR     6
	PAR	150
                  PAR_END
	ENDC

                  WAIT	$1700
	START_C	R_Araignee
	PAR     100
	PAR     1
	PAR_END

                  WAIT	$1780
	START_C	R_Araignee
	PAR     50
	PAR     2
	PAR_END

	WAIT	$17a0
	START_C	R_Spectre	* Guided Spectre, Ground Start
	PAR	200+256	* Sp. Launch X
	PAR	25	* Sp. Fire Rate
	PAR	2	* X Speed
	PAR	2	* Y Speed
                  PAR_END

	WAIT	$17c0
	START_C	R_Spectre	* Guided Spectre, Ground Start
	PAR	200+256	* Sp. Launch X
	PAR	25	* Sp. Fire Rate
	PAR	3	* X Speed
	PAR	2	* Y Speed
                  PAR_END

	WAIT	$17e0
	START_C	R_Spectre	* Guided Spectre, Ground Start
	PAR	200+256	* Sp. Launch X
	PAR	25	* Sp. Fire Rate
	PAR	3	* X Speed
	PAR	3	* Y Speed
                  PAR_END

                  WAIT	$1800
	START_C	R_Araignee
	PAR     20
	PAR     3
	PAR_END

	WAIT	$1840
	START_C	R_Sol_Etoile
	PAR     150+256
	PAR_END

	WAIT	$1880
	START_C	R_Kamikaze
	PAR	25*7
	PAR     2
	PAR     2
	PAR_END

	WAIT	$18c0
	START_C	R_Sol_Etoile
	PAR     130+256
	PAR_END

	IFNE	ASM_Demo_Mode=2	* DEMO PAGE
	WAIT	$18ce
	START_C	Demo_Page
	PAR     7
	PAR	150
                  PAR_END
	ENDC

	WAIT	$1980
	START_A DGDP_Bestiolle_2,256+300,256

	WAIT	$19c0
	START_A DGDP_Bestiolle_2,256+300,256+40

	WAIT	$1a00
	START_A DGDP_Bestiolle_2,256+300,256+80

	WAIT	$1a40
	START_C	R_Rapide
	PAR	Anim_Speedy
	PAR     8
	PAR_L	Dummy_Pal
                  PAR	256+40
	PAR_END

	WAIT	$1a50
	START_C	R_Rapide
	PAR	Anim_Speedy
	PAR     10
	PAR_L	Dummy_Pal
                  PAR	256+20
	PAR_END

	WAIT	$1a60
	START_C	R_Rapide
	PAR	Anim_Speedy
	PAR     12
	PAR_L	Dummy_Pal
                  PAR	256+140
	PAR_END

	WAIT	$1a70
	START_C	R_Rapide
	PAR	Anim_Speedy
	PAR     14
	PAR_L	Dummy_Pal
                  PAR	256+80
	PAR_END

	WAIT	$1a80
	START_C	R_Rapide
	PAR	Anim_Speedy
	PAR     8
	PAR_L	Dummy_Pal
                  PAR	256+170
	PAR_END

	WAIT	$1a85
	START_A DGDP_Bestiolle_4,256+150,230

	WAIT	$1a90
	START_C	R_Rapide
	PAR	Anim_Speedy
	PAR     10
	PAR_L	Dummy_Pal
                  PAR	256+50
	PAR_END

	WAIT	$1aa0
	START_C	R_Rapide
	PAR	Anim_Speedy
	PAR     12
	PAR_L	Dummy_Pal
                  PAR	256+140
	PAR_END

	WAIT	$1ab0
	START_C	R_Rapide
	PAR	Anim_Speedy
	PAR     14
	PAR_L	Dummy_Pal
                  PAR	256+150
	PAR_END

	WAIT	$1ac0
	START_C	R_Rapide
	PAR	Anim_Speedy
	PAR     8
	PAR_L	Dummy_Pal
                  PAR	256+70
	PAR_END

	WAIT	$1ad0
	START_C	R_Rapide
	PAR	Anim_Speedy
	PAR     10
	PAR_L	Dummy_Pal
                  PAR	256+30
	PAR_END

	WAIT	$1ae0
	START_C	R_Rapide
	PAR	Anim_Speedy
	PAR     12
	PAR_L	Dummy_Pal
                  PAR	256+130
	PAR_END

	WAIT	$1af0
	START_C	R_Rapide
	PAR	Anim_Speedy
	PAR     14
	PAR_L	Dummy_Pal
                  PAR	256+140
	PAR_END

	WAIT	$1b00
	START_C	R_Rapide
	PAR	Anim_Speedy
	PAR     8
	PAR_L	Dummy_Pal
                  PAR	256+20
	PAR_END

	WAIT	$1b10
	START_C	R_Rapide
	PAR	Anim_Speedy
	PAR     10
	PAR_L	Dummy_Pal
                  PAR	256+120
	PAR_END

	WAIT	$1b20
	START_C	R_Rapide
	PAR	Anim_Speedy
	PAR     12
	PAR_L	Dummy_Pal
                  PAR	256+80
	PAR_END

	WAIT	$1b30
	START_C	R_Rapide
	PAR	Anim_Speedy
	PAR     14
	PAR_L	Dummy_Pal
                  PAR	256+180
	PAR_END

	WAIT	$1b40
	START_C	R_Rapide
	PAR	Anim_Speedy
	PAR     8
	PAR_L	Dummy_Pal
                  PAR	256+60
	PAR_END

	WAIT	$1b50
	START_C	R_Rapide
	PAR	Anim_Speedy
	PAR     10
	PAR_L	Dummy_Pal
                  PAR	256+160
	PAR_END

	WAIT	$1b60
	START_C	R_Rapide
	PAR	Anim_Speedy
	PAR     12
	PAR_L	Dummy_Pal
                  PAR	256+50
	PAR_END

	WAIT	$1b70
	START_C	R_Rapide
	PAR	Anim_Speedy
	PAR     14
	PAR_L	Dummy_Pal
                  PAR	256+100
	PAR_END

	WAIT	$1b80
	START_C	R_Rapide
	PAR	Anim_Speedy
	PAR     8
	PAR_L	Dummy_Pal
                  PAR	256+110
	PAR_END


                  WAIT	$1c00
	START_C	R_Araignee
	PAR     50
	PAR     3
	PAR_END

	WAIT	$1c80
	START_C	R_Tir_Etoile
	PAR     200+256
	PAR	60+256
	PAR_END

	WAIT	$1c90
	START_C	R_Tir_Etoile
	PAR     220+256
	PAR	100+256
	PAR_END

	WAIT	$1d60
	START_C	R_Spectre	* Guided Spectre, Ground Start
	PAR	200+256	* Sp. Launch X
	PAR	25	* Sp. Fire Rate
	PAR	2	* X Speed
	PAR	2	* Y Speed
                  PAR_END

	WAIT	$1d90
	START_C	R_Spectre	* Guided Spectre, Ground Start
	PAR	200+256	* Sp. Launch X
	PAR	25	* Sp. Fire Rate
	PAR	3	* X Speed
	PAR	2	* Y Speed
                  PAR_END

	WAIT	$1dc0
	START_C	R_Spectre	* Guided Spectre, Ground Start
	PAR	200+256	* Sp. Launch X
	PAR	25	* Sp. Fire Rate
	PAR	3	* X Speed
	PAR	3	* Y Speed
                  PAR_END

	WAIT	$1e00
	START_A DGDP_Feuillage_7c,256+300,240

	WAIT	$1e10
	START_C	R_Rapide
	PAR	Anim_Speedy
	PAR     10
	PAR_L	Dummy_Pal
                  PAR	256+80
	PAR_END

	WAIT	$1e30
	START_C	R_Rapide
	PAR	Anim_Speedy
	PAR     8
	PAR_L	Dummy_Pal
                  PAR	256+100
	PAR_END

	WAIT	$1e80
	START_A DGDP_Feuillage_7c,256+300,256

	WAIT	$1ec0
	START_A DGDP_Bestiolle_3,256+300,256

	WAIT	$1f00
	START_A DGDP_Feuillage_7c,256+250,230

	WAIT	$1f80
	START_A DGDP_Feuillage_7c,256+300,256

	WAIT	$20c0
	START_A DGDP_Full_7c,256+240,200

	WAIT	$20e0
	START_A DGMP_Bestiolle_2,256+220,256+200

	IFNE	ASM_Demo_Mode=2	* DEMO PAGE
	WAIT	$2280
	START_C	Demo_Page
	PAR     8
	PAR	150
                  PAR_END
	ENDC

	WAIT	$22f0
                  START_C	R_Final
	PAR_END

	SL_END



* RELATIVE TRACKS START STRUCT
* ----------------------------


;	INCLUDE	Game/lforet_Rtr.s



* ABSOLUTE TRACKS START STRUCT
* ----------------------------


DGDP_Full_7c
	DC.W	TX_DG_Descend_Plat_4 * AWS_Table_X_Off
	DC.W	TY_DG_Descend_Plat_4 * AWS_Table_Y_Off
	DC.W	Anim_FireBall	* AWS_Table_Obj_Off
	DC.B	40	* AWS_Alien_Rate
	DC.B	2	* AWS_Alien_Num
	DC.W	1	* AWS_Alien_Energy
	DC.B	20	* AWS_Alien_Bad_F
	DC.B	2	* AWS_Alien_F_Rate
	DC.B	1	* AWS_Pal_Mod_Lin0
	DC.B	1	* AWS_Pal_Mod_Lin1
	DC.B	1	* AWS_Pal_Mod_Lin2
	DC.B	1	* AWS_Pal_Mod_Lin3
	DC.B	-1	* AWS_Pal_Mod_Lin4
	DC.B	-1	* AWS_Pal_Mod_Lin5
	DC.W	$ffc	* AWS_Pal_Mod_Col1
	DC.W	$ddf	* AWS_Pal_Mod_Col2
	DC.W	$bbf	* AWS_Pal_Mod_Col3
	DC.W	$99f	* AWS_Pal_Mod_Col7
	DC.W	$77f	* AWS_Pal_Mod_Col5
	DC.W	$55f	* AWS_Pal_Mod_Col4
	DC.W	$33f	* AWS_Pal_Mod_Col6

DGDP_Full_7c_2
	DC.W	TX_DG_Descend_Plat_6 * AWS_Table_X_Off
	DC.W	TY_DG_Descend_Plat_6 * AWS_Table_Y_Off
	DC.W	Anim_FireBall	* AWS_Table_Obj_Off
	DC.B	40	* AWS_Alien_Rate
	DC.B	2	* AWS_Alien_Num
	DC.W	1	* AWS_Alien_Energy
	DC.B	10	* AWS_Alien_Bad_F
	DC.B	2	* AWS_Alien_F_Rate
	DC.B	1	* AWS_Pal_Mod_Lin0
	DC.B	1	* AWS_Pal_Mod_Lin1
	DC.B	1	* AWS_Pal_Mod_Lin2
	DC.B	1	* AWS_Pal_Mod_Lin3
	DC.B	-1	* AWS_Pal_Mod_Lin4
	DC.B	-1	* AWS_Pal_Mod_Lin5
	DC.W	$ffc	* AWS_Pal_Mod_Col1
	DC.W	$ddf	* AWS_Pal_Mod_Col2
	DC.W	$bbf	* AWS_Pal_Mod_Col3
	DC.W	$99f	* AWS_Pal_Mod_Col7
	DC.W	$77f	* AWS_Pal_Mod_Col5
	DC.W	$55f	* AWS_Pal_Mod_Col4
	DC.W	$33f	* AWS_Pal_Mod_Col6

DGDP_Batman_1
	DC.W	TX_DG_Descend_Plat_4 * AWS_Table_X_Off
	DC.W	TY_DG_Descend_Plat_4 * AWS_Table_Y_Off
	DC.W	Anim_Batman	* AWS_Table_Obj_Off
	DC.B	40	* AWS_Alien_Rate
	DC.B	3	* AWS_Alien_Num
	DC.W	4	* AWS_Alien_Energy
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

DGS_Batman
	DC.W	TX_DG_Sin_1	* AWS_Table_X_Off
	DC.W	TY_DG_Sin_1	* AWS_Table_Y_Off
	DC.W	Anim_Batman	* AWS_Table_Obj_Off
	DC.B	40	* AWS_Alien_Rate
	DC.B	3	* AWS_Alien_Num
	DC.W	4	* AWS_Alien_Energy
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

DGDP_Feuillage_7c
	DC.W	TX_DG_Descend_Plat_3 * AWS_Table_X_Off
	DC.W	TY_DG_Descend_Plat_3 * AWS_Table_Y_Off
	DC.W	Anim_Feuillage	* AWS_Table_Obj_Off
	DC.B	60	* AWS_Alien_Rate
	DC.B	2	* AWS_Alien_Num
	DC.W	10	* AWS_Alien_Energy
	DC.B	20	* AWS_Alien_Bad_F
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
	DC.W	-1	* AWS_Pal_Mod_Col4
	DC.W	-1	* AWS_Pal_Mod_Col5
	DC.W	-1	* AWS_Pal_Mod_Col6
	DC.W	-1	* AWS_Pal_Mod_Col7

DGDP_Bestiolle_1
	DC.W	TX_DG_Descend_Plat_1 * AWS_Table_X_Off
	DC.W	TY_DG_Descend_Plat_1 * AWS_Table_Y_Off
	DC.W	Anim_Dessus_1	* AWS_Table_Obj_Off
	DC.B	50	* AWS_Alien_Rate
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

DGDP_Bestiolle_2
	DC.W	TX_DG_Descend_Plat_2 * AWS_Table_X_Off
	DC.W	TY_DG_Descend_Plat_2 * AWS_Table_Y_Off
	DC.W	Anim_Dessus_2	* AWS_Table_Obj_Off
	DC.B	30	* AWS_Alien_Rate
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
	DC.W	-1	* AWS_Pal_Mod_Col7
	DC.W	-1	* AWS_Pal_Mod_Col5
	DC.W	-1	* AWS_Pal_Mod_Col4
	DC.W	-1	* AWS_Pal_Mod_Col6

DGDP_Bestiolle_3
	DC.W	TX_DG_Descend_Plat_4 * AWS_Table_X_Off
	DC.W	TY_DG_Descend_Plat_4 * AWS_Table_Y_Off
	DC.W	Anim_All	* AWS_Table_Obj_Off
	DC.B	30	* AWS_Alien_Rate
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

DGDP_Bestiolle_4
	DC.W	TX_DG_Descend_Plat_8 * AWS_Table_X_Off
	DC.W	TY_DG_Descend_Plat_8 * AWS_Table_Y_Off
	DC.W	Anim_All	* AWS_Table_Obj_Off
	DC.B	30	* AWS_Alien_Rate
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

DGDP_Bestiolle_5
	DC.W	TX_DG_Descend_Plat_8 * AWS_Table_X_Off
	DC.W	TY_DG_Descend_Plat_8 * AWS_Table_Y_Off
	DC.W	Anim_Dessus_2	* AWS_Table_Obj_Off
	DC.B	30	* AWS_Alien_Rate
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

DGMP_Bestiolle
	DC.W	TX_DG_Monte_Plat_5	* AWS_Table_X_Off
	DC.W	TY_DG_Monte_Plat_5	* AWS_Table_Y_Off
	DC.W	Anim_All	* AWS_Table_Obj_Off
	DC.B	10	* AWS_Alien_Rate
	DC.B	6	* AWS_Alien_Num
	DC.W	1	* AWS_Alien_Energy
	DC.B	10	* AWS_Alien_Bad_F
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

DGMP_Bestiolle_2
	DC.W	TX_DG_Monte_Plat_2	* AWS_Table_X_Off
	DC.W	TY_DG_Monte_Plat_2	* AWS_Table_Y_Off
	DC.W	Anim_Dessus_2	* AWS_Table_Obj_Off
	DC.B	20	* AWS_Alien_Rate
	DC.B	4	* AWS_Alien_Num
	DC.W	1	* AWS_Alien_Energy
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
	DC.W	-1	* AWS_Pal_Mod_Col7
	DC.W	-1	* AWS_Pal_Mod_Col5
	DC.W	-1	* AWS_Pal_Mod_Col4
	DC.W	-1	* AWS_Pal_Mod_Col6

DGS_Bestiolle
	DC.W	TX_DG_Sin_2	* AWS_Table_X_Off
	DC.W	TY_DG_Sin_2	* AWS_Table_Y_Off
	DC.W	Anim_Dessus_1	* AWS_Table_Obj_Off
	DC.B	50	* AWS_Alien_Rate
	DC.B	8	* AWS_Alien_Num
	DC.W	3	* AWS_Alien_Energy
	DC.B	25	* AWS_Alien_Bad_F
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



* ANIMATION TABLE
* ---------------


__	MACRO
\1	EQU     *-Anim_Base
	ENDM

Anim_Base


 __ Anim_Feuillage
	DC.W	Obj_Feuillage_1
	DC.W	Obj_Feuillage_2
	DC.w	-1

 __ Anim_FireBall
	DC.W	Obj_FireBall_1
	DC.W	Obj_FireBall_2
	DC.W	Obj_FireBall_3
	DC.W	Obj_FireBall_4
	DC.W	Obj_FireBall_5
	DC.W	Obj_FireBall_6
	DC.W	-1

 __ Anim_Speedy
	DC.W	Obj_Speedy
                  DC.W	-1

 __ Anim_Batman
	DC.W	Obj_Batman_1
	DC.W	Obj_Batman_2
	DC.W	Obj_Batman_3
	DC.W	Obj_Batman_4
	DC.W	Obj_Batman_5
	DC.W	Obj_Batman_6
	DC.W	Obj_Batman_7
	DC.W	Obj_Batman_8
	DC.W	Obj_Batman_7
	DC.W	Obj_Batman_6
	DC.W	Obj_Batman_5
	DC.W	Obj_Batman_4
	DC.W	Obj_Batman_3
	DC.W	Obj_Batman_2
	DC.W	-1

 __ Anim_Dessus_1
	DC.W	Obj_Dessus_1
	DC.W	-1

 __ Anim_Dessus_2
	DC.W	Obj_Dessus_2
	DC.W	-1

 __ Anim_All
	DC.W	Obj_All
	DC.W	-1


 __ Anim_Boomerang
	DC.W	Obj_Boomerang_1
	DC.W	Obj_Boomerang_2
	DC.W	Obj_Boomerang_3
	DC.W	Obj_Boomerang_4
	DC.W	Obj_Boomerang_5
	DC.W	Obj_Boomerang_6
	DC.W	Obj_Boomerang_7
	DC.W	Obj_Boomernag_8	* !?!
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

R_VM_Pal
	DC.B	1	* Mod_Lin0
	DC.B	1	* Mod_Lin1
	DC.B	1	* Mod_Lin2
	DC.B	1	* Mod_Lin3
	DC.B	1	* Mod_Lin4
	DC.B	1	* Mod_Lin5
	DC.W	$0da7	* Mod_Col1
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
;	move.l	#R_VM_Pal,Rout_Pal_Ptr(D)	* MODE 0
;                  st	Refresh_Pal+1(D)
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
	subq	#1,AWO_Alien_X(a4)
	move	#Obj_Tir_7,Awo_Alien_Obj_Off(a4)
	move	AWO_Alien_X(a4),d1
	cmp	R_VM_Target_X(a3),d1
	bgt	.no_fire
	bra	.tacke_desision_fy
.fmode1				* up
	subq	#1,AWO_Alien_Y(a4)
	move	#Obj_Tir_1,Awo_Alien_Obj_Off(a4)
	move	AWO_Alien_Y(a4),d1
	cmp	R_VM_Target_Y(a3),d1
	bgt	.no_fire
	bra	.tacke_desision_fx
.fmode2				* right
	addq	#1,AWO_Alien_X(a4)
	move	#Obj_Tir_3,Awo_Alien_Obj_Off(a4)
	move	AWO_Alien_X(a4),d1
	cmp	R_VM_Target_X(a3),d1
	blt	.no_fire
	bra	.tacke_desision_fy
.fmode3				* down
	addq	#1,AWO_Alien_Y(a4)
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



* ARAIGNEE DESCEND DE SON FIL
* ---------------------------


	RSRESET
R_A_Mode	RS.W    1
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
	addq	#1,Rout_Mod_Pal_Counter(D)
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
	subq	#1,Rout_Mod_Pal_Counter(D)
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



* MONSTRE FINAL
* -------------


	RSRESET
R_F_Mode	RS.W	1
R_F_Step	RS.W	1
R_F_Explo_Step	RS.W	1
R_F_X_Mode	RS.W	1
R_F_Anim_Delay	RS.W	1
R_F_Anim_Up_Step	RS.W	1
R_F_Launch_Delay	RS.W	1

R_T_Final_1
	DC.W	TX_Final_1	* AWS_Table_X_Off
	DC.W	TY_Final_1	* AWS_Table_Y_Off
	DC.W	Anim_Boomerang	* AWS_Table_Obj_Off
	DC.B	10	* AWS_Alien_Rate
	DC.B	2	* AWS_Alien_Num
	DC.W	3	* AWS_Alien_Energy
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
	DC.W	Anim_Boomerang	* AWS_Table_Obj_Off
	DC.B	10	* AWS_Alien_Rate
	DC.B	2	* AWS_Alien_Num
	DC.W	3	* AWS_Alien_Energy
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
	DC.W	Anim_Boomerang	* AWS_Table_Obj_Off
	DC.B	10	* AWS_Alien_Rate
	DC.B	2	* AWS_Alien_Num
	DC.W	3	* AWS_Alien_Energy
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

R_T_Final_4
	DC.W	TX_Final_4	* AWS_Table_X_Off
	DC.W	TY_Final_4	* AWS_Table_Y_Off
	DC.W	Anim_Boomerang	* AWS_Table_Obj_Off
	DC.B	10	* AWS_Alien_Rate
	DC.B	2	* AWS_Alien_Num
	DC.W	3	* AWS_Alien_Energy
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

R_T_Final_5
	DC.W	TX_Final_5	* AWS_Table_X_Off
	DC.W	TY_Final_5	* AWS_Table_Y_Off
	DC.W	Anim_Boomerang	* AWS_Table_Obj_Off
	DC.B	10	* AWS_Alien_Rate
	DC.B	2	* AWS_Alien_Num
	DC.W	3	* AWS_Alien_Energy
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

R_T_Final_6
	DC.W	TX_Final_6	* AWS_Table_X_Off
	DC.W	TY_Final_6	* AWS_Table_Y_Off
	DC.W	Anim_Boomerang	* AWS_Table_Obj_Off
	DC.B	10	* AWS_Alien_Rate
	DC.B	2	* AWS_Alien_Num
	DC.W	3	* AWS_Alien_Energy
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

R_T_Table
	DC.L	R_T_Final_1
	DC.L	R_T_Final_2
	DC.L	R_T_Final_3
	DC.L	R_T_Final_4
	DC.L	R_T_Final_5
	DC.L	R_T_Final_6
R_F_Anim_Up
	DC.W	Obj_Final_1
	DC.W	Obj_Final_1
	DC.W	Obj_Final_1
	DC.W	Obj_Final_1
	DC.W	Obj_Final_2
	DC.W	Obj_Final_2
	DC.W	Obj_Final_3
	DC.W	Obj_Final_3

R_Final
	move.l	Rout_Param_Ptr(a0),a1
	move.l	Rout_Awo_Ptr(a0),a2
	lea	Rout_Variables(a0),a3

	move	R_F_Mode(a3),d1
	bne	.no_init
	move.l	#$00020000,(a2)+
	lea	Awo_Len(a2),a4
	move	#256+350,AWO_Alien_X(a2)
	move	#256+130,AWO_Alien_Y(a2)
	move	#256+350,AWO_Alien_X(a4)
	move	#256+130,AWO_Alien_Y(a4)
	move	#Obj_Final_1,Awo_Alien_Obj_Off(a2)
	move	#Obj_Final_Bas_1,Awo_Alien_Obj_Off(a4)
	move	#150,AWO_Alien_Energy(a2)
	move	#20000,AWO_Alien_Energy(a4)
	clr.l	Awo_Alien_Status(a2)
	clr.l	Awo_Alien_Status(a4)
	move.b	#30,AWO_Alien_F_RT_S(a2)
	move.b	#255,AWO_Alien_F_RT_S(a4)
	clr	Rout_Mod_Pal_Counter(D)
	clr	R_F_X_Mode(a3)
	addq	#1,R_F_Mode(a3)
	bra	R_end
.no_init
	move.l	#$00020000,(a2)+
	lea	AWO_Len(a2),a4
	cmp	#2,d1
	beq	.Explo
	tst	R_F_X_Mode(a3)
	beq	.dec
	addq	#2,AWO_Alien_X(a2)
	addq	#2,AWO_Alien_X(a4)
	move	AWO_Alien_X(a2),d1
	cmp	#256+260,d1
                  blt	.cont4
                  addq	#1,R_F_X_Mode(a3)
	bra	.cont4
.dec
	subq	#2,AWO_Alien_X(a2)
	subq	#2,AWO_Alien_X(a4)
	move	AWO_Alien_X(a2),d1
	cmp	#256+160,d1
                  bgt	.cont4
                  subq	#1,R_F_X_Mode(a3)
.cont4
	addq	#1,R_F_Anim_Delay(a3)
	btst	#3,R_F_Anim_Delay+1(a3)
	beq	.next
	move	#Obj_Final_Bas_1,Awo_Alien_Obj_Off(a4)
	bra	.next2
.next
	move	#Obj_Final_Bas_2,Awo_Alien_Obj_Off(a4)
.next2
	addq	#1,R_F_Anim_Up_Step(a3)
	and	#7,R_F_Anim_Up_Step(a3)
	move	R_F_Anim_Up_Step(a3),d1
	add	d1,d1
	lea	R_F_Anim_Up,a1
	move	(a1,d1.w),AWO_Alien_Obj_Off(a2)

                  move.b	AWO_Alien_Status(a2),d1	* EXPLO
	and	#$f,d1
	beq     .cont5
                  clr	R_F_Explo_Step(a3)
	addq	#1,R_F_Mode(a3)
.explo
                  addq	#1,R_F_Explo_Step(a3)
                  move	R_F_Explo_Step(a3),d1
	cmp	#1,d1
	bne	.cont2
	move	#Obj_Big_Explo_1,Awo_Alien_Obj_Off(a2)
	move	#Obj_Big_Explo_1,Awo_Alien_Obj_Off(a4)
	clr.l	Awo_Alien_Status(a2)
	move.b	#1,Awo_Alien_Status(a2)
	clr.l	Awo_Alien_Status(a4)
	move.b	#1,Awo_Alien_Status(a4)
	bra	R_End
.cont2
	cmp	#21,d1
	bne	.cont7
	move	#Obj_Big_Explo_1,Awo_Alien_Obj_Off(a2)
	clr.l	Awo_Alien_Status(a2)
	move.b	#1,Awo_Alien_Status(a2)
                  move	#1,Short_Phase(D)
	move	#1,Sound0_Req(D)
	move    #63,Sound0_Vol_Req(D)
	jsr	Sound_Start
	bra	R_End
.cont7
	cmp	#35,d1
	bne	.cont8
	move	#Obj_Big_Explo_2,Awo_Alien_Obj_Off(a2)
	move	#Obj_Big_Explo_2,Awo_Alien_Obj_Off(a4)
	clr.l	Awo_Alien_Status(a2)
	move.b	#1,Awo_Alien_Status(a2)
	clr.l	Awo_Alien_Status(a4)
	move.b	#1,Awo_Alien_Status(a4)
	move	#1,Sound0_Req(D)
	move    #63,Sound0_Vol_Req(D)
	jsr	Sound_Start
	bra	R_End
.cont8
	cmp	#52,d1
	bne     R_End
	move	#Obj_Big_Explo_3,Awo_Alien_Obj_Off(a2)
	move	#Obj_Big_Explo_3,Awo_Alien_Obj_Off(a4)
	clr.l	Awo_Alien_Status(a2)
	move.b	#1,Awo_Alien_Status(a2)
	clr.l	Awo_Alien_Status(a4)
	move.b	#1,Awo_Alien_Status(a4)
	move	#1,Sound0_Req(D)
	move    #63,Sound0_Vol_Req(D)
	jsr	Sound_Start
	move	#25,Quit_Delay(D)
	st	Clean_Up(D)
	bra	R_End
.cont5
                  addq	#1,R_F_Launch_Delay(a3)
	cmp	#18,R_F_Launch_Delay(a3)
	bne     R_End
	clr	R_F_Launch_Delay(a3)
	addq	#1,R_F_Step(a3)
	cmp	#6,R_F_Step(a3)
	bne	.cont6
	clr	R_F_Step(a3)
.cont6
	move	R_F_Step(a3),d0
	add	d0,d0
	add	d0,d0
	lea	R_T_Table,a1
	move.l	(a1,d0.w),d0
	or.l	#$40000000,d0
	move	AWO_Alien_X(a2),d1
	move	AWO_Alien_Y(a2),d2
	sub	#20,d1
	sub	#20,d2

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
;	RINCBIN	Game/lforet.rtb
Absolute_Tracks
	RINCBIN	Game/lforet.atb
Sin_Table1
	RINCBIN	Game/Sin_Table1.bin
Sin_Table2
	RINCBIN	Game/Sin_Table2.bin
Sin_Table3
	RINCBIN	Game/Sin_Table3.bin




