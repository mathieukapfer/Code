
====================================================
Welcome to Openmp test bench to compare x86 and mppa.
====================================================

X86 dependencies
----------------

Please install on host:

  - papi lib:

        sudo apt install libpapi-dev


How to run
----------

To build and run the test on host:

    make run-host

To build and run the test on mppa, just add a parameter in cmd line

    make run-mppa


A bit more description
----------------------
The test will run a very simple program that process an addition on a big vector.
The number of openmp thread and vecor size has the following range:

   datasizes="10 20 50 100 200 500 1000 2000 5000 10000 20000 50000 100000"
   nbthreads= from 1 to 16
