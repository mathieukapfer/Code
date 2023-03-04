# Generator-Function:
# A generator-function is defined like a normal function,
# but whenever it needs to generate a value, it does so with
# the yield keyword rather than return. If the body of a def
# contains yield, the function automatically becomes a generator
# function.


# A generator function that yields 1 for first time,
# 2 second time and 3 third time
def simpleGeneratorFun():
    yield 1
    yield 2
    yield 3


# Driver code to check above generator function
for value in simpleGeneratorFun():
    print(value)
