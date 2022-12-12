# example with print
# ==================
arr = ['sunday', 'monday', 'tuesday', 'wednesday']

# without using asterisk
print(' '.join(map(str, arr)))

# using asterisk
print(*arr)


# using asterisk as variable number of argument
# ==================
def addition(*args):
    return sum(args)


print(addition(5, 10, 20, 6))


# using double asterisk as avariable number of couple 'keyword=value'
# ==================
def food(**kwargs):
    for items in kwargs:
        print(f"{kwargs[items]} is a {items}")


# call with explicit parameter list
food(fruit='cherry', vegetable='potato', boy='srikrishna')

# call with dictionnary
dict = {'fruit': 'cherry', 'vegetable': 'potato', 'boy': 'srikrishna'}
food(**dict)


# using both
# ==================
def add(*values, **options):
    s = 0
    for i in values:
        s = s + i
    if "neg" in options:
        if options["neg"]:
            s = -s
    return s


s = add(1, 2, 3, 4, 5)             # returns 15
print(s)
s = add(1, 2, 3, 4, 5, neg=True)   # returns -15
print(s)
s = add(1, 2, 3, 4, 5, neg=False)  # returns 15
print(s)


# using asterisk in a assignement
alist = [1, 2, 3, 4, 5]
first, *middle, last = alist

print(first)    # return 1
print(middle)   # return '[2, 3, 4]'
print(last)     # return 5
