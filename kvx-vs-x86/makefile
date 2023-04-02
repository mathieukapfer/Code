# enable llvm compiler (by default)

# cluster-compiler:=llvm

# CV2:=-march=kv3-2
# CV2_ISS:=-$(CV2)
# arch:=kv3-2

# common
# ================
cflags:= $(CFLAGS) -O3 -Wall -Wextra  -save-temps # -I/work1/mkapfer/compute_benchmarks/include#
lflags:= -lpapi

# optim flags
# ================

ifeq ($(cluster-compiler),llvm)
# llvm
cluster-cflags+= -mllvm -disable-kvx-hwloops=false
else
# gcc
#cluster-cflags+= -funroll-all-loops
#cflags+= -fverbose-asm  -ftree-vectorize
#cflags+= -fopenmp -fmodulo-sched -fmodulo-sched-allow-regmoves -ftree-vectorize
endif


# mppa target
# ==============
hello_mppa-lflags= -Wl,-lpapi,--defsym=MPPA_COS_NB_CC=1 -Wl,--defsym=MPPA_COS_NB_CORES_LOG2=4 -Wl,--defsym=MPPA_COS_THREAD_PER_CORE_LOG2=0
hello_mppa-cflags=-Wl,-lpapi--defsym=MPPA_COS_NB_CC=1 -Wl,--defsym=MPPA_COS_NB_CORES_LOG2=4 -Wl,--defsym=MPPA_COS_THREAD_PER_CORE_LOG2=0 $(common-cflags)

hello_mppa2-lflags=$(hello_mppa-lflags)
hello_mppa2-cflags=$(hello_mppa-cflags) -DUSE_PMC

# system:=cos
hello_mppa-srcs  := hello_mppa.c
hello_mppa2-srcs := hello_mppa_extract.c

cluster-bin += hello_mppa hello_mppa2

# host target
# ==============
hello-srcs := hello_mppa_.c
hello-cflags := -g -save-temps -fverbose-asm  -march=native #-mavx512bw -mavx512vl  #-march=cannonlake  #

host-bin += hello


run: run-mppa run-host

#	@echo
#	@echo "# Overview of each iteration (noisy)
#	kvx-jtag-runner --exec-file=cluster0:output/bin/hello_mppa
#	@echo
#	@echo "# Detail of last iteration (precise)"


run-mppa: hello_mppa2
	 kvx-jtag-runner --exec-file=cluster0:output/bin/hello_mppa2

run-iss:  hello_mppa2
	kvx-mppa $(CV2_ISS) --cycle-based  --enable-cache  -- output/bin/hello_mppa2

#	kvx-mppa $(CV2_ISS) --cycle-based  --enable-cache -p --profile-options="--detailed-traces" -- output/bin/hello_mppa2

run-host: hello
	@echo
	@echo "# Overview on x86"
	output/bin/hello

# SIMDE_X86_AVX2_NATIVE
# SIMDE_X86_AVX2_ENABLE_NATIVE_ALIASES


ifdef KALRAY_TOOLCHAIN_DIR
include $(KALRAY_TOOLCHAIN_DIR)/share/make/Makefile.kalray
else
include ../kvx-make/Makefile.kalray
endif
