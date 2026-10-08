
**************************************************************************
*
* 	ART & MAGIC DOS LOADING SUBROUTINES
*	-----------------------------------
*
* Code :		Michel Janssens
* Update :	Art & Magic (interface)
* Release :	1.2
* Date :            5/9/91
* Tab :		10
*
**************************************************************************



		INCLUDE	Work:Agony/Demo/load_label.s

DISK_DEBUG	SET       0



* CALLING MACROS
* --------------


* Usage:  	LOAD	FILE_x_x,addr
* 		return	d0 (file len)

LOAD		MACRO
                    lea	\2,a0
		move.l	#\1_code,d7	* d7 CODE
                    move	#\1_num,d0
                    lea	$300,a2		* $300 load_data
                    lsl	#3,d0
		add	d0,a2
		move.l	(a2),d0		* d0 DISK OFFSET
		move.l	4(a2),d1		* d1 LEN
		move.l	d1,-(sp)
		jsr	loadroutine1
		move.l	(sp)+,d0
		ENDM






*********************************************************
*         MAIN LOADING ROUTINES
*	a0=adresse chargement
*	d0=pointeur track
*	d1=longueur fichier
*	d7=code
********************************************************



LOAD_CODE		MACRO

LoadRoutine1
		movem.l	d0-d7/a0-a6,-(a7)

		lea	position_track(pc),a2


		move.l	a0,a5	;a0=adresse chargement
		adda.l	d1,a5	;a5=adresse fin
		clr.l	d3
		clr.l	d4
		move.l	d0,d5
		divu	#$1600,d5
		move.w	d5,d3	;d3 = track de chargement
		swap	d5
		move.w	d5,d4	;d4 = distance data dans track
		bsr	Open_drive
		bsr	position_sur_track_desire
		bsr	traitement
debut_f
		bsr	cloture_drives
		movem.l	(a7)+,d0-d7/a0-a6

		rts



;********************************************************


open_drive
		move.b	#$7d,$bfd100
		nop
		nop
		bclr	#3,$bfd100
		bsr	l_pause
		clr.l	d0
		rts



;*********************************************************


l_pause
		move.l	d1,-(a7)
		move.l	#$b000,d1
p_1
		dbra	d1,p_1
		move.l	(a7)+,d1
		rts



;*********************************************************


l_pause_track
		move.b	#$ac,$bfd400
		move.b	#$0d,$bfd500
		move.b	#$99,$bfde00
		tst.b	$bfdd00
p_2
		btst	#$0,$bfdd00
		beq.s	p_2
		rts



;*********************************************************


position_sur_track_zero
		bsr	l_pause_track
		bsr	l_pause_track
		bsr	l_pause_track
		bsr	l_pause_track
pos_z1
		btst	#4,$bfe001
		beq.s	pos_z3
		bset	#$0001,$bfd100
		bsr	av_track
pos_z2
		btst	#5,$bfe001
		bne.s	pos_z2
		bra.s	pos_z1
pos_z3
		clr.b	(a2)
		bsr	l_pause_track
		bsr	l_pause_track
		bsr	l_pause_track
		bsr	l_pause_track
		rts



;*********************************************************


Avance_track_suivant
		move.b	(a2),d0
		addq.l	#1,d0
		move.b	d0,(a2)
		btst	#0,d0
		bne.s	av_t3
		bclr	#$0001,$bfd100
		bsr.s	av_track
av_t1
		btst	#5,$bfe001
		bne.s	av_t1
		bset	#$0002,$bfd100
		bsr	l_pause
		rts
av_t3
		bclr	#$0002,$bfd100
		bsr	l_pause_track
		rts



;********************************************************


av_track
		bclr	#$0000,$bfd100
		nop
		nop
		bset	#$0000,$bfd100
		bsr	l_pause_track
av_1
		btst	#5,$bfe001
		bne.s	av_1
		rts



;********************************************************


position_sur_track_desire
		movem.l	d1-d2,-(a7)
		cmp.b	#$ff,(a2)
		bne.s	pos01
		bsr	position_sur_track_zero
		clr.b	(a2)
