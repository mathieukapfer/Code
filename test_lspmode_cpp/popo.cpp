

class Popo
{
 public:

  virtual ~Popo() {};
  void methode(){};
  void methode2(){};
};

class Zozo
{
 public:
  Zozo();
  virtual ~Zozo();
};

int p1;

void fct() {
  p1++;
};

int main()
{
  Popo p1, p2(p1);
  p1.methode();
  p1.methode2();
  p2.methode2();

  return 0;
}
