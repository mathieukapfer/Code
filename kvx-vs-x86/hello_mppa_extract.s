	.file	"hello_mppa_extract.c"
	.text

	.align 8
	.global papi_init
	.type	papi_init, @function
papi_init:
	make $r0 = 0x060c183007efdfbf
	;;	# (end cycle 0)
	wfxl $pmc, $r0
	;;	# (end cycle 2)
	make $r1 = 0x062c58b107efdfbf
	;;	# (end cycle 3)
	wfxl $pmc, $r1
	;;	# (end cycle 5)
	ret
	;;	# (end cycle 6)
	.size	papi_init, .-papi_init

	.align 8
	.global papi_clean
	.type	papi_clean, @function
papi_clean:
	ret
	;;	# (end cycle 0)
	.size	papi_clean, .-papi_clean
	.global __floatdisf
	.global __divdf3
	.section	.rodata.str1.8,"aMS",@progbits,1

	.align 8
.LC0:
	.string	"%6s:%6lu delta:%6lld once: %0.2f (size:%d)\n"
	.global __divdf3
	.text

	.align 8
	.global papi_display
	.type	papi_display, @function
papi_display:
	addd $r12 = $r12, -128
	get $r16 = $ra
	;;	# (end cycle 0)
	sq 32[$r12] = $r18r19
	make $r19 = 1
	make $r18 = 0
	;;	# (end cycle 1)
	sd 24[$r12] = $r14
	addw $r14 = $r19, -1
	;;	# (end cycle 2)
	so 48[$r12] = $r20r21r22r23
	zxbd $r22 = $r0
	compw.eq $r0 = $r14, 2
	zxwd $r23 = $r1
	;;	# (end cycle 3)
	so 80[$r12] = $r24r25r26r27
	make $r26 = previous.2
	make $r25 = PMC_NAME.1
	;;	# (end cycle 4)
	sd 120[$r12] = $r16
	make $r24 = .LC0
	;;	# (end cycle 5)
	sd 112[$r12] = $r28
	cb.wnez $r0? .L5
	;;	# (end cycle 6)
.L27:
	compw.eq $r21 = $r14, 3
	compw.eq $r8 = $r14, 1
	;;	# (end cycle 0)
	cb.wnez $r21? .L6
	;;	# (end cycle 2)
	cb.wnez $r8? .L7
	;;	# (end cycle 3)
	get $r11 = $pm0
	;;	# (end cycle 4)
	cb.dnez $r22? .L8
	;;	# (end cycle 5)
.L9:
	get $r33 = $pm0
	;;	# (end cycle 0)
	compw.ne $r34 = $r19, 4
	sd $r18[$r26] = $r33
	;;	# (end cycle 1)
	cb.weqz $r34? .L4
	;;	# (end cycle 3)
.L17:
	addw $r19 = $r19, 1
	addd $r18 = $r18, 8
	;;	# (end cycle 0)
	addw $r14 = $r19, -1
	;;	# (end cycle 1)
	compw.eq $r0 = $r14, 2
	;;	# (end cycle 2)
	cb.weqz $r0? .L27
	;;	# (end cycle 4)
.L5:
	get $r1 = $pm2
	;;	# (end cycle 0)
	cb.deqz $r22? .L13
	;;	# (end cycle 1)
	ld $r3 = $r18[$r26]
	;;	# (end cycle 0)
	ld $r20 = $r18[$r25]
	;;	# (end cycle 1)
	sbfd $r27 = $r3, $r1
	;;	# (end cycle 3)
	get $r21 = $pm2
	;;	# (end cycle 5)
	copyd $r0 = $r27
	call __floatdisf
	;;	# (end cycle 6)
	floatw.rn $r2 = $r23, 0
	fwidenlwd $r0 = $r0
	;;	# (end cycle 7)
	fwidenlwd $r1 = $r2
	call __divdf3
	;;	# (end cycle 11)
	fnarrowdw $r4 = $r0
	copyw $r5 = $r23
	copyd $r3 = $r27
	copyd $r2 = $r21
	;;	# (end cycle 12)
	copyd $r1 = $r20
	copyd $r0 = $r24
	fwidenlwd $r4 = $r4
	call printf
	;;	# (end cycle 13)
.L13:
	get $r5 = $pm2
	;;	# (end cycle 0)
	sd $r18[$r26] = $r5
	goto .L17
	;;	# (end cycle 1)
.L7:
	get $r9 = $pm1
	;;	# (end cycle 0)
	cb.deqz $r22? .L11
	;;	# (end cycle 1)
	ld $r10 = $r18[$r26]
	;;	# (end cycle 0)
	ld $r27 = $r18[$r25]
	;;	# (end cycle 1)
	sbfd $r20 = $r10, $r9
	;;	# (end cycle 3)
	get $r28 = $pm1
	;;	# (end cycle 5)