pos01
		clr.l	d1
		clr.l	d2
		move.b	(a2),d1
		move.b	d3,d2

		bset	#$0002,$bfd100
		btst	#0,d3
		beq.s	pos02
		bclr	#$0002,$bfd100
		bsr	l_pause
pos02
		lsr.w	#1,d2
		lsr.w	#1,d1

		sub.w	d1,d2
		bcs.s	pos04
		bhi.s	pos03
		bra.s	pos06
pos03
		bclr	#1,$bfd100
		bsr	l_pause
		bra.s	pos05
pos04
		neg.w	d2
		bset	#1,$bfd100
		bsr	l_pause
pos05
		bsr	av_track
		subq.w	#1,d2
		bne.s	pos05
pos06
		move.b	d3,(a2)
		movem.l	(a7)+,d1-d2
		rts



;********************************************************


Cloture_drives
		move.b	#$fd,$bfd100
		nop
		nop
		bclr	#3,$bfd100
		bsr	l_pause
		rts



;********************************************************


traitement
		moveq	#4,d2
trait1
		bsr	lecture_track
		tst.l	d0
		bne.s	erreur

		bsr	controle_buffer
		tst.l	d0
		bne.s	erreur

		bsr	decodification_track
		tst.l	d0
		bne.s	erreur
		cmp.l	a0,a5
		ble.s	traitf
		bsr	avance_track_suivant
		moveq	#4,d2
		bra.s	trait1
traitf
		rts

erreur

		bclr	#1,$bfd100
		bsr	l_pause
		bsr	av_track
		bsr	l_pause
		bset	#1,$bfd100
		bsr	l_pause
		bsr	av_track
		bsr	l_pause
		subq.l	#1,d2
		bne.s	traitement
err1
		move.w	d0,$dff180
		subq.w	#1,d0
		bra.s	err1

index
		movem.l	d0-d1,-(a7)
		clr.l	d0
		move.l	#$30000,d1
		move.b	$bfdd00,d0
index1
		move.b	$bfdd00,d0
		btst	#4,d0
		bne.s	index2
		subq.l	#1,d1
		bne.s	index1
index2
		movem.l	(a7)+,d0-d1
		rts



;********************************************************


lecture_track
		movem.l	d1-d2/a0-a2,-(a7)
lectr
		lea	$dff000,a6
		move.l	#buffer_disk,$20(a6)
		move.w	#$8210,$96(a6)
		move.w	#$4489,$7e(a6)
		move.w	#$7f00,$9e(a6)
		nop
		nop
		move.w	#$8500,$9e(a6)
		move.w	#$4000,$24(a6)

*		bsr	index
.loop
		btst	#5,$bfe001
		bne	.loop

		move.w	#$9e00,$24(a6)
		move.w	#$9e00,$24(a6)
		move.l	#$20000,d1
		move.w	#$0002,$9c(a6)
lect1
		move.w	$1e(a6),d2
		btst	#1,d2
		bne.s	lect2
		subq.l	#1,d1
		bne.s	lect1
lecterr
		moveq	#-1,d0
		bra.s	lectf
lect2
		moveq	#$00,d0
		lea	buffer_disk,a1
                    cmp	#$4489,(a1)
		bne	lecterr
lectf
		move.w	#$4000,$24(a6)
		movem.l	(a7)+,d1-d2/a0-a2
		rts



;********************************************************


decodification_track:
	movem.l d1-d3/d5-d7/a1-a6,-(a7)
	move.l	a0,a2
	move.l	a0,a3
	add.l	d4,a3
	move.l	a0,a4

	lea	buffer_disk,a1
	cmp.w	#$4489,(a1)
	bne.s	dec_erf

	moveq	#$0a,d5
dec_d1:	bsr	dec_header
	tst.l	d0
	bne.s	dec_df
	moveq	#$7f,d6
dec_d2:
	move.l	$200(a1),d1
	move.l	(a1)+,d0
	asl.l	#1,d0
	and.l	#$aaaaaaaa,d0
	and.l	#$55555555,d1
	or.l	d1,d0
	eor.l	d7,d0

	cmp.l	a3,a2
	bge.s	dec_d2a
	addq.l	#4,a2
	bra.s	dec_d3
