cmake_minimum_required(VERSION 3.24)

project(DataStructures LANGUAGES CXX)

list(APPEND CMAKE_MESSAGE_CONTEXT ${CMAKE_PROJECT_NAME})

set(PROJECT_COMMON_CMAKE_UTILS ${CMAKE_CURRENT_LIST_DIR}/../../cmake)

list(PREPEND CMAKE_MODULE_PATH "${PROJECT_COMMON_CMAKE_UTILS}/modules")

# See Professional CMake: A Practical Guide 13th Edition, ch. 17
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_LINK_LIBRARIES_ONLY_TARGETS ON)

include(ProjectOptionsDefaults)
include(FetchContent)

# See https://github.com/aminya/project_options
# for the inspiration of this function
project_options_defaults(
  DISABLE_STATIC_ANALYSIS
  Catch2
  Catch2WithMain
  cpptools_data_structures_test)

enable_testing()
add_subdirectory(lib/Catch2)

add_library(cpptools_data_structures SHARED src/bit.cpp src/bitarray.cpp)

target_include_directories(cpptools_data_structures
                           PUBLIC "${CMAKE_CURRENT_LIST_DIR}/include")

target_link_libraries(cpptools_data_structures PUBLIC project_options
                                                      project_warnings)

add_executable(cpptools_data_structures_test test/bitarray.test.cpp)

target_link_libraries(cpptools_data_structures_test
                      PRIVATE Catch2::Catch2WithMain cpptools_data_structures)

catch_discover_tests(cpptools_data_structures_test)
