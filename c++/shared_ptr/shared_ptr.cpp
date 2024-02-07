#include <memory>
#include <stdio.h>

int main(int argc, char *argv[])
{

  std::shared_ptr<char> sp1 (new char(55));

  char val = 8;
  std::shared_ptr<char> sp2 = std::make_shared<char>(val);
  std::shared_ptr<char> sp3 = sp2;

  printf("sp1: %d (%p), sp2: %d (%p)\n", *sp1, sp1.get(), *sp2, sp2.get());
  printf("use count: sp1: %ld, sp2: %ld\n", sp1.use_count(), sp2.use_count());


  *sp2 = 99;
  *sp1 = 11;
  printf("sp1: %d (%p), sp2: %d (%p)\n", *sp1, sp1.get(), *sp2, sp2.get());

  return 0;
}
