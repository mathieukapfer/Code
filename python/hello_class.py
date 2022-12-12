name = "toto"

print(" 1- my name is %s" % name)
print(" 2- my name is {}".format(name))


def say_hello(name1, name2, *names):
    """ say hello ! """
    print(" - hello {} {}".format(name1, name2))
    print(" * hello {}".format(name1) + " {}".format(name2))
    for name in names:
        print(names)
        print("and " + name)


say_hello("toto", "momo")
say_hello("toto", "momo", "zozo", "popo")


class myClass:
    """ my first class"""
    nb_instance = 0

    def __init__(self, name):
        self.name = name
        myClass.nb_instance += 1
        print("create instance {} with name {}".
              format(myClass.nb_instance, name))

    def say_hello(self):
        """ this is a comment """
        print(" > hello {}".format(self.name))

    def say_hello2(self):
        print(self)


myClass("toto").say_hello()
