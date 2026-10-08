;============================================================================
;=                      NoisetrackerV1.0 replayroutine                      =
;============================================================================

Noise_Regs:	reg a0-a6/d0-d7

END_MUSIC:
M_NOISEEND:	clr.w	$dff0a8
	clr.w	$dff0b8
	clr.w	$dff0c8
	clr.w	$dff0d8
	move.w	#$f,$dff096
	rts

INIT_MUSIC:
M_NOISEINIT:	movem.l	Noise_Regs,-(sp)
	move.l	MusicStart,a0	;lea Soundtrack,a0
	clr.b	951(a0)	;For OLD Songs !!
	move.l	a0,a1
	add.l	#$3b8,a1
	moveq	#$7f,d0
	moveq	#0,d1
MT_LOOP:	move.l	d1,d2
	subq.w	#1,d0
MT_LOP2:	move.b	(a1)+,d1
	cmp.b	d2,d1
	bgt.s	MT_LOOP
	dbf	d0,MT_LOP2
	addq.b	#1,d2
	lea	MT_SAMPLESTARTS(pc),a1
	asl.l	#8,d2
	asl.l	#2,d2
	add.l	#$43c,d2
	add.l	a0,d2
	move.l	d2,a2
	moveq	#$1e,d0
MT_LOP3:	clr.l	(a2)
	move.l	a2,(a1)+
	moveq	#0,d1
	move.w	42(a0),d1
	asl.l	#1,d1
	add.l	d1,a2
	add.l	#$1e,a0
	dbf	d0,MT_LOP3
	or.b	#$2,$bfe001
	move.b	#$6,MT_SPEED
	clr.w	$dff0a8
	clr.w	$dff0b8
	clr.w	$dff0c8
	clr.w	$dff0d8
	clr.b	MT_SONGPOS
	clr.b	MT_COUNTER
	clr.w	MT_PATTPOS
	movem.l	(sp)+,Noise_Regs
	rts

PLAY_MUSIC:
M_NOISEPLAY:	movem.l	Noise_Regs,-(sp)
	bsr	M_NOISEPLAY1
	bset	#1,$bfe001
	movem.l	(sp)+,Noise_Regs
	rts

M_NOISEPLAY1:	move.l	MusicStart,a0	;lea Soundtrack,a0
	addq.b	#$1,MT_COUNTER
	move.b	MT_COUNTER,D0
	cmp.b	MT_SPEED,D0
	blt.s	MT_NONEW
	clr.b	MT_COUNTER
	bra	MT_GETNEW

MT_NONEW:	lea	MT_VOICE1(pc),a6
	lea	$dff0a0,a5
	bsr	MT_CHECKCOM
	lea	MT_VOICE2(pc),a6
	lea	$dff0b0,a5
	bsr	MT_CHECKCOM
	lea	MT_VOICE3(pc),a6
	lea	$dff0c0,a5
	bsr	MT_CHECKCOM
	lea	MT_VOICE4(pc),a6
	lea	$dff0d0,a5
	bsr	MT_CHECKCOM
	bra	MT_ENDR

MT_ARPEGGIO:	moveq	#0,d0
	move.b	MT_COUNTER,d0
	divs	#$3,d0
	swap	d0
	cmp.w	#$0,d0
	beq.s	MT_ARP2
	cmp.w	#$2,d0
	beq.s	MT_ARP1
	moveq	#0,d0
	move.b	$3(a6),d0
	lsr.b	#4,d0
	bra.s	MT_ARP3
MT_ARP1:	moveq	#0,d0
	move.b	$3(a6),d0
	and.b	#$f,d0
	bra.s	MT_ARP3
MT_ARP2:	move.w	$10(a6),d2
	bra.s	MT_ARP4
MT_ARP3:	asl.w	#1,d0
	moveq	#0,d1
	move.w	$10(a6),d1
	lea	MT_PERIODS(pc),a0
	moveq	#$24,d7
MT_ARPLOOP:	move.w	(a0,d0.w),d2
	cmp.w	(a0),d1
	bge.s	MT_ARP4
	addq.l	#2,a0
	dbf	d7,MT_ARPLOOP
	rts
MT_ARP4:	move.w	d2,$6(a5)
	rts

