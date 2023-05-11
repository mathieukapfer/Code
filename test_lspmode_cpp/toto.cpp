#include "titi.h"
#include "subdir/tutu.h"
#include <cstdio>
#include <iostream>
#include <vector>

class Toto {
 public:
  Toto(){};
  virtual ~Toto(){};

  int aMethod1(int a, int b) { return a + b; };
  void aMethod2(){};
};

class Momo {
 public:
  Momo();
  virtual ~Momo();
  void popopop();
};

int main()
{

  Toto toto;
  Tutu tutu;
  std::vector<int> vc;

  return 0;
}
