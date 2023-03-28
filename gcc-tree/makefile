CXXFLAGS=-g

# keep ASM with embedded C code
CXXFLAGS+= -save-temps -fverbose-asm

# keep all gcc step
CXXFLAGS+= -fdump-ipa-all-details -fdump-tree-all-details -fdump-rtl-all-details -O3

all: clean
	make main

clean:
	-rm main main.o