.L16:
	copyd $r0 = $r20
	call __floatdisf
	;;	# (end cycle 0)
	floatw.rn $r16 = $r23, 0
	fwidenlwd $r0 = $r0
	;;	# (end cycle 1)
	fwidenlwd $r1 = $r16
	call __divdf3
	;;	# (end cycle 5)
	fnarrowdw $r17 = $r0
	copyw $r5 = $r23
	copyd $r3 = $r20
	copyd $r2 = $r28
	;;	# (end cycle 6)
	copyd $r1 = $r27
	copyd $r0 = $r24
	fwidenlwd $r4 = $r17
	call printf
	;;	# (end cycle 7)
	compw.eq $r32 = $r14, 1
	cb.wnez $r21? .L15
	;;	# (end cycle 8)
	cb.weqz $r32? .L9
	;;	# (end cycle 10)
.L11:
	get $r5 = $pm1
	;;	# (end cycle 0)
	sd $r18[$r26] = $r5
	goto .L17
	;;	# (end cycle 1)
.L6:
	get $r6 = $pm3
	;;	# (end cycle 0)
	cb.deqz $r22? .L15
	;;	# (end cycle 1)
	ld $r7 = $r18[$r26]
	;;	# (end cycle 0)
	ld $r27 = $r18[$r25]
	;;	# (end cycle 1)
	sbfd $r20 = $r7, $r6
	;;	# (end cycle 3)
	get $r28 = $pm3
	;;	# (end cycle 5)
	goto .L16
	;;	# (end cycle 6)
.L15:
	get $r18 = $pm3
	;;	# (end cycle 0)
	make $r19 = previous.2
	;;	# (end cycle 1)
	sd 24[$r19] = $r18
	;;	# (end cycle 2)
.L4:
	ld $r35 = 120[$r12]
	;;	# (end cycle 0)
	ld $r14 = 24[$r12]
	;;	# (end cycle 1)
	lq $r18r19 = 32[$r12]
	;;	# (end cycle 2)
	set $ra = $r35
	;;	# (end cycle 3)
	lo $r20r21r22r23 = 48[$r12]
	;;	# (end cycle 4)
	lo $r24r25r26r27 = 80[$r12]
	;;	# (end cycle 5)
	ld $r28 = 112[$r12]
	addd $r12 = $r12, 128
	ret
	;;	# (end cycle 6)
.L8:
	ld $r15 = $r18[$r26]
	;;	# (end cycle 0)
	ld $r27 = $r18[$r25]
	;;	# (end cycle 1)
	sbfd $r20 = $r15, $r11
	;;	# (end cycle 3)
	get $r28 = $pm0
	;;	# (end cycle 5)
	goto .L16
	;;	# (end cycle 6)
	.size	papi_display, .-papi_display
	.global __divdf3
	.global __divdf3
	.global __divdf3
	.global __divdf3
	.section	.rodata.str1.8

	.align 8
.LC1:
	.string	"%ld[%d] KO: %d != %d + %d, \n"
	.section	.text.startup,"ax",@progbits

	.align 8
	.global main
	.type	main, @function
main:
	addd $r12 = $r12, -160
	make $r63 = 0
	get $r16 = $ra
	;;	# (end cycle 0)
	so 48[$r12] = $r20r21r22r23
	make $r21 = r_
	make $r40 = 1
	copyd $r62 = $r63
	;;	# (end cycle 1)
	so 80[$r12] = $r24r25r26r27
	copyd $r61 = $r63
	copyd $r25 = $r21
	copyd $r60 = $r63
	;;	# (end cycle 2)
	sq 32[$r12] = $r18r19
	copyd $r59 = $r63
	make $r19 = a_
	make $r18 = b_
	;;	# (end cycle 3)
	copyd $r58 = $r63
	copyd $r57 = $r63
	copyd $r56 = $r63
	copyd $r55 = $r63
	;;	# (end cycle 4)
	copyd $r54 = $r63
	copyd $r53 = $r63
	copyd $r51 = $r63
	copyd $r49 = $r63
	;;	# (end cycle 5)
	copyd $r52 = $r63
	copyd $r26 = $r63
	copyw $r39 = $r63
	make $r22 = 0x0001000100010001
	;;	# (end cycle 6)
	make $r23 = 0x0001000100010001
	make $r27 = 130
	sd 24[$r12] = $r14
	;;	# (end cycle 7)
	so 112[$r12] = $r28r29r30r31
	;;	# (end cycle 8)
	sd 144[$r12] = $r16
	;;	# (end cycle 9)
	loopdo $r27, .L72
	;;	# (end cycle 10)
