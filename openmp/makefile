CFLAGS=-fopenmp
CXXFLAGS=-fopenmp

test:	hello_loop_omp
	./hello_loop_omp

clean:
	rm hello hello_info hello_loop 	hello_loop_omp

test-mixed: hello hello_info hello_loop
	./hello
	$(CONF_AFFINITY) ./hello
	./hello_info
	$(CONF_AFFINITY) ./hello_info
	./hello_loop
	$(CONF_AFFINITY) ./hello_loop
	./hello_loop_omp
	$(CONF_AFFINITY) ./hello_loop_omp

test-no-ffinity: hello hello_info hello_loop
	./hello
	./hello_info
	./hello_loop

CONF_AFFINITY=GOMP_CPU_AFFINITY='0,1,2,3' OMP_NUM_THREADS=4

test-with-affinity: hello hello_info hello_loop
	$(CONF_AFFINITY) ./hello
	$(CONF_AFFINITY) ./hello_info
	$(CONF_AFFINITY) ./hello_loop
