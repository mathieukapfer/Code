// source : https://en.wikipedia.org/wiki/OpenMP
// source: https://stackoverflow.com/questions/22492886/openmp-how-to-retrieve-the-core-id-in-which-a-thread-is-running

//#define _GNU_SOURCE // sched_getcpu(3) is glibc-specific (see the man page)

#include <sched.h>

#include <stdio.h>
#include <omp.h>

int main(void)
{
#pragma omp parallel for
  for (int index=0; index<10; index++)
    {
      int thread_num = omp_get_thread_num();
      int cpu_num = sched_getcpu();
      printf("Thread %3d is running on CPU %3d - (index:%d)\n", thread_num, cpu_num, index);
    }

  return 0;
}