.L29:
	slld $r0 = $r26, 5
	addw $r42 = $r26, 1
	addw $r41 = $r52, 1
	addw $r38 = $r49, 1
	;;	# (end cycle 0)
	addd $r1 = $r19, $r0
	addd $r43 = $r18, $r0
	addw $r37 = $r51, 1
	addw $r36 = $r53, 1
	;;	# (end cycle 1)
	addw $r35 = $r54, 1
	addw $r34 = $r55, 1
	addw $r33 = $r56, 1
	addw $r32 = $r57, 1
	;;	# (end cycle 2)
	addw $r31 = $r58, 1
	addw $r30 = $r59, 1
	addw $r29 = $r60, 1
	addw $r28 = $r61, 1
	;;	# (end cycle 3)
	addw $r9 = $r62, 1
	addw $r8 = $r63, 1
	sh 2[$r1] = $r26
	addw $r3 = $r49, 3
	;;	# (end cycle 4)
	sh 4[$r1] = $r52
	addw $r4 = $r51, 4
	addw $r24 = $r52, 2
	addw $r5 = $r53, 5
	;;	# (end cycle 5)
	sh 6[$r1] = $r49
	addw $r6 = $r54, 6
	addw $r7 = $r55, 7
	addw $r10 = $r56, 8
	;;	# (end cycle 6)
	sh 8[$r1] = $r51
	addw $r11 = $r57, 9
	addw $r14 = $r58, 10
	addw $r15 = $r59, 11
	;;	# (end cycle 7)
	sh 10[$r1] = $r53
	addw $r16 = $r60, 12
	addw $r17 = $r61, 13
	addw $r20 = $r62, 14
	;;	# (end cycle 8)
	sh 12[$r1] = $r54
	addw $r2 = $r63, 15
	addd $r26 = $r26, 1
	zxhd $r52 = $r24
	;;	# (end cycle 9)
	sh 14[$r1] = $r55
	zxhd $r53 = $r5
	zxhd $r54 = $r6
	addd $r25 = $r25, 32
	;;	# (end cycle 10)
	sh 16[$r1] = $r56
	zxhd $r55 = $r7
	zxhd $r56 = $r10
	;;	# (end cycle 11)
	sh 18[$r1] = $r57
	zxhd $r57 = $r11
	;;	# (end cycle 12)
	sh 20[$r1] = $r58
	zxhd $r58 = $r14
	;;	# (end cycle 13)
	sh 22[$r1] = $r59
	zxhd $r59 = $r15
	;;	# (end cycle 14)
	sh 24[$r1] = $r60
	zxhd $r60 = $r16
	;;	# (end cycle 15)
	sh 26[$r1] = $r61
	zxhd $r61 = $r17
	;;	# (end cycle 16)
	sh 28[$r1] = $r62
	zxhd $r62 = $r20
	;;	# (end cycle 17)
	sh 30[$r1] = $r63
	zxhd $r63 = $r2
	;;	# (end cycle 18)
	sh $r0[$r19] = $r39
	;;	# (end cycle 19)
	sh $r0[$r18] = $r40
	;;	# (end cycle 20)
	sh 2[$r43] = $r42
	;;	# (end cycle 21)
	sh 4[$r43] = $r41
	;;	# (end cycle 22)
	sh 6[$r43] = $r38
	;;	# (end cycle 23)
	sh 8[$r43] = $r37
	;;	# (end cycle 24)
	sh 10[$r43] = $r36
	;;	# (end cycle 25)
	sh 12[$r43] = $r35
	;;	# (end cycle 26)
	sh 14[$r43] = $r34
	;;	# (end cycle 27)
	sh 16[$r43] = $r33
	;;	# (end cycle 28)
	sh 18[$r43] = $r32
	;;	# (end cycle 29)
	sh 20[$r43] = $r31
	;;	# (end cycle 30)
	sh 22[$r43] = $r30
	;;	# (end cycle 31)
	sh 24[$r43] = $r29
	;;	# (end cycle 32)
	sh 26[$r43] = $r28
	;;	# (end cycle 33)
	sh 28[$r43] = $r9
	;;	# (end cycle 34)
	sh 30[$r43] = $r8
	;;	# (end cycle 35)
	lq $r44r45 = -16[$r25]
	;;	# (end cycle 36)
	lq $r46r47 = -32[$r25]
	;;	# (end cycle 37)
	addhq $r48 = $r44, $r22
	addhq $r49 = $r45, $r23
	;;	# (end cycle 39)
	addhq $r50 = $r46, $r22
	addhq $r51 = $r47, $r23
	sq -16[$r25] = $r48r49
	zxhd $r49 = $r3
	;;	# (end cycle 40)
	sq -32[$r25] = $r50r51
	zxhd $r51 = $r4
	;;	# (end cycle 41)
	# loopdo end
.L72:
	make $r22 = 0x060c183007efdfbf
	;;	# (end cycle 0)
	wfxl $pmc, $r22
	;;	# (end cycle 2)
	make $r23 = 0x062c58b107efdfbf
	;;	# (end cycle 3)
	wfxl $pmc, $r23
	;;	# (end cycle 5)
	make $r45 = 3
	make $r22 = previous.2
	addd $r20 = $r21, 0x0000000000001040
	;;	# (end cycle 6)
	sd 152[$r12] = $r45
	make $r25 = 0x4060400000000000
	make $r24 = .LC0
	;;	# (end cycle 7)
	make $r14 = .LC1
	;;	# (end cycle 8)
.L55:
	make $r47 = 0x0646810007efdfbf
	;;	# (end cycle 0)
	wfxl $pmc, $r47
	;;	# (end cycle 2)
	make $r15 = 0
	make $r27 = 13
	;;	# (end cycle 3)
	loopdo $r27, .L71
	;;	# (end cycle 4)