MT_GETNEW:	move.l	MusicStart,a0	;lea Soundtrack,a0
	move.l	a0,a3
	move.l	a0,a2
	add.l	#$c,a3
	add.l	#$3b8,a2
	add.l	#$43c,a0
	moveq	#0,d0
	move.l	d0,d1
	move.b	MT_SONGPOS,d0
	move.b	(a2,d0.w),d1
	asl.l	#8,d1
	asl.l	#2,d1
	add.w	MT_PATTPOS,d1
	clr.w	MT_DMACON
	lea	$dff0a0,a5
	lea	MT_VOICE1(pc),a6
	bsr.s	MT_PLAYVOICE
	lea	$dff0b0,a5
	lea	MT_VOICE2(pc),a6
	bsr.s	MT_PLAYVOICE
	lea	$dff0c0,a5
	lea	MT_VOICE3(pc),a6
	bsr.s	MT_PLAYVOICE
	lea	$dff0d0,a5
	lea	MT_VOICE4(pc),a6
	bsr.s	MT_PLAYVOICE
	bra	MT_SETDMA

MT_PLAYVOICE:	move.l	(a0,d1.l),(a6)
	addq.l	#4,d1
	moveq	#0,d2
	move.b	$2(a6),d2
	and.b	#$f0,d2
	lsr.b	#4,d2
	move.b	(a6),d0
	and.b	#$f0,d0
	or.b	d0,d2
	tst.b	d2
	beq.s	MT_SETREGS
	moveq	#0,d3
	lea	MT_SAMPLESTARTS(pc),a1
	move.l	d2,d4
	subq.l	#$1,d2
	asl.l	#2,d2
	mulu	#$1e,d4
	move.l	(a1,d2.l),$4(a6)
	move.w	(a3,d4.l),$8(a6)
	move.w	$2(a3,d4.l),$12(a6)
	move.w	$4(a3,d4.l),d3
	tst.w	d3
	beq.s	MT_NOLOOP
	move.l	$4(a6),d2
	asl.w	#1,d3
	add.l	d3,d2
	move.l	d2,$a(a6)
	move.w	$4(a3,d4.l),d0
	add.w	$6(a3,d4.l),d0
	move.w	d0,8(a6)
	move.w	$6(a3,d4.l),$e(a6)
	move.w	$12(a6),$8(a5)
	bra.s	MT_SETREGS

MT_NOLOOP:	move.l	$4(a6),d2
	add.l	d3,d2
	move.l	d2,$a(a6)
	move.w	$6(a3,d4.l),$e(a6)
	move.w	$12(a6),$8(a5)
MT_SETREGS:	move.w	(a6),d0
	and.w	#$fff,d0
	beq	MT_CHECKCOM2
	move.b	$2(a6),d0
	and.b	#$F,d0
	cmp.b	#$3,d0
	bne.s	MT_SETPERIOD
	bsr	MT_SETMYPORT
	bra	MT_CHECKCOM2

MT_SETPERIOD:	move.w	(a6),$10(a6)
	and.w	#$fff,$10(a6)
	move.w	$14(a6),d0
	move.w	d0,$dff096
	clr.b	$1b(a6)
	move.l	$4(a6),(a5)
	move.w	$8(a6),$4(a5)
	move.w	$10(a6),d0
	and.w	#$fff,d0
	move.w	d0,$6(a5)
	move.w	$14(a6),d0
	or.w	d0,MT_DMACON
	bra	MT_CHECKCOM2

MT_SETDMA:	move.w	#$12c,d0
MT_WAIT:	dbf	d0,MT_WAIT
	move.w	MT_DMACON,d0
	or.w	#$8000,d0
	move.w	d0,$dff096
	move.w	#$12c,d0
MT_WAI2:	dbf	d0,MT_WAI2
	lea	$dff000,a5
	lea	MT_VOICE4(pc),a6
	move.l	$a(a6),$d0(a5)
	move.w	$e(a6),$d4(a5)
	lea	MT_VOICE3(pc),a6
	move.l	$a(a6),$c0(a5)
	move.w	$e(a6),$c4(a5)
	lea	MT_VOICE2(pc),a6
	move.l	$a(a6),$b0(a5)
	move.w	$e(a6),$b4(a5)
	lea	MT_VOICE1(pc),a6
	move.l	$a(a6),$a0(a5)
	move.w	$e(a6),$a4(a5)
	add.w	#$10,MT_PATTPOS
	cmp.w	#$400,MT_PATTPOS
	bne.s	MT_ENDR
