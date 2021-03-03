cmake_minimum_required(VERSION 3.13)

project (HELLO)

set(CMAKE_EXPORT_COMPILE_COMMANDS true)

add_subdirectory (libhello)

add_executable (hello main.cpp )
target_link_libraries(hello libhello)