.L30:
	addd $r31 = $r15, 32
	lo $r4r5r6r7 = $r15[$r19]
	addd $r30 = $r15, 64
	addd $r28 = $r15, 96
	;;	# (end cycle 0)
	lo $r8r9r10r11 = $r15[$r18]
	addd $r29 = $r15, 192
	addd $r17 = $r15, 128
	addd $r16 = $r15, 160
	;;	# (end cycle 1)
	lo $r32r33r34r35 = $r31[$r18]
	addd $r26 = $r15, 224
	;;	# (end cycle 2)
	lo $r0r1r2r3 = $r31[$r19]
	;;	# (end cycle 3)
	addhq $r60 = $r4, $r8
	addhq $r61 = $r5, $r9
	addhq $r62 = $r6, $r10
	addhq $r63 = $r7, $r11
	;;	# (end cycle 4)
	lo $r48r49r50r51 = $r28[$r18]
	;;	# (end cycle 5)
	lo $r40r41r42r43 = $r30[$r18]
	;;	# (end cycle 6)
	so $r15[$r21] = $r60r61r62r63
	;;	# (end cycle 7)
	addhq $r0 = $r0, $r32
	addhq $r1 = $r1, $r33
	addhq $r2 = $r2, $r34
	addhq $r3 = $r3, $r35
	;;	# (end cycle 8)
	lo $r60r61r62r63 = $r29[$r19]
	;;	# (end cycle 9)
	lo $r32r33r34r35 = $r29[$r18]
	;;	# (end cycle 10)
	lo $r36r37r38r39 = $r30[$r19]
	;;	# (end cycle 11)
	lo $r44r45r46r47 = $r28[$r19]
	;;	# (end cycle 12)
	lo $r56r57r58r59 = $r17[$r18]
	;;	# (end cycle 13)
	lo $r8r9r10r11 = $r16[$r18]
	;;	# (end cycle 14)
	lo $r52r53r54r55 = $r17[$r19]
	;;	# (end cycle 15)
	lo $r4r5r6r7 = $r16[$r19]
	;;	# (end cycle 16)
	addhq $r44 = $r44, $r48
	addhq $r45 = $r45, $r49
	addhq $r46 = $r46, $r50
	addhq $r47 = $r47, $r51
	;;	# (end cycle 17)
	addhq $r36 = $r36, $r40
	addhq $r37 = $r37, $r41
	addhq $r38 = $r38, $r42
	addhq $r39 = $r39, $r43
	;;	# (end cycle 18)
	addd $r50 = $r15, 256
	addd $r49 = $r15, 288
	so $r31[$r21] = $r0r1r2r3
	addd $r15 = $r15, 320
	;;	# (end cycle 19)
	addhq $r0 = $r60, $r32
	addhq $r1 = $r61, $r33
	addhq $r2 = $r62, $r34
	addhq $r3 = $r63, $r35
	;;	# (end cycle 20)
	so $r30[$r21] = $r36r37r38r39
	;;	# (end cycle 21)
	so $r28[$r21] = $r44r45r46r47
	;;	# (end cycle 22)
	lo $r36r37r38r39 = $r26[$r19]
	;;	# (end cycle 23)
	addhq $r52 = $r52, $r56
	addhq $r53 = $r53, $r57
	addhq $r54 = $r54, $r58
	addhq $r55 = $r55, $r59
	;;	# (end cycle 24)
	addhq $r4 = $r4, $r8
	addhq $r5 = $r5, $r9
	addhq $r6 = $r6, $r10
	addhq $r7 = $r7, $r11
	;;	# (end cycle 25)
	so $r29[$r21] = $r0r1r2r3
	;;	# (end cycle 26)
	lo $r40r41r42r43 = $r26[$r18]
	;;	# (end cycle 27)
	lo $r44r45r46r47 = $r50[$r19]
	;;	# (end cycle 28)
	lo $r8r9r10r11 = $r49[$r19]
	;;	# (end cycle 29)
	lo $r56r57r58r59 = $r49[$r18]
	;;	# (end cycle 30)
	lo $r28r29r30r31 = $r50[$r18]
	;;	# (end cycle 31)
	addhq $r60 = $r36, $r40
	addhq $r61 = $r37, $r41
	addhq $r62 = $r38, $r42
	addhq $r63 = $r39, $r43
	;;	# (end cycle 32)
	addhq $r36 = $r8, $r56
	addhq $r37 = $r9, $r57
	addhq $r38 = $r10, $r58
	addhq $r39 = $r11, $r59
	;;	# (end cycle 33)
	addhq $r32 = $r44, $r28
	addhq $r33 = $r45, $r29
	addhq $r34 = $r46, $r30
	addhq $r35 = $r47, $r31
	;;	# (end cycle 34)
	so $r17[$r21] = $r52r53r54r55
	;;	# (end cycle 35)
	so $r16[$r21] = $r4r5r6r7
	;;	# (end cycle 36)
	so $r26[$r21] = $r60r61r62r63
	;;	# (end cycle 37)
	so $r50[$r21] = $r32r33r34r35
	;;	# (end cycle 38)
	so $r49[$r21] = $r36r37r38r39
	;;	# (end cycle 39)
	# loopdo end
