
compile:
	cd build && make VERBOSE=1 && ./main

check:
	readelf -a build/libhello/libhello.so | grep PATH

config:
	mkdir -p build && cd build && cmake ..

clean:
	rm -r build
