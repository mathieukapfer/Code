class Demo(object):

    def __init__(self, message):
        self.msg = message

    def __enter__(self):
        print("\nHello")
        return self

    def __exit__(self, *args):
        print("Goodbye")

    def say(self):
        print("  this is my message: " + self.msg)


with Demo("Have a good day !") as speaker:
    print("  <inside with statement>")
    speaker.say()
