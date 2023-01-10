cmake_minimum_required(VERSION 3.24)

set(NOT_SUBPROJECT OFF)
if(NOT DEFINED PROJECT_NAME)
  set(NOT_SUBPROJECT ON)
endif()

project(Algorithms LANGUAGES CXX)
list(APPEND CMAKE_MESSAGE_CONTEXT ${PROJECT_NAME})

message(STATUS "Building ${PROJECT_NAME} (not subproject ${NOT_SUBPROJECT})")

if(NOT_SUBPROJECT)
  set(CPPTOOLS_ROOT ${CMAKE_CURRENT_LIST_DIR}/../..)

  list(PREPEND CMAKE_MODULE_PATH ${CPPTOOLS_ROOT}/cmake/modules)

  # See Professional CMake: A Practical Guide 13th Edition, ch. 17
  set(CMAKE_CXX_STANDARD 20)
  set(CMAKE_CXX_STANDARD_REQUIRED ON)
  set(CMAKE_CXX_EXTENSIONS OFF)

  set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
  set(CMAKE_LINK_LIBRARIES_ONLY_TARGETS ON)
endif()

include(ProjectOptionsDefaults)
include(FetchContent)
include(GNUInstallDirs)
include(ExternalProject)

project_options_defaults(
  PREFIX ${PROJECT_NAME}
  DISABLE_STATIC_ANALYSIS Catch2 Catch2WithMain cpptools_algorithms_test
  LIBS ${CPPTOOLS_ROOT}/lib Catch2 GSL
  MODULES ${CPPTOOLS_ROOT}/modules data_structures)

add_library(cpptools_algorithms SHARED include/merge_sort.hpp)
set_target_properties(cpptools_algorithms PROPERTIES LINKER_LANGUAGE CXX)
target_include_directories(
  cpptools_algorithms
  PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIR}/include>
         $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>)
target_link_libraries(
  cpptools_algorithms
  PRIVATE ${PROJECT_NAME}_project_options ${PROJECT_NAME}_project_warnings GSL
          cpptools_data_structures)

enable_testing()
add_executable(cpptools_algorithms_test test/merge_sort.test.cpp)
target_link_libraries(
  cpptools_algorithms_test
  PRIVATE ${PROJECT_NAME}_project_options
          ${PROJECT_NAME}_project_warnings
          Catch2::Catch2WithMain
          cpptools_algorithms
          cpptools_data_structures)
catch_discover_tests(cpptools_algorithms_test)