MT_NEX:	clr.w	MT_PATTPOS
	clr.b	MT_BREAK
	addq.b	#1,MT_SONGPOS
	and.b	#$7f,MT_SONGPOS
	move.b	MT_SONGPOS,d1
	move.l	MusicStart,a0	;lea Soundtrack,a0
	cmp.b	$3b6(a0),d1
	bne.s	MT_ENDR
	move.b	$3b7(a0),MT_SONGPOS
MT_ENDR:	tst.b	MT_BREAK
	bne.s	MT_NEX
	rts

MT_SETMYPORT:	move.w	(a6),d2
	and.w	#$fff,d2
	move.w	d2,$18(a6)
	move.w	$10(a6),d0
	clr.b	$16(a6)
	cmp.w	d0,d2
	beq.s	MT_CLRPORT
	bge.s	MT_RT
	move.b	#$1,$16(a6)
	rts

MT_CLRPORT:	clr.w	$18(a6)
MT_RT:	rts

MT_MYPORT:	move.b	$3(a6),d0
	beq.s	MT_MYSLIDE
	move.b	d0,$17(a6)
	clr.b	$3(a6)
MT_MYSLIDE:	tst.w	$18(a6)
	beq.s	MT_RT
	moveq	#0,d0
	move.b	$17(a6),d0
	tst.b	$16(a6)
	bne.s	MT_MYSUB
	add.w	d0,$10(a6)
	move.w	$18(a6),d0
	cmp.w	$10(a6),d0
	bgt.s	MT_MYOK
	move.w	$18(a6),$10(a6)
	clr.w	$18(a6)
MT_MYOK:	move.w	$10(a6),$6(a5)
	rts

MT_MYSUB:	sub.w	d0,$10(a6)
	move.w	$18(a6),d0
	cmp.w	$10(a6),d0
	blt.s	MT_MYOK
	move.w	$18(a6),$10(a6)
	clr.w	$18(a6)
	move.w	$10(a6),$6(a5)
	rts

MT_VIB:	move.b	$3(a6),d0
	beq.s	MT_VI
	move.b	d0,$1a(a6)
MT_VI:	move.b	$1b(a6),d0
	lea	MT_SIN(pc),a4
	lsr.w	#$2,d0
	and.w	#$1f,d0
	moveq	#0,d2
	move.b	(a4,d0.w),d2
	move.b	$1a(a6),d0
	and.w	#$f,d0
	mulu	d0,d2
	lsr.w	#$6,d2
	move.w	$10(a6),d0
	tst.b	$1b(a6)
	bmi.s	MT_VIBMIN
	add.w	d2,d0
	bra.s	MT_VIB2

MT_VIBMIN:	sub.w	d2,d0
MT_VIB2:	move.w	d0,$6(a5)
	move.b	$1a(a6),d0
	lsr.w	#$2,d0
	and.w	#$3c,d0
	add.b	d0,$1b(a6)
	rts

MT_NOP:	move.w	$10(a6),$6(a5)
	rts

MT_CHECKCOM:	move.w	$2(a6),d0
	and.w	#$fff,d0
	beq.s	MT_NOP
	move.b	$2(a6),d0
	and.b	#$f,d0
	tst.b	d0
	beq	MT_ARPEGGIO
	cmp.b	#$1,d0
	beq.s	MT_PORTUP
	cmp.b	#$2,d0
	beq	MT_PORTDOWN
	cmp.b	#$3,d0
	beq	MT_MYPORT
	cmp.b	#$4,d0
	beq	MT_VIB
	move.w	$10(a6),$6(a5)
	cmp.b	#$a,d0
	beq.s	MT_VOLSLIDE
	rts

MT_VOLSLIDE:	moveq	#0,d0
	move.b	$3(a6),d0
	lsr.b	#4,d0
	tst.b	d0
	beq.s	MT_VOLDOWN
	add.w	d0,$12(a6)
	cmp.w	#$40,$12(a6)
	bmi.s	MT_VOL2
	move.w	#$40,$12(a6)
MT_VOL2:	move.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.w.