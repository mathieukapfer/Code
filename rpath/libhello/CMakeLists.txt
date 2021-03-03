
set(CMAKE_SHARED_LINKER_FLAGS "-Wl,-rpath=toto")

add_library (libhello SHARED hello.c hello.h)
target_include_directories(libhello PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