.L71:
	make $r39 = 0x060c183007efdfbf
	;;	# (end cycle 0)
	wfxl $pmc, $r39
	;;	# (end cycle 2)
	make $r30 = 1
	make $r29 = 0
	;;	# (end cycle 3)
	addw $r42 = $r30, -1
	;;	# (end cycle 4)
	compw.eq $r41 = $r42, 2
	compw.eq $r38 = $r42, 3
	compw.eq $r37 = $r42, 1
	;;	# (end cycle 5)
	cb.wnez $r41? .L31
	;;	# (end cycle 7)
.L70:
	cb.wnez $r38? .L32
	;;	# (end cycle 0)
	cb.wnez $r37? .L33
	;;	# (end cycle 1)
	get $r2 = $pm0
	;;	# (end cycle 2)
	ld $r53 = $r29[$r22]
	make $r54 = PMC_NAME.1
	;;	# (end cycle 3)
	ld $r28 = $r29[$r54]
	;;	# (end cycle 4)
	sbfd $r26 = $r53, $r2
	;;	# (end cycle 6)
	get $r27 = $pm0
	;;	# (end cycle 8)
	copyd $r0 = $r26
	call __floatdisf
	;;	# (end cycle 9)
	copyd $r1 = $r25
	fwidenlwd $r0 = $r0
	call __divdf3
	;;	# (end cycle 10)
	fnarrowdw $r55 = $r0
	make $r5 = 130
	copyd $r3 = $r26
	copyd $r2 = $r27
	;;	# (end cycle 11)
	copyd $r1 = $r28
	fwidenlwd $r4 = $r55
	copyd $r0 = $r24
	call printf
	;;	# (end cycle 12)
	get $r57 = $pm0
	;;	# (end cycle 14)
	compw.ne $r58 = $r30, 4
	sd $r29[$r22] = $r57
	;;	# (end cycle 15)
	cb.weqz $r58? .L35
	;;	# (end cycle 17)
.L34:
	addw $r30 = $r30, 1
	addd $r29 = $r29, 8
	;;	# (end cycle 0)
	addw $r42 = $r30, -1
	;;	# (end cycle 1)
	compw.eq $r41 = $r42, 2
	compw.eq $r38 = $r42, 3
	compw.eq $r37 = $r42, 1
	;;	# (end cycle 2)
	cb.weqz $r41? .L70
	;;	# (end cycle 4)
.L31:
	get $r43 = $pm2
	;;	# (end cycle 0)
	ld $r35 = $r29[$r22]
	make $r1 = PMC_NAME.1
	;;	# (end cycle 1)
	ld $r27 = $r29[$r1]
	;;	# (end cycle 2)
	sbfd $r31 = $r35, $r43
	;;	# (end cycle 4)
	get $r23 = $pm2
	;;	# (end cycle 6)
	copyd $r0 = $r31
	call __floatdisf
	;;	# (end cycle 7)
	copyd $r1 = $r25
	fwidenlwd $r0 = $r0
	call __divdf3
	;;	# (end cycle 8)
	fnarrowdw $r34 = $r0
	make $r5 = 130
	copyd $r3 = $r31
	copyd $r2 = $r23
	;;	# (end cycle 9)
	copyd $r1 = $r27
	fwidenlwd $r4 = $r34
	copyd $r0 = $r24
	call printf
	;;	# (end cycle 10)
	get $r33 = $pm2
	;;	# (end cycle 12)
	sd $r29[$r22] = $r33
	goto .L34
	;;	# (end cycle 13)
.L32:
	get $r9 = $pm3
	;;	# (end cycle 0)
	ld $r46 = $r29[$r22]
	make $r3 = PMC_NAME.1
	;;	# (end cycle 1)
	ld $r26 = $r29[$r3]
	;;	# (end cycle 2)
	sbfd $r30 = $r46, $r9
	;;	# (end cycle 4)
	get $r28 = $pm3
	;;	# (end cycle 6)
	copyd $r0 = $r30
	call __floatdisf
	;;	# (end cycle 7)
	copyd $r1 = $r25
	fwidenlwd $r0 = $r0
	call __divdf3
	;;	# (end cycle 8)
	fnarrowdw $r6 = $r0
	copyd $r3 = $r30
	copyd $r2 = $r28
	copyd $r1 = $r26
	;;	# (end cycle 9)
	fwidenlwd $r4 = $r6
	make $r5 = 130
	copyd $r0 = $r24
	call printf
	;;	# (end cycle 10)
	get $r5 = $pm3
	;;	# (end cycle 12)
	sd $r29[$r22] = $r5
	;;	# (end cycle 13)
.L35:
	make $r31 = a_
	make $r30 = b_
	copyd $r29 = $r21
	make $r28 = 0
	;;	# (end cycle 0)
