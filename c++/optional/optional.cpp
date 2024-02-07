#include <optional>
#include <iostream>


std::optional<int> offset(bool create) {
    if (create) {
        return 99;
    } else {
        return std::nullopt;
    }
}

int main(int argc, char *argv[])
{

    std::optional<int> val;

    val = offset(true);

    // display with default value
    std::cout << "value is " << (val?"defined: ":"not defined, display instead: ")
              << val.value_or(-1) << std::endl;

    // conditional display
    if (val) {
        std::cout << "value is defined: " << *val << std::endl;
    }

    val = offset(false);

    // display with default value
    std::cout << "value is " << (val?"defined! ":"not defined, display instead: ")
              << val.value_or(-1) << std::endl;

    // conditional display
    if (val) {
        std::cout << "value is defined: " << *val << std::endl;
    }

    return 0;
}
