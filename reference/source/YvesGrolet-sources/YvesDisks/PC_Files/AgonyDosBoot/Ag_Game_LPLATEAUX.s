
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
*                           P L A T E A U X                               *
*                           ---------------                               *
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
	START_A	DGDP_Full_7c,320+256,256

	WAIT	$20
	START_C	R_Rapide
	PAR	Anim_Accordeon
	PAR     4
	PAR_L   Dummy_Pal
                  PAR	256+135
	PAR_END

                  WAIT	$30
	START_A	Saut_Diable,256+280,256+220

	WAIT	$40
	START_C	R_Rapide
	PAR	Anim_Accordeon
	PAR     3
	PAR_L   Dummy_Pal
                  PAR	256+120
	PAR_END

	WAIT	$60
	START_C	R_Rapide
	PAR	Anim_Accordeon
	PAR     3
	PAR_L   Dummy_Pal
                  PAR	256+150
	PAR_END

                  WAIT	$70
	START_A	Saut_Diable,256+250,256+220

                  WAIT	$c0
	START_A	Saut_Diable,256+250,256+220

	WAIT	$100
	START_C R_Sol_Crache
	PAR     45
	PAR_END

                  WAIT	$120
	START_A	DGDP_Diable_1,256+300,256

	WAIT	$140
	START_C	R_Sol_Kamikaze
	PAR_END

                  WAIT	$160
	START_A	DGDP_Diable_1,256+300,256+60

	WAIT	$180
	START_C R_Sol_Crache
	PAR     30
	PAR_END

                  WAIT	$1a0
	START_A	DGDP_Diable_1,256+300,256+130

	WAIT	$1c0
	START_C	R_Sol_Kamikaze
	PAR_END

	WAIT	$290
	START_C	R_Dragon
	PAR	256+60
	PAR_END

                  WAIT	$298
	START_A	DGDP_Squelette_1,256+250,220

	WAIT	$2a0
	START_C	R_Spectre	* Guided Spectre, Ground Start
	PAR	180+256	* Sp. Launch X
	PAR	25	* Sp. Fire Rate
	PAR	2	* X Speed
	PAR	1	* Y Speed
                  PAR_END

                  WAIT	$300
	START_A	DGMP_Squelette_1,256+220,256+220

	WAIT	$320
	START_C	R_Spectre	* Guided Spectre, Ground Start
	PAR	180+256	* Sp. Launch X
	PAR	25	* Sp. Fire Rate
	PAR	2	* X Speed
	PAR	3	* Y Speed
                  PAR_END

                  WAIT	$360
	START_A	DGDP_Squelette_1,256+190,220

	WAIT	$39e
	START_C	R_Spectre	* Guided Spectre, Ground Start
	PAR	180+256	* Sp. Launch X
	PAR	25	* Sp. Fire Rate
	PAR	3	* X Speed
	PAR	3	* Y Speed
                  PAR_END

	WAIT	$3a0
	START_C	R_Dragon
	PAR	256+60
	PAR_END

                  WAIT	$3b0
	START_A	DGMP_Squelette_1,256+160,256+220

	WAIT	$400
	START_C R_Sol_Crache
	PAR     45
	PAR_END

                  WAIT	$420
	START_A	DGDP_Squelette_1,256+180,220

	WAIT	$440
	START_C	R_Sol_Kamikaze
	PAR_END

                  WAIT	$460
	START_A	DGMP_Squelette_1,256+150,256+220

	WAIT	$480
	START_C R_Sol_Crache
	PAR     30
	PAR_END

                  WAIT	$460
	START_A	DGDP_Squelette_1,256+130,220

	WAIT	$4c0
	START_C	R_Sol_Kamikaze
	PAR_END

                  WAIT	$540
	START_A	DGDP_Full_7c,320+256,256

                  WAIT	$560
	START_A	DG_Sin_Diable,256+300,256+170

	WAIT	$5b0
	START_C	R_Rapide
	PAR	Anim_Accordeon
	PAR     5
	PAR_L   Dummy_Pal
                  PAR	256+150
	PAR_END

	WAIT	$640
	START_C	R_Sol_Guide
	PAR	256+200
	PAR_END

	WAIT    $660
	START_C	R_Rapide
	PAR	Anim_Accordeon
	PAR     4
	PAR_L   Dummy_Pal
                  PAR	256+150
	PAR_END

	WAIT	$680
	START_C	R_Sol_Guide
	PAR	256+200
	PAR_END

	WAIT	$690
	START_C	R_Rapide
	PAR	Anim_Accordeon
	PAR     6
	PAR_L   Dummy_Pal
                  PAR	256+20
	PAR_END

	WAIT	$698
	START_C	R_Rapide
	PAR	Anim_Accordeon
	PAR     6
	PAR_L   Dummy_Pal
                  PAR	256+60
	PAR_END

	WAIT	$6a0
                  START_C	R_Volant_accelaire
	PAR	256+40
	PAR_END

	WAIT	$6b0
	START_C	R_Rapide
	PAR	Anim_Accordeon
	PAR     6
	PAR_L   Dummy_Pal
                  PAR	256+100
	PAR_END

	WAIT	$6c0
	START_C	R_Sol_Guide
	PAR	256+200
	PAR_END

	WAIT	$6d0
	START_C	R_Rapide
	PAR	Anim_Accordeon
	PAR     6
	PAR_L   Dummy_Pal
                  PAR	256+140
	PAR_END

	WAIT	$6e0
	START_C	R_Rapide
	PAR	Anim_Accordeon
	PAR     6
	PAR_L   Dummy_Pal
                  PAR	256+160
	PAR_END

	WAIT	$700
	START_C	R_Sol_Guide
	PAR	256+200
	PAR_END

	WAIT	$720
	START_C	R_Rapide
	PAR	Anim_Accordeon
	PAR     8
	PAR_L   Dummy_Pal
                  PAR	256+50
	PAR_END

	WAIT	$730
	START_C	R_Rapide
	PAR	Anim_Accordeon
	PAR     10
	PAR_L   Dummy_Pal
                  PAR	256+180
	PAR_END

	WAIT	$740
	START_C	R_Rapide
	PAR	Anim_Accordeon
	PAR     10
	PAR_L   Dummy_Pal
                  PAR	256+140
	PAR_END

	WAIT	$760
	START_C	R_Rapide
	PAR	Anim_Accordeon
	PAR     10
	PAR_L   Dummy_Pal
                  PAR	256+100
	PAR_END

	WAIT	$770
	START_C	R_Rapide
	PAR	Anim_Accordeon
	PAR     10
	PAR_L   Dummy_Pal
                  PAR	256+60
	PAR_END

	WAIT	$780
	START_C	R_Rapide
	PAR	Anim_Accordeon
	PAR     10
	PAR_L   Dummy_Pal
                  PAR	256+20
	PAR_END

	WAIT	$790
	START_C	R_Rapide
	PAR	Anim_Accordeon
	PAR     12
	PAR_L   Dummy_Pal
                  PAR	256+40
	PAR_END

	WAIT	$7a0
	START_C	R_Rapide
	PAR	Anim_Accordeon
	PAR     12
	PAR_L   Dummy_Pal
                  PAR	256+80
	PAR_END

	WAIT	$7b0
	START_C	R_Rapide
	PAR	Anim_Accordeon
	PAR     12
	PAR_L   Dummy_Pal
                  PAR	256+120
	PAR_END

	WAIT	$7c0
	START_C	R_Rapide
	PAR	Anim_Accordeon
	PAR     12
	PAR_L   Dummy_Pal
                  PAR	256+160
	PAR_END

                  WAIT	$820
	START_A	DG_Crolle_Diable,256+300,256+170

                  WAIT	$840
	START_A	DGDP_Full_7c,320+256,265

                  WAIT	$860
	START_A	DGDP_Tete,320+256,256+130

                  WAIT	$880
	START_A	DGDP_Full_7c,320+256,256

	WAIT	$900
	START_C R_Sol_Crache
	PAR     30
	PAR_END

	WAIT	$950
	START_C R_Sol_Crache
	PAR     30
	PAR_END

                  WAIT	$960
	START_A	DGDP_Tete,320+256,256+100

	WAIT	$9a0
	START_C R_Sol_Crache
	PAR     30
	PAR_END

                  WAIT	$9c0
	START_A	DGMP_Diable,256+200,256+220

                  WAIT	$a00
	START_A	DGMP_Diable,256+160,256+220

                  WAIT	$a40
	START_A	DGMP_Diable,256+120,256+220

	WAIT	$a48
	START_C	R_Sol_Guide
	PAR	256+200
	PAR_END

                  WAIT	$a80
	START_A	DGMP_Diable_2,256+220,256+220

	WAIT	$ac8
	START_C	R_Sol_Guide
	PAR	256+150
	PAR_END

                  WAIT	$ae0
	START_A	DGDP_Diable_2,256+300,256

	WAIT	$b00
	START_C	R_Sol_Etoile
	PAR     100+256
	PAR_END

                  WAIT	$b08
	START_A	DGDP_Diable_2,256+300,256+40

	WAIT	$b10
                  START_C	R_Volant_accelaire
	PAR	256+30
	PAR_END

	WAIT	$b20
	START_C	R_Tir_Etoile
	PAR     150+256
	PAR	80+256
	PAR_END

                  WAIT	$b30
	START_A	DGDP_Diable_2,256+300,256+80

	WAIT	$b50
                  START_C	R_Volant_accelaire
	PAR	256+60
	PAR_END

                  WAIT	$b60
	START_A	DGDP_Diable_2,256+300,256+120

                  WAIT	$b80
	START_A	DGDP_Diable_2,256+300,256+160

                  WAIT    $ba0
	START_A	DGDP_Diable_2,256+300,256+120

                  WAIT	$bc0
	START_A	DGDP_Diable_2,256+300,256+80

                  WAIT	$c70
	START_A	DGDP_Full_7c,320+256,256

                  WAIT    $c80
	START_A	Saut_Diable,256+250,256+220

                  WAIT	$c90
	START_A	Saut_Diable,256+200,256+220

	WAIT	$ca0
	START_C R_Sol_Crache
	PAR     25
	PAR_END

                  WAIT	$cd0
	START_A	Saut_Diable,256+230,256+220

                  WAIT	$d00
	START_A	Saut_Diable,256+180,256+220

	WAIT	$d20
	START_C R_Sol_Crache
	PAR     25
	PAR_END

                  WAIT	$d40
	START_A	Saut_Diable,256+150,256+220

                  WAIT	$d60
	START_A	Saut_Diable,256+250,256+220

                  WAIT	$d80
	START_A	DGDP_Full_7c,320+256,256

                  WAIT	$da0
	START_A	Saut_Diable,256+180,256+220

                  WAIT	$dd0
	START_A	Saut_Diable,256+160,256+220

                  WAIT	$e00
	START_A	DGDP_Full_7c,320+256,256

                  WAIT	$e20
	START_A	Saut_Diable,256+150,256+220

	WAIT	$f60
	START_C	R_Dragon
	PAR	256+60
	PAR_END

                  WAIT	$f65
	START_A	GDDP_Squelette_2,256+150,220

	WAIT	$f70
	START_C	R_Sol_Kamikaze
	PAR_END

                  WAIT	$f80
	START_A	GDDP_Squelette_2,256+120,220

                  WAIT	$fc0
	START_A	GDDP_Squelette_2,256+90,220

                  WAIT	$1000
	START_A	GDDP_Squelette_2,256+60,220

	WAIT	$1030
	START_C	R_Dragon
	PAR	256+60
	PAR_END

                  WAIT	$1040
	START_A	GDDP_Squelette,220,256

	WAIT	$1080
	START_C	R_Spectre	* Guided Spectre, Ground Start
	PAR	180+256	* Sp. Launch X
	PAR	25	* Sp. Fire Rate
	PAR	2	* X Speed
	PAR	2	* Y Speed
                  PAR_END

                  WAIT	$10a0
	START_A	GDDP_Squelette,220,256+40

	WAIT	$10c0
	START_C	R_Spectre	* Guided Spectre, Ground Start
	PAR	180+256	* Sp. Launch X
	PAR	25	* Sp. Fire Rate
	PAR	2	* X Speed
	PAR	3	* Y Speed
                  PAR_END

	WAIT	$1110
	START_C	R_Dragon
	PAR	256+60
	PAR_END

                  WAIT	$1000
	START_A	GDDP_Squelette_2,256+90,220

                  WAIT	$10e0
	START_A	GDDP_Squelette,220,256+130

                  WAIT	$1100
	START_A	GDDP_Squelette_2,256+120,220

                  WAIT	$1120
	START_A	DGMP_Squelette_1,256+200,256+220

                  WAIT	$1160
	START_A	DGMP_Squelette_1,256+230,256+220

	WAIT	$1280
	START_C	R_Sol_Kamikaze
	PAR_END

                  WAIT	$12a0
	START_A	DGDP_Tete,320+256,256+130

	WAIT	$12c0
	START_C	R_Sol_Kamikaze
	PAR_END

                  WAIT	$12d0
	START_A	DGDP_Tete,320+256,256+140

                  WAIT	$12f0 *1270
	START_A	DGDP_Full_7c,320+256,256

	WAIT	$1300
	START_C	R_Sol_Kamikaze
	PAR_END

                  WAIT	$1320
	START_A	DGDP_Tete,320+256,256+130

	WAIT	$1340
	START_C	R_Sol_Kamikaze
	PAR_END

	WAIT	$1440
	START_C	R_Rapide
	PAR	Anim_Accordeon
	PAR     14
	PAR_L   Dummy_Pal
                  PAR	256+160
	PAR_END

	WAIT	$1480
                  START_C	R_Volant_accelaire
	PAR	256+30
	PAR_END

	WAIT	$1488
	START_C	R_Rapide
	PAR	Anim_Accordeon
	PAR     14
	PAR_L   Dummy_Pal
                  PAR	256+150
	PAR_END

	WAIT	$14a0
	START_C R_Sol_Crache
	PAR     45
	PAR_END

	WAIT	$14c0
	START_C	R_Volant_missile
	PAR_END

	WAIT	$14c8
	START_C	R_Rapide
	PAR	Anim_Accordeon
	PAR     14
	PAR_L   Dummy_Pal
                  PAR	256+160
	PAR_END

	WAIT	$14d0
	START_C	R_Sol_Kamikaze
	PAR_END

	WAIT	$1500
                  START_C	R_Volant_accelaire
	PAR	256+60
	PAR_END

	WAIT	$1508
	START_C	R_Rapide
	PAR	Anim_Accordeon
	PAR     14
	PAR_L   Dummy_Pal
                  PAR	256+150
	PAR_END

	WAIT	$1520
	START_C	R_Sol_Etoile
	PAR     120+256
	PAR_END

	WAIT	$1540
	START_C	R_Kamikaze
	PAR	25*7
	PAR	2
	PAR	2
	PAR_END

	WAIT	$1548
	START_C	R_Rapide
	PAR	Anim_Accordeon
	PAR     14
	PAR_L   Dummy_Pal
                  PAR	256+160
	PAR_END

	WAIT	$1560
	START_C	R_Sol_Guide
	PAR	256+150
	PAR_END

	WAIT	$1580
                  START_C	R_Volant_accelaire
	PAR	256+40
	PAR_END

	WAIT	$1588
	START_C	R_Rapide
	PAR	Anim_Accordeon
	PAR     14
	PAR_L   Dummy_Pal
                  PAR	256+170
	PAR_END

	WAIT	$15c0
	START_C	R_Tir_Etoile
	PAR     150+256
	PAR	80+256
	PAR_END

	WAIT	$15c8
	START_C	R_Rapide
	PAR	Anim_Accordeon
	PAR     14
	PAR_L   Dummy_Pal
                  PAR	256+160
	PAR_END

	WAIT	$1600
                  START_C	R_Volant_accelaire
	PAR	256+50
	PAR_END

	WAIT	$1608
	START_C	R_Rapide
	PAR	Anim_Accordeon
	PAR     14
	PAR_L   Dummy_Pal
                  PAR	256+140
	PAR_END

	WAIT	$1620
	START_C	R_Sol_Guide
	PAR	256+150
	PAR_END

	WAIT	$1640
	START_C	R_Rapide
	PAR	Anim_Accordeon
	PAR     14
	PAR_L   Dummy_Pal
                  PAR	256+160
	PAR_END

	WAIT	$1660
	START_C	R_Sol_Guide
	PAR	256+150
	PAR_END

	WAIT	$1680
                  START_C	R_Volant_accelaire
	PAR	256+60
	PAR_END

	WAIT	$1688
	START_C	R_Rapide
	PAR	Anim_Accordeon
	PAR     14
	PAR_L   Dummy_Pal
                  PAR	256+150
	PAR_END

	WAIT	$16a0
	START_C	R_Sol_Guide
	PAR	256+150
	PAR_END

	WAIT	$16c0
	START_C	R_Rapide
	PAR	Anim_Accordeon
	PAR     14
	PAR_L   Dummy_Pal
                  PAR	256+160
	PAR_END

	WAIT	$1700
                  START_C	R_Volant_accelaire
	PAR	256+40
	PAR_END

	WAIT	$1708
	START_C	R_Rapide
	PAR	Anim_Accordeon
	PAR     14
	PAR_L   Dummy_Pal
                  PAR	256+170
	PAR_END

	WAIT	$1740
	START_C	R_Volant_missile
	PAR_END

	WAIT	$1748
	START_C	R_Rapide
	PAR	Anim_Accordeon
	PAR     14
	PAR_L   Dummy_Pal
                  PAR	256+140
	PAR_END

	WAIT	$1780
                  START_C	R_Volant_accelaire
	PAR	256+30
	PAR_END

	WAIT	$1788
	START_C	R_Rapide
	PAR	Anim_Accordeon
	PAR     14
	PAR_L   Dummy_Pal
                  PAR	256+160
	PAR_END

	WAIT	$17c0
	START_C	R_Kamikaze
	PAR	25*7
	PAR     3
	PAR	2
	PAR_END

	WAIT	$17c8
	START_C	R_Rapide
	PAR	Anim_Accordeon
	PAR     14
	PAR_L   Dummy_Pal
                  PAR	256+160
	PAR_END

	WAIT	$1800
                  START_C	R_Volant_accelaire
	PAR	256+50
	PAR_END

	WAIT	$1808
	START_C	R_Rapide
	PAR	Anim_Accordeon
	PAR     14
	PAR_L   Dummy_Pal
                  PAR	256+150
	PAR_END

	WAIT	$1840
	START_C	R_Tir_Etoile
	PAR     150+256
	PAR	80+256
	PAR_END

	WAIT	$1848
	START_C	R_Rapide
	PAR	Anim_Accordeon
	PAR     14
	PAR_L   Dummy_Pal
                  PAR	256+140
	PAR_END

	WAIT	$1880
                  START_C	R_Volant_accelaire
	PAR	256+20
	PAR_END

	WAIT	$1888
	START_C	R_Rapide
	PAR	Anim_Accordeon
	PAR     14
	PAR_L   Dummy_Pal
                  PAR	256+160
	PAR_END

	WAIT	$18a0
	START_C R_Sol_Crache
	PAR     45
	PAR_END

	WAIT	$18c0
	START_C	R_Rapide
	PAR	Anim_Accordeon
	PAR     14
	PAR_L   Dummy_Pal
                  PAR	256+170
	PAR_END

	WAIT	$18d0
	START_C	R_Sol_Etoile
	PAR     120+256
	PAR_END

	WAIT	$18e0
                  START_C	R_Volant_accelaire
	PAR	256+40
	PAR_END

	WAIT	$1900
                  START_C	R_Volant_accelaire
	PAR	256+60
	PAR_END

	WAIT	$1908
	START_C	R_Rapide
	PAR	Anim_Accordeon
	PAR     14
	PAR_L   Dummy_Pal
                  PAR	256+150
	PAR_END

	WAIT	$1910
	START_C	R_Sol_Guide
	PAR	256+150
	PAR_END

	WAIT	$1940
	START_C	R_Rapide
	PAR	Anim_Accordeon
	PAR     14
	PAR_L   Dummy_Pal
                  PAR	256+160
	PAR_END

	WAIT	$1980
                  START_C	R_Volant_accelaire
	PAR	256+20
	PAR_END

	WAIT	$1984
	START_C	R_Rapide
	PAR	Anim_Accordeon
	PAR     14
	PAR_L   Dummy_Pal
                  PAR	256+140
	PAR_END

	WAIT	$1988
                  START_C	R_Volant_accelaire
	PAR	256+80
	PAR_END

	WAIT	$1990
	START_C	R_Sol_Guide
	PAR	256+150
	PAR_END

	WAIT	$19a0
                  START_C	R_Volant_accelaire
	PAR	256+30
	PAR_END

	WAIT	$19b0
	START_C	R_Sol_Guide
	PAR	256+150
	PAR_END

	WAIT	$19c0
                  START_C	R_Volant_accelaire
	PAR	256+60
	PAR_END

	WAIT	$19c8
	START_C	R_Rapide
	PAR	Anim_Accordeon
	PAR     14
	PAR_L   Dummy_Pal
                  PAR	256+160
	PAR_END

	WAIT	$19d0
	START_C	R_Sol_Guide
	PAR	256+150
	PAR_END

	WAIT	$19e0
                  START_C	R_Volant_accelaire
	PAR	256+50
	PAR_END

	WAIT	$19f0
                  START_C	R_Volant_accelaire
	PAR	256+80
	PAR_END

	WAIT	$1a00
                  START_C	R_Volant_accelaire
	PAR	256+30
	PAR_END

	WAIT	$1a08
	START_C	R_Rapide
	PAR	Anim_Accordeon
	PAR     14
	PAR_L   Dummy_Pal
                  PAR	256+140
	PAR_END

                  WAIT	$1bc0
	START_A	DGDP_Full_7c,320+256,256

                  WAIT	$1bd0
	START_A	Saut_Diable_2,256+280,256+220

                  WAIT	$1be0
	START_A	Saut_Diable_2,256+260,256+220

                  WAIT	$1bf0
	START_A	Saut_Diable_2,256+240,256+220

	WAIT	$1c00
	START_C R_Sol_Crache
	PAR     45
	PAR_END

	WAIT	$1c10
	START_C	R_Rapide
	PAR	Anim_Accordeon
	PAR     12
	PAR_L   Dummy_Pal
                  PAR	256+140
	PAR_END

	WAIT	$1c30
	START_C	R_Rapide
	PAR	Anim_Accordeon
	PAR     12
	PAR_L   Dummy_Pal
                  PAR	256+140
	PAR_END

	WAIT	$1c40
	START_C	R_Sol_Kamikaze
	PAR_END

                  WAIT	$1c60
	START_A	DGDP_Tete,320+256,256+130

	WAIT	$1c80
	START_C R_Sol_Crache
	PAR     30
	PAR_END

	WAIT	$1ca0
	START_C	R_Rapide
	PAR	Anim_Accordeon
	PAR     12
	PAR_L   Dummy_Pal
                  PAR	256+140
	PAR_END

	WAIT	$1cc0
	START_C	R_Sol_Kamikaze
	PAR_END

                  WAIT	$1bc8
	START_A	Saut_Diable_2,256+220,256+220

                  WAIT	$1cd0
	START_A	DGDP_Full_7c,320+256,256

                  WAIT	$1ce0
	START_A	Saut_Diable_2,256+200,256+180

                  WAIT	$1cf0
	START_A	Saut_Diable_2,256+180,256+180

	WAIT	$1d00
	START_C R_Sol_Crache
	PAR     45
	PAR_END

                  WAIT	$1d10
	START_A	Saut_Diable_2,256+160,256+220

                  WAIT	$1d30
	START_A	Saut_Diable_2,256+140,256+220

	WAIT	$1d40
	START_C R_Sol_Crache
	PAR     45
	PAR_END

	WAIT	$1d60
	START_C	R_Rapide
	PAR	Anim_Accordeon
	PAR     12
	PAR_L   Dummy_Pal
                  PAR	256+140
	PAR_END

	WAIT	$1d80
	START_C	R_Rapide
	PAR	Anim_Accordeon
	PAR     14
	PAR_L   Dummy_Pal
                  PAR	256+140
	PAR_END

	WAIT	$1e20
	START_C	R_Dragon
	PAR	256+60
	PAR_END

                  WAIT	$1e30
	START_A	DGDP_Squelette_2,256+310,256+100

	WAIT	$1e40
	START_C	R_Spectre	* Guided Spectre, Ground Start
	PAR	180+256	* Sp. Launch X
	PAR	25	* Sp. Fire Rate
	PAR	2	* X Speed
	PAR	2	* Y Speed
                  PAR_END

                  WAIT	$1e60
	START_A	DGDP_Squelette_2,256+310,256+80

	WAIT	$1e80
	START_C	R_Spectre	* Guided Spectre, Ground Start
	PAR	180+256	* Sp. Launch X
	PAR	25	* Sp. Fire Rate
	PAR	3	* X Speed
	PAR	2	* Y Speed
                  PAR_END

                  WAIT	$1e80
	START_A	DGDP_Squelette_2,256+310,256+60

	WAIT	$1ea0
	START_C	R_Rapide
	PAR	Anim_Accordeon
	PAR     12
	PAR_L   Dummy_Pal
                  PAR	256+130
	PAR_END

	WAIT	$1ec0
	START_C	R_Spectre	* Guided Spectre, Ground Start
	PAR	180+256	* Sp. Launch X
	PAR	25	* Sp. Fire Rate
	PAR	3	* X Speed
	PAR	3	* Y Speed
                  PAR_END

                  WAIT	$1ea0
	START_A	DGDP_Squelette_2,256+310,256+80

                  WAIT	$1ec0
	START_A	DGDP_Squelette_2,256+310,256+100

                  WAIT	$1f00
	START_A	DGDP_Squelette_2,256+310,256+120

	WAIT	$1f30
	START_C	R_Dragon
	PAR	256+60
	PAR_END

                  WAIT	$1f40
	START_A	DGDP_Squelette_2,256+310,256+80

	WAIT	$2080
	START_C	R_Kamikaze
	PAR	25*6
	PAR     3
	PAR     2
	PAR_END

                  WAIT	$2090
	START_A	DGDP_Diable_1,256+300,256+80

	WAIT	$2098
	START_C	R_Kamikaze
	PAR	25*7
	PAR     3
	PAR     3
	PAR_END

	WAIT	$20a0
                  START_C	R_Volant_accelaire
	PAR	256+80
	PAR_END

	WAIT	$20a8
	START_C	R_Sol_Guide
	PAR	256+150
	PAR_END

	WAIT	$20b8
	START_C	R_Rapide
	PAR	Anim_Accordeon
	PAR     12
	PAR_L   Dummy_Pal
                  PAR	256+130
	PAR_END

	WAIT	$20c0
                  START_C	R_Volant_accelaire
	PAR	256+50
	PAR_END

	WAIT	$20e0
                  START_C	R_Volant_accelaire
	PAR	256+60
	PAR_END

	WAIT	$20e4
	START_C	R_Rapide
	PAR	Anim_Accordeon
	PAR     12
	PAR_L   Dummy_Pal
                  PAR	256+140
	PAR_END

	WAIT	$20e8
	START_C	R_Sol_Guide
	PAR	256+150
	PAR_END

	WAIT	$20f0
                  START_C	R_Volant_accelaire
	PAR	256+40
	PAR_END

	WAIT	$2100
	START_C	R_Rapide
	PAR	Anim_Accordeon
	PAR     12
	PAR_L   Dummy_Pal
                  PAR	256+130
	PAR_END

	WAIT	$2110
                  START_C	R_Volant_accelaire
	PAR	256+30
	PAR_END

	WAIT	$2120
                  START_C	R_Volant_accelaire
	PAR	256+70
	PAR_END

	WAIT	$2138
	START_C	R_Rapide
	PAR	Anim_Accordeon
	PAR     12
	PAR_L   Dummy_Pal
                  PAR	256+130
	PAR_END

	WAIT	$2138
	START_C	R_Volant_missile
	PAR_END

	WAIT	$2140
                  START_C	R_Volant_accelaire
	PAR	256+20
	PAR_END

	WAIT	$2150
                  START_C	R_Volant_accelaire
	PAR	256+60
	PAR_END

	WAIT	$2158
	START_C	R_Rapide
	PAR	Anim_Accordeon
	PAR     12
	PAR_L   Dummy_Pal
                  PAR	256+130
	PAR_END

	WAIT	$2160
	START_C	R_Sol_Guide
	PAR	256+150
	PAR_END

	WAIT	$2170
	START_C	R_Rapide
	PAR	Anim_Accordeon
	PAR     12
	PAR_L   Dummy_Pal
                  PAR	256+140
	PAR_END

	WAIT	$2200
	START_C	R_Tir_Etoile
	PAR     150+256
	PAR	80+256
	PAR_END

	WAIT	$2300
                  START_C	R_Final
	PAR_END


	SL_END



