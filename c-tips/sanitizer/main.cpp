#include <stdio.h>

int main(int argc, char *argv[])
{
  int titi[20];
  int tab[10];
  int toto[20];

  for(int i=0; i<=20; i++) {
    toto[i]=i;
  }

  printf("%d %d %d",tab[10], titi[0], toto[0]);

  return 0;
}
