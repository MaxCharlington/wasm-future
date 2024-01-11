cmake_minimum_required(VERSION 3.0)

project(wasmos)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
# set(CMAKE_CXX_COMPILER "/usr/bin/arm-linux-gnueabihf-g++")
# set(CMAKE_C_COMPILER "/usr/bin/arm-linux-gnueabihf-gcc")

file(GLOB SOURCES "src/*.cpp")
file(GLOB TESTS "test/*.c")

include_directories("include")

add_executable(interpr ${SOURCES})
add_executable(test ${TESTS})

# target_compile_options(interpr PRIVATE -mcpu=cortex-a9 -O2 -g -Wall -Wextra)
# target_link_options(interpr PRIVATE -static)
