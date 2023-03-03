	.file	"hello_mppa.c"
	.text
	.section	.rodata.str1.8,"aMS",@progbits,1

	.align 8
.LC0:
	.string	"took %lld \n"
	.section	.text.startup,"ax",@progbits

	.align 8
	.global main
	.type	main, @function
main:
	addd $r12 = $r12, -64
	get $r16 = $ra
	;;	# (end cycle 0)
	sq 32[$r12] = $r18r19
	make $r19 = 0xa3d70a3d70a3d70b
	make $r18 = .LC0
	;;	# (end cycle 1)
	sd 24[$r12] = $r14
	make $r14 = 10
	;;	# (end cycle 2)
	sd 56[$r12] = $r16
	;;	# (end cycle 3)
	sd 48[$r12] = $r20
	;;	# (end cycle 4)
.L3:
	call PAPI_get_real_cyc
	;;	# (end cycle 0)
	make $r1 = test_vec
	make $r2 = 10
	copyd $r20 = $r0
	;;	# (end cycle 1)
	loopdo $r2, .L16
	;;	# (end cycle 2)
.L2:
	lo $r32r33r34r35 = 32[$r1]
	addd $r0 = $r1, 128
	addd $r16 = $r1, 256
	addd $r15 = $r1, 384
	;;	# (end cycle 0)
	lo $r8r9r10r11 = 0[$r1]
	addd $r1 = $r1, 0x0000000000000500
	;;	# (end cycle 1)
	lo $r4r5r6r7 = -1152[$r1]
	;;	# (end cycle 2)
	lo $r40r41r42r43 = 32[$r0]
	;;	# (end cycle 3)
	addhq $r36 = $r8, $r32
	addhq $r37 = $r9, $r33
	addhq $r38 = $r10, $r34
	addhq $r39 = $r11, $r35
	;;	# (end cycle 4)
	lo $r52r53r54r55 = -1024[$r1]
	;;	# (end cycle 5)
	addhq $r44 = $r4, $r40
	addhq $r45 = $r5, $r41
	addhq $r46 = $r6, $r42
	addhq $r47 = $r7, $r43
	;;	# (end cycle 6)
	lo $r8r9r10r11 = -896[$r1]
	;;	# (end cycle 7)
	lo $r4r5r6r7 = -768[$r1]
	;;	# (end cycle 8)
	so -1216[$r1] = $r36r37r38r39
	;;	# (end cycle 9)
	lo $r48r49r50r51 = 32[$r16]
	;;	# (end cycle 10)
	lo $r36r37r38r39 = 416[$r0]
	;;	# (end cycle 11)
	lo $r60r61r62r63 = 32[$r15]
	;;	# (end cycle 12)
	addhq $r56 = $r52, $r48
	addhq $r57 = $r53, $r49
	addhq $r58 = $r54, $r50
	addhq $r59 = $r55, $r51
	;;	# (end cycle 13)
	addhq $r40 = $r4, $r36
	addhq $r41 = $r5, $r37
	addhq $r42 = $r6, $r38
	addhq $r43 = $r7, $r39
	;;	# (end cycle 14)
	addhq $r32 = $r8, $r60
	addhq $r33 = $r9, $r61
	addhq $r34 = $r10, $r62
	addhq $r35 = $r11, $r63
	;;	# (end cycle 15)
	lo $r4r5r6r7 = -512[$r1]
	;;	# (end cycle 16)
	lo $r36r37r38r39 = -480[$r1]
	;;	# (end cycle 17)
	so 64[$r0] = $r44r45r46r47
	;;	# (end cycle 18)
	so 64[$r16] = $r56r57r58r59
	;;	# (end cycle 19)
	so 64[$r15] = $r32r33r34r35
	;;	# (end cycle 20)
	so 448[$r0] = $r40r41r42r43
	;;	# (end cycle 21)
	lo $r32r33r34r35 = -608[$r1]
	;;	# (end cycle 22)
	lo $r40r41r42r43 = -384[$r1]
	;;	# (end cycle 23)
	lo $r8r9r10r11 = -640[$r1]
	;;	# (end cycle 24)
	lo $r44r45r46r47 = -352[$r1]
	;;	# (end cycle 25)
	lo $r48r49r50r51 = -256[$r1]
	;;	# (end cycle 26)
	lo $r52r53r54r55 = -224[$r1]
	;;	# (end cycle 27)
	lo $r56r57r58r59 = -128[$r1]
	;;	# (end cycle 28)
	lo $r60r61r62r63 = -96[$r1]
	;;	# (end cycle 29)
	addhq $r8 = $r8, $r32
	addhq $r9 = $r9, $r33
	addhq $r10 = $r10, $r34
	addhq $r11 = $r11, $r35
	;;	# (end cycle 30)
	addhq $r32 = $r4, $r36
	addhq $r33 = $r5, $r37
	addhq $r34 = $r6, $r38
	addhq $r35 = $r7, $r39
	;;	# (end cycle 31)
	addhq $r4 = $r40, $r44
	addhq $r5 = $r41, $r45
	addhq $r6 = $r42, $r46
	addhq $r7 = $r43, $r47
	;;	# (end cycle 32)
	addhq $r36 = $r48, $r52
	addhq $r37 = $r49, $r53
	addhq $r38 = $r50, $r54
	addhq $r39 = $r51, $r55
	;;	# (end cycle 33)
	addhq $r40 = $r56, $r60
	addhq $r41 = $r57, $r61
	addhq $r42 = $r58, $r62
	addhq $r43 = $r59, $r63
	;;	# (end cycle 34)
	so -576[$r1] = $r8r9r10r11
	;;	# (end cycle 35)
	so -448[$r1] = $r32r33r34r35
	;;	# (end cycle 36)
	so -320[$r1] = $r4r5r6r7
	;;	# (end cycle 37)
	so -192[$r1] = $r36r37r38r39
	;;	# (end cycle 38)
	so -64[$r1] = $r40r41r42r43
	;;	# (end cycle 39)
	# loopdo end
.L16:
	call PAPI_get_real_cyc
	;;	# (end cycle 0)
	copyd $r3 = $r0
	addw $r14 = $r14, -1
	copyd $r0 = $r18
	;;	# (end cycle 1)
	sbfd $r5 = $r20, $r3
	;;	# (end cycle 2)
	muldt $r2r3 = $r5, $r19
	srad $r6 = $r5, 63
	;;	# (end cycle 3)
	addd $r9 = $r3, $r5
	;;	# (end cycle 5)
	srad $r10 = $r9, 6
	;;	# (end cycle 6)
	sbfd $r1 = $r6, $r10
	call printf
	;;	# (end cycle 7)
	cb.dnez $r14? .L3
	;;	# (end cycle 8)
	ld $r11 = 56[$r12]
	copyd $r0 = $r14
	;;	# (end cycle 0)
	ld $r14 = 24[$r12]
	;;	# (end cycle 1)
	lq $r18r19 = 32[$r12]
	;;	# (end cycle 2)
	set $ra = $r11
	;;	# (end cycle 3)
	ld $r20 = 48[$r12]
	addd $r12 = $r12, 64
	ret
	;;	# (end cycle 4)
	.size	main, .-main
	.global test_vec
	.section .bss

	.align 32
	.type	test_vec, @object
	.size	test_vec, 12800
test_vec:
	.zero	12800
	.ident	"GCC: (GNU) 10.3.1 20211129 [Kalray Compiler 4.10.0-2.bb018026cf bb018026c-dirty]"
