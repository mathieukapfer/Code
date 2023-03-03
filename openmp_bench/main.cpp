/*
 * Example of open mp - *host* example
 * compile with: make hello_mp
 */

#include <sched.h>
#include <stdio.h>

#include <vector>
#include <stdlib.h>

#define MAIN_LOOP 20
#define NB_THREADS_MAX 16


#ifdef __cplusplus
extern "C" {
#endif

#include <papi.h>
#include <omp.h>

#ifdef __cplusplus
}
#endif

void do_the_work(int nb_threads, int data_size, int * global, int * data) {

  long long start, stop, last, mean = 0;

  for (int i=0; i< data_size; i++) {
    data[i] = i;
    global[i] = i;
  }

  printf("mainloop:%d, datasize:%d, nbthreads:%d", MAIN_LOOP, data_size, nb_threads);

  // heat the cache: run n times and get only the last value
  for (int loop=0; loop < MAIN_LOOP; loop++) {
    start = PAPI_get_real_cyc();

    // Usage of 'parallel for': dispatch index on all cpus
#pragma omp parallel for num_threads(nb_threads)
    for (int index = 0; index < data_size; index++) {
      global[index] += data[index];
    }
    stop = PAPI_get_real_cyc();
    last = stop - start;
    mean += last;
  }

  //printf("res:%d\n",global[2]);
  printf(", mean_nbcycles:%lld, last_nbcycles:%lld\n", mean / MAIN_LOOP, last);

}

int main(void)
{
  std::vector<int> datasizes = {500,1000,2000,5000,10000,20000,50000,100000,200000};

  for (int data_size: datasizes) {
    int *data = (int *) malloc(data_size * sizeof(int));
    int *global = (int *) malloc(data_size * sizeof(int));

    for (int nb_threads = 1; nb_threads <= NB_THREADS_MAX; nb_threads++) {
      do_the_work(nb_threads, data_size, global, data);
    }

    free(data);
    free(global);
  }

  return 0;
}