.L54:
	lhs $r59 = 0[$r31]
	copyd $r27 = $r29
	copyd $r23 = $r31
	copyd $r26 = $r30
	;;	# (end cycle 0)
	lhs $r61 = 0[$r30]
	;;	# (end cycle 1)
	lhs $r62 = 0[$r29]
	;;	# (end cycle 2)
	zxwd $r4 = $r59
	;;	# (end cycle 3)
	addw $r63 = $r61, $r59
	zxwd $r5 = $r61
	;;	# (end cycle 4)
	compw.eq $r45 = $r63, $r62
	zxwd $r3 = $r62
	;;	# (end cycle 5)
	cb.wnez $r45? .L38
	;;	# (end cycle 7)
	make $r2 = 0
	copyd $r1 = $r28
	copyd $r0 = $r14
	call printf
	;;	# (end cycle 0)
.L38:
	lhs $r47 = 2[$r23]
	;;	# (end cycle 0)
	lhs $r17 = 2[$r26]
	;;	# (end cycle 1)
	lhs $r48 = 2[$r27]
	;;	# (end cycle 2)
	zxwd $r4 = $r47
	;;	# (end cycle 3)
	addw $r16 = $r17, $r47
	zxwd $r5 = $r17
	;;	# (end cycle 4)
	compw.eq $r50 = $r16, $r48
	zxwd $r3 = $r48
	;;	# (end cycle 5)
	cb.wnez $r50? .L39
	;;	# (end cycle 7)
	make $r2 = 1
	copyd $r1 = $r28
	copyd $r0 = $r14
	call printf
	;;	# (end cycle 0)
.L39:
	lhs $r40 = 4[$r23]
	;;	# (end cycle 0)
	lhs $r52 = 4[$r26]
	;;	# (end cycle 1)
	lhs $r49 = 4[$r27]
	;;	# (end cycle 2)
	zxwd $r4 = $r40
	;;	# (end cycle 3)
	addw $r44 = $r52, $r40
	zxwd $r5 = $r52
	;;	# (end cycle 4)
	compw.eq $r8 = $r44, $r49
	zxwd $r3 = $r49
	;;	# (end cycle 5)
	cb.wnez $r8? .L40
	;;	# (end cycle 7)
	make $r2 = 2
	copyd $r1 = $r28
	copyd $r0 = $r14
	call printf
	;;	# (end cycle 0)
.L40:
	lhs $r4 = 6[$r23]
	;;	# (end cycle 0)
	lhs $r56 = 6[$r26]
	;;	# (end cycle 1)
	lhs $r15 = 6[$r27]
	;;	# (end cycle 2)
	addw $r0 = $r56, $r4
	zxwd $r5 = $r56
	zxwd $r4 = $r4
	;;	# (end cycle 4)
	compw.eq $r60 = $r0, $r15
	zxwd $r3 = $r15
	;;	# (end cycle 5)
	cb.wnez $r60? .L41
	;;	# (end cycle 7)
	make $r2 = 3
	copyd $r1 = $r28
	copyd $r0 = $r14
	call printf
	;;	# (end cycle 0)
.L41:
	lhs $r32 = 8[$r23]
	;;	# (end cycle 0)
	lhs $r36 = 8[$r26]
	;;	# (end cycle 1)
	lhs $r39 = 8[$r27]
	;;	# (end cycle 2)
	zxwd $r4 = $r32
	;;	# (end cycle 3)
	addw $r42 = $r36, $r32
	zxwd $r5 = $r36
	;;	# (end cycle 4)
	compw.eq $r41 = $r42, $r39
	zxwd $r3 = $r39
	;;	# (end cycle 5)
	cb.wnez $r41? .L42
	;;	# (end cycle 7)
	make $r2 = 4
	copyd $r1 = $r28
	copyd $r0 = $r14
	call printf
	;;	# (end cycle 0)
.L42:
	lhs $r38 = 10[$r23]
	;;	# (end cycle 0)
	lhs $r37 = 10[$r26]
	;;	# (end cycle 1)
	lhs $r43 = 10[$r27]
	;;	# (end cycle 2)
	zxwd $r4 = $r38
	;;	# (end cycle 3)
	addw $r35 = $r37, $r38
	zxwd $r5 = $r37
	;;	# (end cycle 4)
	compw.eq $r1 = $r35, $r43
	zxwd $r3 = $r43
	;;	# (end cycle 5)
	cb.wnez $r1? .L43
	;;	# (end cycle 7)
	make $r2 = 5
	copyd $r1 = $r28
	copyd $r0 = $r14
	call printf
	;;	# (end cycle 0)
.L43:
	lhs $r34 = 12[$r23]
	;;	# (end cycle 0)
	lhs $r33 = 12[$r26]
	;;	# (end cycle 1)
	lhs $r9 = 12[$r27]
	;;	# (end cycle 2)
	zxwd $r4 = $r34
	;;	# (end cycle 3)
	addw $r46 = $r33, $r34
	zxwd $r5 = $r33
	;;	# (end cycle 4)
	compw.eq $r6 = $r46, $r9
	zxwd $r3 = $r9
	;;	# (end cycle 5)
	cb.wnez $r6? .L44
	;;	# (end cycle 7)
	make $r2 = 6
	copyd $r1 = $r28
	copyd $r0 = $r14
	call printf
	;;	# (end cycle 0)