dec_d2a:
	move.l	a2,a6
	addq.l	#4,a2
	sub.l	d4,a6
	cmp.l	a5,a6		;compare si fin adresse
	bge.s	dec_d3		;si oui pas de transfert
	move.l	d0,(a6)
dec_d3:	dbf	d6,dec_d2
dec_d4:	dbf	d5,dec_d1
	move.l	#$1600,d0
	sub.l	d4,d0
	add.l	d0,a0
	clr.l	d0
dec_df:	tst.l	d0
	bne.s	dec_erf
	clr.l	d4
dec_er:	movem.l	(a7)+,d1-d3/d5-d7/a1-a6
	rts
dec_erf:
	move.l	a4,a0
	moveq	#-1,d0
	bra.s	dec_er



;*************************************************


dec_header:
	move.w	#$4489,d0
	cmp.l	#buffer_disk+$4000,a1
	bgt.s	err_header
dec1:	cmp.w	(a1)+,d0	;compare si synchro trouve
	bne.s	dec1
	cmp.w	(a1),d0		;compare si 2eme synchro
	bne.s	dec2
	addq.l	#2,a1		;si oui adr buff=buff + 2
dec2:	move.l	(a1),d0
	move.l	$4(a1),d1
	asl.l	#1,d0
	and.l	#$aaaaaaaa,d0	;decodage header
	and.l	#$55555555,d1
	or.l	d1,d0
	move.l	d0,d1
	rol.l	#8,d1
	cmp.b	#$ff,d1		;teste si bonne valeur
	bne.s	err_header
	lsr.w	#8,d0
	lea	$38(a1),a1	;se positionne sur pointeur data
	add.w	d0,d0
	asl.w	#8,d0
	lea	$00(a4,d0.w),a2	;calcule adresse transfert
	moveq	#0,d0
	rts
err_header:
	moveq	#-1,d0
	rts



;********************************************************


controle_buffer
		movem.l	d1-d7/a0-a6,-(a7)
		lea	buffer_disk,a1
		moveq	#$00,d7
ctrl1
		cmp.w	#$4489,(a1)+
		bne.s	ctrl1
		cmp.w	#$4489,(a1)
		bne.s	ctrl2
		addq.l	#2,a1
ctrl2
		lea 	$38(a1),a0
		move.w	#$400,d1
		bsr	autoctrl
		move.l	d0,d2
		lea	$30(a1),a0
		bsr	header
		cmp.l	d0,d2
		bne.s	ctrl_err
		move.l	a1,a0
		bsr	header
		swap	d0
		cmp.b	position_track,d0
		bne.s	ctrl_err
		andi.l	#$ff00,d0
		cmp.w	#$ff00,d0
		bne.s	ctrl_err
		move.l	a1,a0
		moveq	#$28,d1
		bsr	autoctrl
		move.l	d0,d2
		lea	$28(a1),a0
		bsr	header
		cmp.l	d0,d2
		bne.s	ctrl_err
		cmp.l	#buffer_disk+$4000,a1
		bgt	ctrl_err
		add.l	#$400,a1
		addq.b	#1,d7
		cmp.b	#$0b,d7
		bne.s	ctrl1
		clr.l	d0
ctrl_fin
		movem.l	(a7)+,d1-d7/a0-a6
		rts

ctrl_err
		moveq	#-1,d0
		bra	ctrl_fin

autoctrl
		move.l	d2,-(a7)
		lsr.w	#2,d1
		subq.w	#1,d1
		moveq	#$00,d0
auto1
		move.l	(a0)+,d2
		eor.l	d2,d0
		dbra	d1,auto1
		andi.l	#$55555555,d0
		move.l	(a7)+,d2
		rts

header
		move.l	(a0)+,d0
		move.l	(a0)+,d1
		andi.l	#$55555555,d0
		andi.l	#$55555555,d1
		lsl.l	#1,d0
		or.l	d1,d0
		rts



;********************************************************


		even
position_track
		dcb.b	1,$ff
		even


		ENDM