* RELATIVE TRACKS START STRUCT
* ----------------------------


;	INCLUDE	Game/lPlateaux_Rtr.s



* ABSOLUTE TRACKS START STRUCT
* ----------------------------


DGDP_Full_7c
	DC.W	TX_DG_Descend_Plat_1 * AWS_Table_X_Off
	DC.W	TY_DG_Descend_Plat_1 * AWS_Table_Y_Off
	DC.W	Anim_Full_7c	* AWS_Table_Obj_Off
	DC.B	40	* AWS_Alien_Rate
	DC.B	2	* AWS_Alien_Num
	DC.W	10	* AWS_Alien_Energy
	DC.B	14	* AWS_Alien_Bad_F
	DC.B	1	* AWS_Alien_F_Rate
	DC.B	1	* AWS_Pal_Mod_Lin0
	DC.B	1	* AWS_Pal_Mod_Lin1
	DC.B	1	* AWS_Pal_Mod_Lin2
	DC.B	-1	* AWS_Pal_Mod_Lin3
	DC.B	-1	* AWS_Pal_Mod_Lin4
	DC.B	-1	* AWS_Pal_Mod_Lin5
	DC.W	$eb1	* AWS_Pal_Mod_Col1
	DC.W	$b71	* AWS_Pal_Mod_Col2
	DC.W	$961	* AWS_Pal_Mod_Col3
	DC.W	$731	* AWS_Pal_Mod_Col7
	DC.W	$511	* AWS_Pal_Mod_Col5
	DC.W	$211	* AWS_Pal_Mod_Col4
	DC.W	$100	* AWS_Pal_Mod_Col6

