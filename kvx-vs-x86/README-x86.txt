# install
sudo apt install libpapi-dev

# make & run
make -f makefile.x86 hello_mppa && ./hello_mppa

# output
took 776
took 39
took 9
took 7
took 8
took 8
took 7
took 8
took 8
took 7

# extract of hello_mppa.s

.L3:
	call	PAPI_get_real_cyc@PLT
	movq	%rax, %r14
	leaq	test_vec(%rip), %rax
	.p2align 4,,10
	.p2align 3
.L2:
	vmovdqa	(%rax), %ymm1
	vpaddw	32(%rax), %ymm1, %ymm0
	subq	$-128, %rax
	vmovdqa	%ymm0, -64(%rax)
	cmpq	%rbx, %rax
	jne	.L2
	vzeroupper
	call	PAPI_get_real_cyc@PLT
