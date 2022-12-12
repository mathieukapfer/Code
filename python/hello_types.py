
# scalar
a_int = int(9)
a_float = float(8.0)
a_complex = complex(1, 2)

print("int  : {}".format(a_int))
print("float: {0:0.3f}".format(a_float))
print("complexe: {} {}".format(a_complex.real, a_complex.imag))

# list
a_list = ['this', 'is', 'a', 'list', 'with', 'float', 9.21]

for item in a_list:
    print("{}".format(item))

# matrix
matrix = [
    [1, 2, 3, 4],
    [5, 6, 7, 8],
    [9, 10, 11, 12],
]

for row in matrix:
    print(format(row))


# set
a_set = set(a_list)

a_set.discard('list')
a_set.add('set')
for item in a_set:
    print("{}".format(item))


# list, set, dictionnary - comprehension
squares_list = [x**2 for x in range(10)]
squares_set = {x**2 for x in range(10)}  # same for set but unordred
squares_list2 = list(map(lambda x: x**2, range(10)))  # same with lambda
squares_dict = {x: x**2 for x in range(10)}
