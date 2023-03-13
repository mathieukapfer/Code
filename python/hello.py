name="Bob"

# old way
print("my name is %s" % name)

# using format
print("my name is {}".format(name))

# using f-string (format string)
print(f'my name is {name}')

# the wonderful world of f-string
## source: https://pythoninoffice.com/python-f-string-formatting/
print(f'{name =}')   # consise format to print variable value for debug purpose
print(f'{name:>10}') # test alignement, insert space left, right, middle with >, <, ^
print(f'{"Hi" if name=="Bob" else "Hello"} {name}') # with condition

# r-string is "raw" string
print(r'do not interpret slash: \n')

# both r and f can be mixed, usefull to build path file
print(rf'the home path is: \home\{name}')