.L44:
	lhs $r7 = 14[$r23]
	;;	# (end cycle 0)
	lhs $r5 = 14[$r26]
	;;	# (end cycle 1)
	lhs $r10 = 14[$r27]
	;;	# (end cycle 2)
	zxwd $r4 = $r7
	;;	# (end cycle 3)
	addw $r11 = $r5, $r7
	zxwd $r5 = $r5
	;;	# (end cycle 4)
	compw.eq $r51 = $r11, $r10
	zxwd $r3 = $r10
	;;	# (end cycle 5)
	cb.wnez $r51? .L45
	;;	# (end cycle 7)
	make $r2 = 7
	copyd $r1 = $r28
	copyd $r0 = $r14
	call printf
	;;	# (end cycle 0)
.L45:
	lhs $r53 = 16[$r23]
	;;	# (end cycle 0)
	lhs $r54 = 16[$r26]
	;;	# (end cycle 1)
	lhs $r2 = 16[$r27]
	;;	# (end cycle 2)
	zxwd $r4 = $r53
	;;	# (end cycle 3)
	addw $r55 = $r54, $r53
	zxwd $r5 = $r54
	;;	# (end cycle 4)
	compw.eq $r57 = $r55, $r2
	zxwd $r3 = $r2
	;;	# (end cycle 5)
	cb.wnez $r57? .L46
	;;	# (end cycle 7)
	make $r2 = 8
	copyd $r1 = $r28
	copyd $r0 = $r14
	call printf
	;;	# (end cycle 0)
.L46:
	lhs $r58 = 18[$r23]
	;;	# (end cycle 0)
	lhs $r59 = 18[$r26]
	;;	# (end cycle 1)
	lhs $r61 = 18[$r27]
	;;	# (end cycle 2)
	zxwd $r4 = $r58
	;;	# (end cycle 3)
	addw $r62 = $r59, $r58
	zxwd $r5 = $r59
	;;	# (end cycle 4)
	compw.eq $r63 = $r62, $r61
	zxwd $r3 = $r61
	;;	# (end cycle 5)
	cb.wnez $r63? .L47
	;;	# (end cycle 7)
	make $r2 = 9
	copyd $r1 = $r28
	copyd $r0 = $r14
	call printf
	;;	# (end cycle 0)
.L47:
	lhs $r45 = 20[$r23]
	;;	# (end cycle 0)
	lhs $r47 = 20[$r26]
	;;	# (end cycle 1)
	lhs $r17 = 20[$r27]
	;;	# (end cycle 2)
	zxwd $r4 = $r45
	;;	# (end cycle 3)
	addw $r48 = $r47, $r45
	zxwd $r5 = $r47
	;;	# (end cycle 4)
	compw.eq $r16 = $r48, $r17
	zxwd $r3 = $r17
	;;	# (end cycle 5)
	cb.wnez $r16? .L48
	;;	# (end cycle 7)
	make $r2 = 10
	copyd $r1 = $r28
	copyd $r0 = $r14
	call printf
	;;	# (end cycle 0)
.L48:
	lhs $r50 = 22[$r23]
	;;	# (end cycle 0)
	lhs $r40 = 22[$r26]
	;;	# (end cycle 1)
	lhs $r52 = 22[$r27]
	;;	# (end cycle 2)
	zxwd $r4 = $r50
	;;	# (end cycle 3)
	addw $r49 = $r40, $r50
	zxwd $r5 = $r40
	;;	# (end cycle 4)
	compw.eq $r44 = $r49, $r52
	zxwd $r3 = $r52
	;;	# (end cycle 5)
	cb.wnez $r44? .L49
	;;	# (end cycle 7)
	make $r2 = 11
	copyd $r1 = $r28
	copyd $r0 = $r14
	call printf
	;;	# (end cycle 0)
.L49:
	lhs $r8 = 24[$r23]
	;;	# (end cycle 0)
	lhs $r56 = 24[$r26]
	;;	# (end cycle 1)
	lhs $r15 = 24[$r27]
	;;	# (end cycle 2)
	zxwd $r4 = $r8
	;;	# (end cycle 3)
	addw $r0 = $r56, $r8
	zxwd $r5 = $r56
	;;	# (end cycle 4)
	compw.eq $r60 = $r0, $r15
	zxwd $r3 = $r15
	;;	# (end cycle 5)
	cb.wnez $r60? .L50
	;;	# (end cycle 7)
	make $r2 = 12
	copyd $r1 = $r28
	copyd $r0 = $r14
	call printf
	;;	# (end cycle 0)
.L50:
	lhs $r4 = 26[$r23]
	;;	# (end cycle 0)
	lhs $r32 = 26[$r26]
	;;	# (end cycle 1)
	lhs $r36 = 26[$r27]
	;;	# (end cycle 2)
	addw $r39 = $r32, $r4
	zxwd $r5 = $r32
	zxwd $r4 = $r4
	;;	# (end cycle 4)
	compw.eq $r42 = $r39, $r36
	zxwd $r3 = $r36
	;;	# (end cycle 5)
	cb.wnez $r42? .L51
	;;	# (end cycle 7)
	make $r2 = 13
	copyd $r1 = $r28
	copyd $r0 = $r14
	call printf
	;;	# (end cycle 0)