DGDP_Tete
	DC.W	TX_DG_Descend_Plat_7 * AWS_Table_X_Off
	DC.W	TY_DG_Descend_Plat_7 * AWS_Table_Y_Off
	DC.W	Anim_Tete	* AWS_Table_Obj_Off
	DC.B	20	* AWS_Alien_Rate
	DC.B	4	* AWS_Alien_Num
	DC.W	3	* AWS_Alien_Energy
	DC.B	20	* AWS_Alien_Bad_F
	DC.B	2	* AWS_Alien_F_Rate
	DC.B	1	* AWS_Pal_Mod_Lin0
	DC.B	1	* AWS_Pal_Mod_Lin1
	DC.B	1	* AWS_Pal_Mod_Lin2
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

Saut_Diable
	DC.W	TX_Saut_1	* AWS_Table_X_Off
	DC.W	TY_Saut_1	* AWS_Table_Y_Off
	DC.W	Anim_Diable	* AWS_Table_Obj_Off
	DC.B	20	* AWS_Alien_Rate
	DC.B	6	* AWS_Alien_Num
	DC.W	2	* AWS_Alien_Energy
	DC.B	6	* AWS_Alien_Bad_F
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

Saut_Diable_2
	DC.W	TX_Saut_1	* AWS_Table_X_Off
	DC.W	TY_Saut_1	* AWS_Table_Y_Off
	DC.W	Anim_Diable	* AWS_Table_Obj_Off
	DC.B	30	* AWS_Alien_Rate
	DC.B	3	* AWS_Alien_Num
	DC.W	2	* AWS_Alien_Energy
	DC.B	6	* AWS_Alien_Bad_F
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

