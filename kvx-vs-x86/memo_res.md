
# use cases

## C code
```
  for (size_t i = 0 ; i < (sizeof(test_vec) / sizeof(test_vec[0])) ; i++) {
    simde__m256i a = simde_mm256_loadu_epi16(&test_vec[i].a);
    simde__m256i b = simde_mm256_loadu_epi16(&test_vec[i].b);
    simde__m256i r = simde_mm256_add_epi16(a, b);
    test_vec[i].r = r;

```

## ASM
```
	loopdo $r2, .L5
	;;	# (end cycle 4)
.L2:
	lo $r4r5r6r7 = 32[$r1]
	addd $r1 = $r1, 96
	;;	# (end cycle 0)
	lo $r8r9r10r11 = -96[$r1]
	;;	# (end cycle 1)
	addhq $r4 = $r4, $r8
	addhq $r5 = $r5, $r9
	addhq $r6 = $r6, $r10
	addhq $r7 = $r7, $r11
	;;	# (end cycle 4)
	so -32[$r1] = $r4r5r6r7
	;;	# (end cycle 5)
	# loopdo end
```

# Keep data in cache => 7 cycles

size of data = 3x256 bitsx100 = 3 x 32 B x 100 = 9600 B < size of L1 cache = 16K

```
#define IT_MAX 10
#define VECTOR_SIZE 100

struct {
  simde__m256i a; // int8x8_t((int8
  simde__m256i b;
  simde__m256i r;
  //simde__m256i r2; // align 64B L1 cache
} test_vec[VECTOR_SIZE];


make run-mppa
  KVX_COS_CC		output/build/hello_mppa_build/hello_mppa.c.o
  KVX_COS_LD		output/bin/hello_mppa
kvx-jtag-runner --exec-file=cluster0:output/bin/hello_mppa
Cluster0@0.0: took 38
Cluster0@0.0: took 7
Cluster0@0.0: took 7
Cluster0@0.0: took 7
```

# Need L1 cache refill + data unaligned => 38 cycles

```
#define IT_MAX 10
#define VECTOR_SIZE 200


make run-mppa
  KVX_COS_CC		output/build/hello_mppa_build/hello_mppa.c.o
  KVX_COS_LD		output/bin/hello_mppa
kvx-jtag-runner --exec-file=cluster0:output/bin/hello_mppa
Cluster0@0.0: took 38
Cluster0@0.0: took 36
Cluster0@0.0: took 36

```

# Need L1 cache refill + data aligned on 64B line of cache => 28 cycles

```
struct {
  simde__m256i a; // int8x8_t((int8
  simde__m256i b;
  simde__m256i r;
  simde__m256i r2; // align 64B L1 cache
} test_vec[VECTOR_SIZE];

kvx-jtag-runner --exec-file=cluster0:output/bin/hello_mppa
Cluster0@0.0: took 28
Cluster0@0.0: took 28

```

	lo $r4r5r6r7 = 32[$r1]  ===> 25 cycles -> cache refill
	addd $r1 = $r1, 96
	;;	# (end cycle 0)
	lo $r8r9r10r11 = -96[$r1] => 1 cycle
	;;	# (end cycle 1)
	addhq $r4 = $r4, $r8      => wait 2 cycles more to get last load ready
	addhq $r5 = $r5, $r9
	addhq $r6 = $r6, $r10
	addhq $r7 = $r7, $r11
	;;	# (end cycle 4)
	so -32[$r1] = $r4r5r6r7  => 1 cycle
	;;	# (end cycle 5)
	# loopdo end             => 0 cycle

## PMC
Use PMC to have more detail data.