.L51:
	lhs $r41 = 28[$r23]
	;;	# (end cycle 0)
	lhs $r38 = 28[$r26]
	;;	# (end cycle 1)
	lhs $r37 = 28[$r27]
	;;	# (end cycle 2)
	zxwd $r4 = $r41
	;;	# (end cycle 3)
	addw $r43 = $r38, $r41
	zxwd $r5 = $r38
	;;	# (end cycle 4)
	compw.eq $r35 = $r43, $r37
	zxwd $r3 = $r37
	;;	# (end cycle 5)
	cb.wnez $r35? .L52
	;;	# (end cycle 7)
	make $r2 = 14
	copyd $r1 = $r28
	copyd $r0 = $r14
	call printf
	;;	# (end cycle 0)
.L52:
	lhs $r23 = 30[$r23]
	;;	# (end cycle 0)
	lhs $r26 = 30[$r26]
	;;	# (end cycle 1)
	lhs $r27 = 30[$r27]
	;;	# (end cycle 2)
	zxwd $r4 = $r23
	;;	# (end cycle 3)
	addw $r1 = $r26, $r23
	zxwd $r5 = $r26
	;;	# (end cycle 4)
	compw.eq $r34 = $r1, $r27
	zxwd $r3 = $r27
	;;	# (end cycle 5)
	cb.wnez $r34? .L53
	;;	# (end cycle 7)
	make $r2 = 15
	copyd $r1 = $r28
	copyd $r0 = $r14
	call printf
	;;	# (end cycle 0)
.L53:
	addd $r29 = $r29, 32
	addd $r28 = $r28, 1
	addd $r31 = $r31, 32
	addd $r30 = $r30, 32
	;;	# (end cycle 0)
	compd.ne $r3 = $r20, $r29
	;;	# (end cycle 1)
	cb.dnez $r3? .L54
	;;	# (end cycle 3)
	ld $r33 = 152[$r12]
	;;	# (end cycle 0)
	addw $r0 = $r33, -1
	;;	# (end cycle 3)
	sd 152[$r12] = $r0
	;;	# (end cycle 4)
	cb.dnez $r0? .L55
	;;	# (end cycle 5)
	ld $r9 = 144[$r12]
	;;	# (end cycle 0)
	ld $r14 = 24[$r12]
	;;	# (end cycle 1)
	lq $r18r19 = 32[$r12]
	;;	# (end cycle 2)
	set $ra = $r9
	;;	# (end cycle 3)
	lo $r20r21r22r23 = 48[$r12]
	;;	# (end cycle 4)
	lo $r24r25r26r27 = 80[$r12]
	;;	# (end cycle 5)
	lo $r28r29r30r31 = 112[$r12]
	addd $r12 = $r12, 160
	ret
	;;	# (end cycle 6)
.L33:
	get $r7 = $pm1
	;;	# (end cycle 0)
	ld $r10 = $r29[$r22]
	make $r11 = PMC_NAME.1
	;;	# (end cycle 1)
	ld $r27 = $r29[$r11]
	;;	# (end cycle 2)
	sbfd $r31 = $r10, $r7
	;;	# (end cycle 4)
	get $r23 = $pm1
	;;	# (end cycle 6)
	copyd $r0 = $r31
	call __floatdisf
	;;	# (end cycle 7)
	copyd $r1 = $r25
	fwidenlwd $r0 = $r0
	call __divdf3
	;;	# (end cycle 8)
	fnarrowdw $r51 = $r0
	make $r5 = 130
	copyd $r3 = $r31
	copyd $r2 = $r23
	;;	# (end cycle 9)
	copyd $r1 = $r27
	fwidenlwd $r4 = $r51
	copyd $r0 = $r24
	call printf
	;;	# (end cycle 10)
	get $r33 = $pm1
	;;	# (end cycle 12)
	sd $r29[$r22] = $r33
	goto .L34
	;;	# (end cycle 13)
	.size	main, .-main
	.section	.rodata.str1.8

	.align 8
.LC2:
	.string	"PCC"

	.align 8
.LC3:
	.string	"EBE"

	.align 8
.LC4:
	.string	"DARSC"

	.align 8
.LC5:
	.string	"FSC"
	.section	.rodata

	.align 8
	.type	PMC_NAME.1, @object
	.size	PMC_NAME.1, 32
PMC_NAME.1:
	.8byte	.LC2
	.8byte	.LC3
	.8byte	.LC4
	.8byte	.LC5
	.local	previous.2
	.comm	previous.2,32,8
	.global r_
	.section .bss

	.align 32
	.type	r_, @object
	.size	r_, 4160
r_:
	.zero	4160
	.global b_

	.align 32
	.type	b_, @object
	.size	b_, 4160
b_:
	.zero	4160
	.global a_

	.align 32
	.type	a_, @object
	.size	a_, 4160
a_:
	.zero	4160
	.ident	"GCC: (GNU) 10.3.1 20211129 [Kalray Compiler 4.10.0-2.bb018026cf bb018026c-dirty]"