DG_Sin_Diable
	DC.W	TX_DG_Sin_1	* AWS_Table_X_Off
	DC.W	TY_DG_Sin_1	* AWS_Table_Y_Off
	DC.W	Anim_Diable	* AWS_Table_Obj_Off
	DC.B	20	* AWS_Alien_Rate
	DC.B	12	* AWS_Alien_Num
	DC.W	4	* AWS_Alien_Energy
	DC.B	15	* AWS_Alien_Bad_F
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

DG_Crolle_Diable
	DC.W	TX_DG_Sin_1	* AWS_Table_X_Off
	DC.W	TY_DG_Sin_1	* AWS_Table_Y_Off
	DC.W	Anim_Diable	* AWS_Table_Obj_Off
	DC.B	30	* AWS_Alien_Rate
	DC.B	12	* AWS_Alien_Num
	DC.W	5	* AWS_Alien_Energy
	DC.B	15	* AWS_Alien_Bad_F
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

DGDP_Diable_1
	DC.W	TX_DG_Descend_Plat_7 * AWS_Table_X_Off
	DC.W	TY_DG_Descend_Plat_7 * AWS_Table_Y_Off
	DC.W	Anim_Diable	* AWS_Table_Obj_Off
	DC.B	30	* AWS_Alien_Rate
	DC.B	4	* AWS_Alien_Num
	DC.W	2	* AWS_Alien_Energy
	DC.B	10	* AWS_Alien_Bad_F
	DC.B	2	* AWS_Alien_F_Rate
	DC.B	1	* AWS_Pal_Mod_Lin0
	DC.B	1	* AWS_Pal_Mod_Lin1
	DC.B	1	* AWS_Pal_Mod_Lin2
	DC.B	1	* AWS_Pal_Mod_Lin3
	DC.B	1	* AWS_Pal_Mod_Lin4
	DC.B	1	* AWS_Pal_Mod_Lin5
	DC.W	-1	* AWS_Pal_Mod_Col1
	DC.W	-1	* AWS_Pal_Mod_Col2
	DC.W	-1	* AWS_Pal_Mod_Col3
	DC.W	-1	* AWS_Pal_Mod_Col7
	DC.W	$550	* AWS_Pal_Mod_Col5
	DC.W	$440	* AWS_Pal_Mod_Col4
	DC.W	$330	* AWS_Pal_Mod_Col6

