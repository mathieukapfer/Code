#include <functional>
#include <iostream>

#include <optional>

void print_num(int i)
{
    std::cout << i << '\n';
}



int main(int argc, char *argv[])
{

    // function ptr
    std::function<void(int)> f = print_num;
    f(10);

    // optional function ptr
    std::optional<std::function<void(int)>> f_opt;
    std::cout << f_opt.has_value() << std::endl;
    f_opt = print_num;
    std::cout << f_opt.has_value()  << std::endl;
    (*f_opt)(100);

    return 0;
}
