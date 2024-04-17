#include <iostream>
#include <string>

// Define a user-defined literal operator for meters
constexpr long double operator"" _m(long double meters) {
    return meters;
}

int main() {
    // Use the user-defined literal operator to define a length in meters
    long double length = 5.5_m;

    std::cout << "Length: " << length << " meters" << std::endl;

    return 0;
}