Long verson (with recompilation)

    make V=1 run-mppa
    /work1/mkapfer/csw/kEnv/kvxtools/opt/kalray/accesscore/bin/kvx-cos-gcc -march=kv3-1  -MT output/build/hello_mppa_build/hello_mppa.c.o -MD -MP -MF output/build/hello_mppa_build/.hello_mppa.c.o.d   -ftree-vectorize -I/work1/mkapfer/simde  -O2    -Wl,-lpapi--defsym=MPPA_COS_NB_CC=1 -Wl,--defsym=MPPA_COS_NB_CORES_LOG2=4 -Wl,--defsym=MPPA_COS_THREAD_PER_CORE_LOG2=0      -c -o output/build/hello_mppa_build/hello_mppa.c.o hello_mppa.c
    /work1/mkapfer/csw/kEnv/kvxtools/opt/kalray/accesscore/bin/kvx-cos-gcc -march=kv3-1 -o output/bin/hello_mppa  output/build/hello_mppa_build/hello_mppa.c.o     -L/work1/mkapfer/mytest/output/lib/cluster/ -lpapi   -Wl,-lpapi,--defsym=MPPA_COS_NB_CC=1 -Wl,--defsym=MPPA_COS_NB_CORES_LOG2=4 -Wl,--defsym=MPPA_COS_THREAD_PER_CORE_LOG2=0
    kvx-jtag-runner --exec-file=cluster0:output/bin/hello_mppa
    Cluster0@0.0: 0:8316 delta=610
    Cluster0@0.0: 1:4020 delta=402
    Cluster0@0.0: 2:4200 delta=200
    Cluster0@0.0: 3:100 delta=0

Short version (without recompilation)

    make V=1 run-mppa
    kvx-jtag-runner --exec-file=cluster0:output/bin/hello_mppa
    Cluster0@0.0: 0:8316 delta=610
    Cluster0@0.0: 1:4020 delta=402
    Cluster0@0.0: 2:4200 delta=200
    Cluster0@0.0: 3:100 delta=0


Extract of papi_util.h:45:

    __cos_counter_start_all(_COS_PM_PCC, _COS_PM_EBE, _COS_PM_LDSC, _COS_PM_DCLME);


Analyse:

    Cluster0@0.0: 0:8316 delta=610 => PCC   => Process Clock Cycle
    Cluster0@0.0: 1:4020 delta=402 => EBE   => Nb Bundle (Executed Bundle Event)
    Cluster0@0.0: 2:4200 delta=200 => LDSC  => Nb cycle of stall (Load Dependency Stall Cycle)
    Cluster0@0.0: 3:100 delta=0    => DCLME => D$ Load Miss Event

Note:

 - In upper figures, the PMC values are taken once on the last iteration onlt (to get the picture when cache are hot)


## ========================== master class by Gael

      r0 = lo;; // 256
      r4 = lo;; // 256
      r0 = 4 x addhq(r1,r4) // 512
      so r4

### ============== x2

      r0 = lo;; // 256
      r4 = lo;; // 256
      r0 = 4 x addhq(r1,r4) // 512
      so r4

      r8 = lo;; // 256
      r12 = lo;; // 256
      r12 = 4 x addhq(r1,r4)
      so r12

#### ======================= reordering

      r0 = lo;; // 256
      r4 = lo;; // 256
      r8 = lo;; // 256
      r12 = lo;; // 256

      r0 = 4 x addhq(r1,r4) // 512

      so r4

      r12 = 4 x addhq(r1,r4)

      so r12

### ======================== builtin traduction

      int16x16_t a = __builtin_kvx_lhx(&test_vec[2*i].a, "", false);
      int16x16_t b = __builtin_kvx_lhx(&test_vec[2*i].b, "", false);
      int16x16_t c = __builtin_kvx_lhx(&test_vec[2*i+1].a, "", false);
      int16x16_t d = __builtin_kvx_lhx(&test_vec[2*i+1].b, "", false);

      int16x16_t r1 = __builtin_kvx_addhx(a, b, ".s");
      int16x16_t r2 = __builtin_kvx_addhx(c, d, ".s");

      test_vec[2*i].r = r1;
      test_vec[2*i+1].r = r2;

### Detail of last iteration (precise)

    kvx-jtag-runner --exec-file=cluster0:output/bin/hello_mppa2
    Cluster0@0.0:    PCC:  6806 delta:   459 once:     4
    Cluster0@0.0:    EBE:  4520 delta:   452 once:     4
    Cluster0@0.0:   LDSC:  1100 delta:     0 once:     0
    Cluster0@0.0:  DCLME:   100 delta:     0 once:     0