DGDP_Diable_2
	DC.W	TX_DG_Descend_Plat_7 * AWS_Table_X_Off
	DC.W	TY_DG_Descend_Plat_7 * AWS_Table_Y_Off
	DC.W	Anim_Diable	* AWS_Table_Obj_Off
	DC.B	30	* AWS_Alien_Rate
	DC.B	1	* AWS_Alien_Num
	DC.W	2	* AWS_Alien_Energy
	DC.B	20	* AWS_Alien_Bad_F
	DC.B	2	* AWS_Alien_F_Rate
	DC.B	1	* AWS_Pal_Mod_Lin0
	DC.B	1	* AWS_Pal_Mod_Lin1
	DC.B	1	* AWS_Pal_Mod_Lin2
	DC.B	1	* AWS_Pal_Mod_Lin3
	DC.B	1	* AWS_Pal_Mod_Lin4
	DC.B	1	* AWS_Pal_Mod_Lin5
	DC.W	-1	* AWS_Pal_Mod_Col1
	DC.W	-1	* AWS_Pal_Mod_Col2
	DC.W	-1	* AWS_Pal_Mod_Col3
	DC.W	-1	* AWS_Pal_Mod_Col7
	DC.W	$550	* AWS_Pal_Mod_Col5
	DC.W	$440	* AWS_Pal_Mod_Col4
	DC.W	$330	* AWS_Pal_Mod_Col6

DGDP_Diable_3
	DC.W	TX_DG_Descend_Plat_6 * AWS_Table_X_Off
	DC.W	TY_DG_Descend_Plat_6 * AWS_Table_Y_Off
	DC.W	Anim_Diable	* AWS_Table_Obj_Off
	DC.B	30	* AWS_Alien_Rate
	DC.B	4	* AWS_Alien_Num
	DC.W	2	* AWS_Alien_Energy
	DC.B	10	* AWS_Alien_Bad_F
	DC.B	2	* AWS_Alien_F_Rate
	DC.B	1	* AWS_Pal_Mod_Lin0
	DC.B	1	* AWS_Pal_Mod_Lin1
	DC.B	1	* AWS_Pal_Mod_Lin2
	DC.B	1	* AWS_Pal_Mod_Lin3
	DC.B	1	* AWS_Pal_Mod_Lin4
	DC.B	1	* AWS_Pal_Mod_Lin5
	DC.W	-1	* AWS_Pal_Mod_Col1
	DC.W	-1	* AWS_Pal_Mod_Col2
	DC.W	-1	* AWS_Pal_Mod_Col3
	DC.W	-1	* AWS_Pal_Mod_Col7
	DC.W	$550	* AWS_Pal_Mod_Col5
	DC.W	$440	* AWS_Pal_Mod_Col4
	DC.W	$330	* AWS_Pal_Mod_Col6

DGMP_Diable
	DC.W	TX_DG_Monte_Plat_5 * AWS_Table_X_Off
	DC.W	TY_DG_Monte_Plat_5 * AWS_Table_Y_Off
	DC.W	Anim_Diable	* AWS_Table_Obj_Off
	DC.B	30	* AWS_Alien_Rate
	DC.B	3	* AWS_Alien_Num
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

DGMP_Diable_2
	DC.W	TX_DG_Monte_Plat_4 * AWS_Table_X_Off
	DC.W	TY_DG_Monte_Plat_4 * AWS_Table_Y_Off
	DC.W	Anim_Diable	* AWS_Table_Obj_Off
	DC.B	30	* AWS_Alien_Rate
	DC.B	3	* AWS_Alien_Num
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

DGDP_Squelette_1
	DC.W	TX_DG_Descend_Plat_9 * AWS_Table_X_Off
	DC.W	TY_DG_Descend_Plat_9 * AWS_Table_Y_Off
	DC.W	Anim_Squelette	* AWS_Table_Obj_Off
	DC.B	30	* AWS_Alien_Rate
	DC.B	4	* AWS_Alien_Num
	DC.W	2	* AWS_Alien_Energy
	DC.B	8	* AWS_Alien_Bad_F
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

DGDP_Squelette_2
	DC.W	TX_DG_Descend_Plat_6 * AWS_Table_X_Off
	DC.W	TY_DG_Descend_Plat_6 * AWS_Table_Y_Off
	DC.W	Anim_Squelette	* AWS_Table_Obj_Off
	DC.B	30	* AWS_Alien_Rate
	DC.B	4	* AWS_Alien_Num
	DC.W	2	* AWS_Alien_Energy
	DC.B	8	* AWS_Alien_Bad_F
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

DGMP_Squelette_1
	DC.W	TX_DG_Monte_Plat_5 * AWS_Table_X_Off
	DC.W	TY_DG_Monte_Plat_5 * AWS_Table_Y_Off
	DC.W	Anim_Squelette	* AWS_Table_Obj_Off
	DC.B	30	* AWS_Alien_Rate
	DC.B	4	* AWS_Alien_Num
	DC.W	2	* AWS_Alien_Energy
	DC.B	8	* AWS_Alien_Bad_F
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

