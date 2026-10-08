
                  org	$60000

debug	set     1
asm_absolute	set     1

	include work:global/preset.s
	include work:agony/demo/dos_load.s

	lea	table,a0
	lea	$300,a1
reloc_t
	move.l	(a0)+,(a1)+
	cmp.l	#table_end,a0
	blt	reloc_t

	LOAD	FILE_0_0,$400

	lea	$400,a1
	move.l	a1,a0
	move.l	a0,-(sp)
	jmp	$80

	LOAD_CODE

buffer_disk
table
	incbin  work:agony/demo/load_data
table_end



