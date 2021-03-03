cmake_minimum_required(VERSION 3.13)

project (HELLO)

set(CMAKE_EXPORT_COMPILE_COMMANDS true)

add_subdirectory (libhello)

add_executable (main main.cpp )
target_link_libraries(main hello)

include_directories(main libhello)
