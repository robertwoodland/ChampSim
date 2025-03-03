cmake_minimum_required(VERSION 3.10)
project(project-name)

set(CMAKE_CXX_STANDARD 11)

enable_testing()

find_package(GTest REQUIRED)
include_directories(${GTEST_INCLUDE_DIRS})

add_executable(test_main test/test_main.cc branch/testpred/testpred.cc)
target_link_libraries(test_main ${GTEST_LIBRARIES} pthread)

add_test(NAME test_main COMMAND test_main)