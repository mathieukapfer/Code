#include <fstream>
#include <ios>
#include <sstream>
#include <iostream>

int main(int argc, char *argv[])
{

    // string
    std::stringstream ss;
    // - text
    ss << "hello ";
    ss << "0x" << std::hex << 0x55 << " ";
    ss << "0x55";
    // - binary
    char c = 0x55;
    ss.write(reinterpret_cast<char *>(&c),1);
    std::cout << ss.str();

    // file
    std::fstream fs;
    fs.open("hello.bin", std::ios_base::out | std::ios_base::in);
    //  - bin
    float data = 1.23;
    fs.write(reinterpret_cast<char *>(&data), sizeof(float));
    //  - text
    fs << "hello ";
    // read back from file
    fs.seekp(0);
    // - text
    std::string str1, str2;
    float data_out;
    fs.read(reinterpret_cast<char *>(&data_out), sizeof(float));
    fs >> str1;
    std::cout << "\nread back:" << data_out << "," << str1 <<  std::endl;

    return 0;
}