GDDP_Squelette
	DC.W	TX_GD_Descend_Plat_1 * AWS_Table_X_Off
	DC.W	TY_GD_Descend_Plat_1 * AWS_Table_Y_Off
	DC.W	Anim_Squelette	* AWS_Table_Obj_Off
	DC.B	30	* AWS_Alien_Rate
	DC.B	1	* AWS_Alien_Num
	DC.W	1	* AWS_Alien_Energy
	DC.B	15	* AWS_Alien_Bad_F
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

GDDP_Squelette_2
	DC.W	TX_GD_Descend_Plat_4 * AWS_Table_X_Off
	DC.W	TY_GD_Descend_Plat_4 * AWS_Table_Y_Off
	DC.W	Anim_Squelette	* AWS_Table_Obj_Off
	DC.B	30	* AWS_Alien_Rate
	DC.B	2	* AWS_Alien_Num
	DC.W	1	* AWS_Alien_Energy
	DC.B	15	* AWS_Alien_Bad_F
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




* ANIMATION TABLE
* ---------------


__	MACRO
\1	EQU     *-Anim_Base
	ENDM

Anim_Base


 __ Anim_Full_7c
	DC.W	Obj_Full_7c
	DC.W	-1


 __ Anim_Accordeon
	DC.W	Obj_Accordeon_1
	DC.W	Obj_Accordeon_2
	DC.W	Obj_Accordeon_3
	DC.W	Obj_Accordeon_4
	DC.W	Obj_Accordeon_5
	DC.W	Obj_Accordeon_6
	DC.W	Obj_Accordeon_7
	DC.W	Obj_Accordeon_6
	DC.W	Obj_Accordeon_5
	DC.W	Obj_Accordeon_4
	DC.W	Obj_Accordeon_3
	DC.W	Obj_Accordeon_2
	DC.W	-1

 __ Anim_Diable
	DC.W	Obj_Diable
	DC.W	-1

 __ Anim_Squelette
	DC.W	Obj_Squelette
	DC.W	-1

 __ Anim_Tete
	DC.W	Obj_Volant_Missile_1
	DC.W	Obj_Volant_Missile_1
	DC.W	Obj_Volant_Missile_1
	DC.W	Obj_Volant_Missile_1
	DC.W	Obj_Volant_Missile_2
	DC.W	Obj_Volant_Missile_2
	DC.W	Obj_Volant_Missile_2
	DC.W	-1





***************************************************************************

*                 ROUTINES

***************************************************************************



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
	move	#Obj_FireBall,Awo_Alien_Obj_Off(a2)
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
	rts
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



* DRAGON
* ------


	RSRESET
R_D_Mode	RS.W	1	* 0=Init 1=Monstre Folow
R_D_Langue_Delay	RS.W	1
R_D_Langue_Step	RS.W	1
R_D_Shape	RS.W	1

	RSRESET
P_D_Y	RS.W	1


R_D_Pal
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
	DC.W	$760	* AWS_Pal_Mod_Col5
	DC.W	$811	* AWS_Pal_Mod_Col6
	DC.W	-1	* AWS_Pal_Mod_Col7

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
	move.l	#R_D_Pal,Rout_Pal_Ptr(D)
                  st	Refresh_Pal+1(D)
	addq	#1,Rout_Mod_Pal_Counter(D)
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
	subq	#1,Rout_Mod_Pal_Counter(D)
	tst	Rout_Mod_Pal_Counter(D)
	bne	.no_close_col
	move.l	#-1,Rout_Pal_Ptr(D)
	st	Refresh_Pal+1(D)
.no_close_col
	rts



* VOLANT ACCELAIRE SI TOUCHE
* --------------------------


	RSRESET
R_VA_Mode	RS.W    1
R_VA_Anim	RS.W	1
R_VA_Speed	RS.W	1

	RSRESET
P_VA_Y	RS.W	1

R_VA_Pal
	DC.B	1	* Mod_Lin0
	DC.B	1	* Mod_Lin1
	DC.B	1	* Mod_Lin2
	DC.B	-1	* Mod_Lin3
	DC.B	-1	* Mod_Lin4
	DC.B	-1	* Mod_Lin5
	DC.W	$da7	* AWS_Pal_Mod_Col1
	DC.W	$765	* AWS_Pal_Mod_Col2
	DC.W	$321	* AWS_Pal_Mod_Col3
	DC.W	-1	* AWS_Pal_Mod_Col4
	DC.W	-1	* AWS_Pal_Mod_Col5
	DC.W	-1	* AWS_Pal_Mod_Col6
	DC.W	-1	* AWS_Pal_Mod_Col7

R_VA_Shape
	DC.W    Obj_Acc_1
	DC.W    Obj_Acc_1
	DC.W    Obj_Acc_2
	DC.W    Obj_Acc_2
	DC.W    Obj_Acc_3
	DC.W    Obj_Acc_3
	DC.W    Obj_Acc_4
	DC.W    Obj_Acc_4
	DC.W    Obj_Acc_5
	DC.W    Obj_Acc_5
	DC.W    Obj_Acc_6
	DC.W    Obj_Acc_6
	DC.W    Obj_Acc_5
	DC.W    Obj_Acc_5
	DC.W    Obj_Acc_4
	DC.W    Obj_Acc_4
	DC.W    Obj_Acc_3
	DC.W    Obj_Acc_3
	DC.W    Obj_Acc_2
	DC.W    Obj_Acc_2

R_Volant_Accelaire
	move.l	Rout_Param_Ptr(a0),a1
	move.l	Rout_Awo_Ptr(a0),a2
	lea	Rout_Variables(a0),a3

	move	R_VA_Mode(a3),d0
	bne	.no_init
	move.l	#$00010000,(a2)+
	move.l	#R_VA_Pal,Rout_Pal_Ptr(D)
                  st	Refresh_Pal+1(D)
	addq	#1,Rout_Mod_Pal_Counter(D)
	move	#256+340,Awo_Alien_X(a2)
	move	P_VA_Y(a1),Awo_Alien_Y(a2)
	move	#Obj_Acc_1,Awo_Alien_Obj_Off(a2)
	move	#6,AWO_Alien_Energy(a2)
	clr.l	Awo_Alien_Status(a2)
	addq	#1,R_VA_Mode(a3)
	move	#2,R_VA_Speed(a3)
	bra	.end
