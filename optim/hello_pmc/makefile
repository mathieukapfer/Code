CC=g++
CXXFLAGS=-O2 -g -save-temps -fverbose-asm #-march=native
LDLIBS= -lpapi

all: test

clean:
	-rm main *.o *.s *.i *.ii

test: main
	./main

#main: papi_util.cpp
