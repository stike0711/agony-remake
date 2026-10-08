
	section	chip,code_f

debug	set     1
asm_absolute	set	0

	include work:global/preset.s

	include work:agony/demo/dos_load.s

	lea	Custom,a0
	move	#$7fff,d0
	move	d0,Dmacon(a0)
	move	d0,Intena(a0)
	move	d0,Intreq(a0)
	move	d0,Adkcon(a0)
	clr.l	Cop1lc(a0)
	move	d0,Copjmp1(a0)
                  lea     $f0000,sp
	move.l	#sup,$20.w
sup
	move.w	#$2700,sr
                  lea     $f0000,sp

	lea	table,a0
	lea	$300,a1
reloc_t
	move.l	(a0)+,(a1)+
	cmp.l	#table_end,a0
	blt	reloc_t
	lea	dec,a0
	lea	$80,a1
reloc_d
	move.l	(a0)+,(a1)+
	cmp.l	#dec_end,a0
	blt	reloc_d

	LOAD	FILE_0_4,$400

	lea	$400,a1
	lea	$31500,a0
	jsr	$80
	jmp	$31500

	LOAD_CODE

buffer_disk	EQU	$f0000
table
	incbin  work:agony/demo/load_data
table_end
dec
                  incbin	work:agony/demo/decrunch.bin
dec_end



