// source : https://en.wikipedia.org/wiki/OpenMP
// source: https://stackoverflow.com/questions/22492886/openmp-how-to-retrieve-the-core-id-in-which-a-thread-is-running

//#define _GNU_SOURCE // sched_getcpu(3) is glibc-specific (see the man page)

#include <sched.h>

#include <stdio.h>
#include <omp.h>

int main(void)
{
#pragma omp parallel
  for (int index=0; index<5; index++)
    {
      int thread_num = omp_get_thread_num();
      int cpu_num = sched_getcpu();
      int lock=ftrylockfile(stdout);
      // Note: file access is protected by flock by default !
      // https://stackoverflow.com/questions/467938/stdout-thread-safe-in-c-on-linux/3335444#3335444
      if (lock != 0) {
        printf("Thread %d on Cpu %d has been blocked to stdout access ....\n", thread_num, cpu_num);
      }
      printf("Thread %3d is running on CPU %3d - (index:%d)\n", thread_num, cpu_num, index);
      funlockfile(stdout);
    }

  return 0;
}
