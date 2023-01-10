cmake_minimum_required(VERSION 3.24)

project(Algorithms LANGUAGES CXX)

if(CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR)
  set(${PROJECT_NAME}_BUILT_STANDALONE ON)
else()
  set(${PROJECT_NAME}_BUILT_STANDALONE OFF)
endif()

list(APPEND CMAKE_MESSAGE_CONTEXT "Algorithms")

message(
  STATUS
    "Building ${PROJECT_NAME} (standalone = ${${PROJECT_NAME}_BUILT_STANDALONE})"
)

if(${PROJECT_NAME}_BUILT_STANDALONE)
  set(CPPTOOLS_COMMON_CMAKE_UTILS ${CMAKE_CURRENT_LIST_DIR}/../../cmake)

  list(PREPEND CMAKE_MODULE_PATH "${CPPTOOLS_COMMON_CMAKE_UTILS}/modules")

  # See Professional CMake: A Practical Guide 13th Edition, ch. 17
  set(CMAKE_CXX_STANDARD 20)
  set(CMAKE_CXX_STANDARD_REQUIRED ON)
  set(CMAKE_CXX_EXTENSIONS OFF)

  set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
  set(CMAKE_LINK_LIBRARIES_ONLY_TARGETS ON)
endif()

include(ProjectOptionsDefaults)
include(FetchContent)

project_options_defaults(
  PREFIX
  ${PROJECT_NAME}
  DISABLE_STATIC_ANALYSIS
  Catch2
  Catch2WithMain
  cpptools_algorithms_test)

enable_testing()

add_subdirectory(${CPPTOOLS_COMMON_CMAKE_UTILS}/lib/Catch2 lib/Catch2)
add_subdirectory(${CPPTOOLS_COMMON_CMAKE_UTILS}/lib/MicrosoftGSL
                 lib/MicrosoftGSL)
add_subdirectory(../data_structures modules/data_structures)

add_library(cpptools_algorithms SHARED include/merge_sort.hpp)
set_target_properties(cpptools_algorithms PROPERTIES LINKER_LANGUAGE CXX)

target_include_directories(cpptools_algorithms
                           PUBLIC "${CMAKE_CURRENT_LIST_DIR}/include")

target_link_libraries(
  cpptools_algorithms
  PUBLIC ${PROJECT_NAME}_project_options
         ${PROJECT_NAME}_project_warnings
         GSL
         cpptools_data_structures)

add_executable(cpptools_algorithms_test test/merge_sort.test.cpp)

target_link_libraries(cpptools_algorithms_test PRIVATE Catch2::Catch2WithMain
                                                       cpptools_algorithms)

catch_discover_tests(cpptools_algorithms_test)