### ASM

      # hello_mppa.c:113:       int16x16_t a = __builtin_kvx_lhx(&test_vec[2*i].a, "", false);
      lo $r8r9r10r11 = 0[$r1]	#,* ivtmp.9, a
      ;;	# (end cycle 0)
      # hello_mppa.c:114:       int16x16_t b = __builtin_kvx_lhx(&test_vec[2*i].b, "", false);
      lo $r36r37r38r39 = 32[$r1]	#,, b
      ;;	# (end cycle 1)
      # hello_mppa.c:115:       int16x16_t c = __builtin_kvx_lhx(&test_vec[2*i+1].a, "", false);
      lo $r4r5r6r7 = 128[$r1]	#,, c
      ;;	# (end cycle 2)
      # hello_mppa.c:116:       int16x16_t d = __builtin_kvx_lhx(&test_vec[2*i+1].b, "", false);
      lo $r32r33r34r35 = 160[$r1]	#,, d
      addd $r1 = $r1, 256	# ivtmp.9, ivtmp.9,
      ;;	# (end cycle 3)
      # hello_mppa.c:118:       int16x16_t r1 = __builtin_kvx_addhx(a, b, "");
      addhq $r8 = $r8, $r36	# r1, a, b
      addhq $r9 = $r9, $r37	# r1, a, b
      addhq $r10 = $r10, $r38	# r1, a, b
      addhq $r11 = $r11, $r39	# r1, a, b
      ;;	# (end cycle 4)
      # hello_mppa.c:121:       test_vec[2*i].r = r1;
      so -192[$r1] = $r8r9r10r11	# MEM[base: _2, offset: 64B], r1
      ;;	# (end cycle 5)
      # hello_mppa.c:119:       int16x16_t r2 = __builtin_kvx_addhx(c, d, "");
      addhq $r4 = $r4, $r32	# r2, c, d
      addhq $r5 = $r5, $r33	# r2, c, d
      addhq $r6 = $r6, $r34	# r2, c, d
      addhq $r7 = $r7, $r35	# r2, c, d
      ;;	# (end cycle 6)
      # hello_mppa.c:122:       test_vec[2*i+1].r = r2;
      so -64[$r1] = $r4r5r6r7	# MEM[base: _2, offset: 192B], r2
      ;;	# (end cycle 7)
      # hello_mppa.c:94:     for (size_t i = 0; i < VECTOR_SIZE/2 ; i++) {
      # loopdo end


### ASM with llvm

https://phab.kalray.eu/T18772

	loopdo $r20, .__LOOPDO_0_END_
	;;
.LBB0_4:
	lo $r0r1r2r3 = 0[$r21]
	;;
	lo $r4r5r6r7 = 32[$r21]
	;;
	lo $r8r9r10r11 = 128[$r21]
	;;
	lo $r32r33r34r35 = 160[$r21]
	;;
	lo $r36r37r38r39 = 256[$r21]
	;;
	lo $r40r41r42r43 = 288[$r21]
	addhq $r1 = $r5, $r1
	addhq $r0 = $r4, $r0
	addhq $r2 = $r6, $r2
	;;
	lo $r44r45r46r47 = 384[$r21]
	addhq $r3 = $r7, $r3
	;;
	lo $r48r49r50r51 = 416[$r21]
	addhq $r5 = $r33, $r9
	addhq $r4 = $r32, $r8
	addhq $r6 = $r34, $r10
	;;
	lo $r52r53r54r55 = 512[$r21]
	addhq $r7 = $r35, $r11
	;;
	lo $r56r57r58r59 = 544[$r21]  # r57 load here
	addhq $r9 = $r41, $r37
	addhq $r8 = $r40, $r36
	addhq $r10 = $r42, $r38
	;;
	addhq $r11 = $r43, $r39
	so 64[$r21] = $r0r1r2r3
	addhq $r33 = $r49, $r45
	addhq $r32 = $r48, $r44
	;;
	addhq $r34 = $r50, $r46
	addhq $r35 = $r51, $r47
	so 192[$r21] = $r4r5r6r7
	addhq $r37 = $r57, $r53   # r57 used here: 1 stall has  L1 hit is 2 cycles
	;;
	addhq $r36 = $r56, $r52
	addhq $r38 = $r58, $r54
	addhq $r39 = $r59, $r55
	so 320[$r21] = $r8r9r10r11
	;;
	so 448[$r21] = $r32r33r34r35   # could be move here
	;;
	so 576[$r21] = $r36r37r38r39
	addd $r21 = $r21, 640
	;;
.__LOOPDO_0_END_:
