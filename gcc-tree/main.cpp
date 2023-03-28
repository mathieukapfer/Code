#include <stdio.h>

#define SIZE_T 99

int main(int argc, char *argv[])
{

  int A[SIZE_T], B[SIZE_T], C[SIZE_T];

  // loop
  for (int i = 0; i < SIZE_T; i++) {
    C[i]=A[i] + B[i];
  }

  // usage
  for (int i = 0; i < SIZE_T; i++) {
    printf("%d ", C[i]);
  }


  return 0;
}
