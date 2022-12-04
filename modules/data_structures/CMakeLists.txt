cmake_minimum_required(VERSION 3.24)

list(APPEND CMAKE_MESSAGE_CONTEXT DataStructures)

project(DataStructures LANGUAGES CXX)

# See Professional CMake: A Practical Guide 13th Edition, ch. 17
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_LINK_LIBRARIES_ONLY_TARGETS ON)

set(PROJECT_COMMON_CMAKE_UTILS ${CMAKE_CURRENT_LIST_DIR}/../../cmake)

list(PREPEND CMAKE_MODULE_PATH "${PROJECT_COMMON_CMAKE_UTILS}/modules")

include(ProjectOptions)
include(FetchContent)
include(CMakePrintHelpers)

project_options(ENABLE_SANITIZER_ADDRESS ENABLE_SANITIZER_ADDRESS
                ENABLE_SANITIZER_UNDEFINED_BEHAVIOR)

enable_testing()
add_subdirectory(lib/Catch2)

add_library(jensdll_data_structures SHARED src/bitarray.cpp)

target_include_directories(jensdll_data_structures
                           PUBLIC "${CMAKE_CURRENT_LIST_DIR}/include")

target_link_libraries(jensdll_data_structures PUBLIC project_options
                                                     project_warnings)

add_executable(jensdll_data_structures_test test/bitarray.test.cpp)

target_link_libraries(jensdll_data_structures_test
                      PRIVATE Catch2::Catch2WithMain jensdll_data_structures)

catch_discover_tests(jensdll_data_structures_test)
