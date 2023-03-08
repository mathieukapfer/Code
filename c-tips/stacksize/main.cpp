#include <stdlib.h>
#include <stdio.h>

int call_me4(int a, int b) {
  return a-b;
}

int call_me3(int a, int b, int c, int d) {
  return a-b+call_me4(a,b);
}

int call_me2(int a, int b) {
  return a+b-call_me3(a,b,a,b);
}

int call_me(int a, int b) {
  return a+b+call_me2(a,b);
}


int main(int argc, char *argv[])
{
  return call_me(atoi(argv[1]), atoi(argv[2]));
}
