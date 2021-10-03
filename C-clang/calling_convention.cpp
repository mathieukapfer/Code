#include <iostream>

using namespace std;

extern "C" int myFunc(int a, int b, int c) {
  int l=0;
  return l + a + b + c;
}

int main ( ) {
  int x = 3 ;
  cout << "myFunc ( ) returned : "
       << myFunc ( x , 5 , 10 ) << endl ;

  return 0;
}
