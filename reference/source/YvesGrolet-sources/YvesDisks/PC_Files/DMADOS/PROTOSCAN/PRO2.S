
proteclength:	EQU     28400    ;       bytes
protecsig:		EQU     $4454
protecgap:		EQU     3350
protectrack:	EQU     0


protec:
	movem.l d7/a1-a6,-(sp)
	move.l #$6ED00,A0

	bsr     protecinit
	bsr     protecstartd   ;       start drive
	bsr     protecgotot0   ;       goto track 0
	bsr     protecreadtr   ;       read track 0
	bsr     protecclear
	movem.l   (sp)+,d1-d7/a1-a6
	rts

protecinit:
	move.w  intenar,intesav
	move.w  intreqr,intrsav
	move.w  dmaconr,dmasav
	move.w  adkconr,adksav
	move.w  #$0010,dmacon
;	move.w  #$4000,intena
	move.w  #$0002,intreq
	move.w  #$7fff,adkcon
	move.w  #$8100,adkcon
	or.b    #$78,$bfd100
	rts

protecstartd:
	bclr    #7,$bfd100
	moveq   #100,d0
pst1:
	bclr    #3,$bfd100
	dbf     d0,pst1
	bsr     pwtrdy
	rts

pwtrdy:
	move.w  #3000,d6
pwt1:
	dbf     d6,pwt1
pwt2:
	btst    #5,$bfe001
	bne.s   pwt2
	rts

protecgotot0:
	btst    #4,$bfe001
	beq.s   pt0e
	bset    #1,$bfd100
	bclr    #0,$bfd100
	bset    #0,$bfd100
	bsr     pwtrdy
	bra.s   protecgotot0
pt0e:
	rts

pgototr:
	btst    #4,$bfe001
	beq.s   pgo1
	bsr     protecgotot0
	bra.s   pgototr
pgo1:
	move.w  #protectrack,d2
pgo2:
	tst.w d2
	beq.s   pgo3
	bclr    #1,$bfd100
	nop
	nop
	nop
	bclr    #0,$bfd100
	nop
	nop
	nop
	bset    #0,$bfd100
	bsr     pwtrdy
	subq.w  #1,d2
	bra.s   pgo2
pgo3:
	rts

protecreadtr:
	bsr.s   pgototr
pr2:
	bclr    #2,$bfd100   ;    set side 1
	move.w  #$8210,dmacon
	move.l  #$6ED00,dskpth
	clr.w   dsklen
	bsr     pwaitidx
	move.w  #$4000,dsklen
	move.w  #proteclength/2!$8000,dsklen
	move.w  #proteclength/2!$8000,dsklen
	move.l  #200000,d1
pr1:
	move.w  intreqr,d0
	subq.l  #1,d1
	beq.s   pr2
	btst    #1,d0
	beq.s   pr1
	move.w  #2,intreq
	rts

;	clr.w   dsklen
;	move.w  #$0010,dmacon
;	rts

pwaitidx:
	move.b  $bfdd00,d6
pidx1:
	move.b  $bfdd00,d6
	btst    #4,d6
	beq.s   pidx1
	rts

protecclear:
	bset    #7,$bfd100
	bset    #3,$bfd100
	bclr    #3,$bfd100
	move.w  intesav,d0
	bset    #15,d0
	move.w  d0,intena
;	move.w  intrsav,d0
;	bset    #15,d0
;	move.w  d0,intreq
	move.w  dmasav,d0
	bset    #15,d0
	move.w  d0,dmacon
	move.w  adksav,d0
	bset    #15,d0
	move.w  d0,adkcon
	rts

