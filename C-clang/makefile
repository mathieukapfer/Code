
CC=clang

CFLAGS=-O0

all: fib fib.ll fib.s

clean:
	rm *.s *.ll fib

# exe
fib:fib.c

# LLVM-IR
%.ll: %.c
	$(CC) $(CFLAGS) -S -emit-llvm $<

# ASM
%.s: %.c
	$(CC) $(CFLAGS) -S  $<

%.s: %.cpp
	$(CC) $(CFLAGS) -S  $<
