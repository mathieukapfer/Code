# todo

## starting point: lab preparation
 - add monitoring with papi:
   - nb cycles,
   - nb usec
   - nb stalls
 - add range of size (bash or template) and plotting
 - random run (to check stability - link to data alignement ?)
 - figure in hot & cold cache
 - disable frequency scaling

## basic optim
 - pre-allocation - no dynamic allocation in data plan

 - compiler option
   - -O2, -O3 (loop unrolling) & ASM dump
   - #pragma GCC unroll(8)

 - SIMD (FMA) & vector
 - memory alignement
 - manual unrolling (& prologue / epilogue)
   - reduce loop overhead
   - processing & load (to register) interleaving

 - parallelisation (open-mp, pthread)