.no_init
	move.l	#$00010000,(a2)+
	move	R_VA_Speed(a3),d1
	sub	d1,AWO_Alien_X(a2)

                  addq	#2,R_VA_Anim(a3)
	cmp	#40,R_VA_Anim(a3)
	bne	.ok
	clr	R_VA_Anim(a3)
.ok
	move	R_VA_Anim(a3),d1
	lea	R_VA_Shape,a4
	move	(a4,d1.w),Awo_Alien_Obj_Off(a2)

	cmp.b	#$10,AWO_Alien_Status(a2)
	bne	.no
	addq	#1,R_VA_Speed(a3)
.no
	cmp	#220,AWO_Alien_X(a2)
	bge	.end
.close
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
R_F_Mode	RS.W	1	* 0=Init 1=Monstre Folow
R_F_Launch_Delay	RS.W	1
R_F_Anim	RS.W	1
R_F_Sens	RS.W	1

Final_Shape
                  DC.W	Obj_Final_1
                  DC.W	Obj_Final_2
                  DC.W	Obj_Final_3
                  DC.W	Obj_Final_4
                  DC.W	Obj_Final_5
                  DC.W	Obj_Final_6
                  DC.W	Obj_Final_7
                  DC.W	Obj_Final_8
                  DC.W	Obj_Final_7
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
	move	#Obj_Final_1,Awo_Alien_Obj_Off(a2)
	move	#200,AWO_Alien_Energy(a2)
	move.l	#$00080000,Awo_Alien_Status(a2)
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
	tst	R_F_Sens(a3)
	bne	.descend
	subq	#3,Awo_Alien_Y(a2)
	cmp	#256+40,Awo_Alien_Y(a2)
	bgt	.cont
	addq	#1,R_F_Sens(a3)
	bra	.cont
.descend
	addq	#3,Awo_Alien_Y(a2)
	cmp	#256+200,Awo_Alien_Y(a2)
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
	addq	#2,R_F_Anim(a3)
	cmp	#28,R_F_Anim(a3)
	bne	.cont3
	clr	R_F_Anim(a3)
.cont3
	move	R_F_Anim(a3),d1
	lea	Final_Shape,a4
	move	(a4,d1.w),Awo_Alien_Obj_Off(a2)

	addq	#1,R_F_Launch_Delay(a3)
	cmp	#18,R_F_Launch_Delay(a3)
	bne	.end
	clr	R_F_Launch_Delay(a3)

	lea	Rout_Struct-Rout_Len(D),a1
.rout_loop
	lea	Rout_Len(a1),a1
	tst.l   (a1)
	bpl	.rout_loop
	move.l	#R_Final_2,Rout_Code_Ptr(a1)
	lea	Par_Buffer,a4
	move.l	a4,Rout_Param_Ptr(a1)
	move	AWO_Alien_X(a2),(a4)+
	move	AWO_Alien_Y(a2),(a4)
	lea	AWO_Struct-AWO_size(D),a2
.awo_loop
	lea	AWO_size(a2),a2
	tst	(a2)
	bpl	.awo_loop
	move.l	a2,Rout_Awo_Ptr(a1)
	clr.l	(a2)+
	clr.l	Rout_Variables(a1)
	clr.l	Rout_Variables+4(a1)
	clr.l	Rout_Variables+8(a1)
	clr.l	Rout_Variables+12(a1)
.par_loop
                  cmp	#-1,(a4)+
	bne	.par_loop
.end
                  rts
.close
	move.l	#-1,(a0)	* CLOSE
	move	#-1,-4(a2)
	move	#25,Quit_Delay(D)
	st	Clean_Up(D)
	rts

Par_Buffer
	DS.W	1	* xpos
	DS.W	1	* ypos
	DC.W	-1



* FINAL 2 (Slave)
* ---------------


	RSRESET
R_F2_Mode	RS.W    1
R_F2_Anim	RS.W	1

	RSRESET
P_F2_X	RS.W	1
P_F2_Y	RS.W	1

R_F2_Shape
                  DC.W	Obj_Final_1
                  DC.W	Obj_Final_2
                  DC.W	Obj_Final_3
                  DC.W	Obj_Final_4
                  DC.W	Obj_Final_5
                  DC.W	Obj_Final_6
                  DC.W	Obj_Final_7
                  DC.W	Obj_Final_8
                  DC.W	Obj_Final_7
                  DC.W	Obj_Final_6
                  DC.W	Obj_Final_5
                  DC.W	Obj_Final_4
                  DC.W	Obj_Final_3
                  DC.W	Obj_Final_2

R_Final_2
	move.l	Rout_Param_Ptr(a0),a1
	move.l	Rout_Awo_Ptr(a0),a2
	lea	Rout_Variables(a0),a3

	move	R_F2_Mode(a3),d0
	bne	.no_init
	move.l	#$00010000,(a2)+
	move	P_F2_X(a1),Awo_Alien_X(a2)
	move	P_F2_Y(a1),Awo_Alien_Y(a2)
	move	#Obj_Final_1,Awo_Alien_Obj_Off(a2)
	move	#4,AWO_Alien_Energy(a2)
	clr.l	Awo_Alien_Status(a2)
	addq	#1,R_F2_Mode(a3)
	bra	.end
.no_init
	move.l	#$00010000,(a2)+
	sub	#8,AWO_Alien_X(a2)

                  addq	#2,R_F2_Anim(a3)
	cmp	#28,R_F2_Anim(a3)
	bne	.ok
	clr	R_F2_Anim(a3)
.ok
	move	R_F2_Anim(a3),d1
	lea	R_F2_Shape,a4
	move	(a4,d1.w),Awo_Alien_Obj_Off(a2)

	move	Sorcerer_Y(D),d1
                  cmp	Awo_Alien_Y(a2),d1
	beq	.cont
	bgt	.descend
	subq	#1,Awo_Alien_Y(a2)
	bra	.cont
.descend
	addq	#1,Awo_Alien_Y(a2)
.cont
	cmp	#220,AWO_Alien_X(a2)
	bge	.end
.close
	move.l	#-1,(a0)	* CLOSE
	move	#-1,-4(a2)
	tst	Rout_Mod_Pal_Counter(D)
	bne	.no_close_col
	move.l	#-1,Rout_Pal_Ptr(D)
	st	Refresh_Pal+1(D)
.no_close_col
.end
	rts







***************************************************************************

*                 BINARY DATA

***************************************************************************



Relative_Tracks
;	RINCBIN	Game/lPlateaux.rtb
Absolute_Tracks
	RINCBIN	Game/lPlateaux.atb
Sin_Table1
	RINCBIN	Game/Sin_Table1.bin
Sin_Table2
	RINCBIN	Game/Sin_Table2.bin
Sin_Table3
	RINCBIN	Game/Sin_Table3.bin




