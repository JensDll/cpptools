cmake_minimum_required(VERSION 3.24)

set(NOT_SUBPROJECT OFF)
if(NOT DEFINED PROJECT_NAME)
  set(NOT_SUBPROJECT ON)
endif()

project(DataStructures LANGUAGES CXX)
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
include(CMakePrintHelpers)

project_options_defaults(
  PREFIX ${PROJECT_NAME}
  LIBS ${CPPTOOLS_ROOT}/lib Catch2
  DISABLE_STATIC_ANALYSIS Catch2 Catch2WithMain cpptools_data_structures_test)

add_library(cpptools_data_structures SHARED include/bitarray.cpp)
add_library(cpptools::data_structures ALIAS cpptools_data_structures)
target_include_directories(
  cpptools_data_structures
  PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIR}/include>
         $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>)
target_link_libraries(
  cpptools_data_structures PRIVATE ${PROJECT_NAME}_project_options
                                   ${PROJECT_NAME}_project_warnings)

enable_testing()
add_executable(cpptools_data_structures_test test/bitarray.test.cpp)
target_link_libraries(
  cpptools_data_structures_test
  PRIVATE Catch2::Catch2WithMain cpptools_data_structures
          ${PROJECT_NAME}_project_options ${PROJECT_NAME}_project_warnings)
catch_discover_tests(cpptools_data_structures_test)

if(NOT_SUBPROJECT)
  install(
    TARGETS cpptools_data_structures
    EXPORT cpptools
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}/cpptools
    INCLUDES
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

  install(
    EXPORT cpptools
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/cpptools
    NAMESPACE cpptools::)

  install(
    DIRECTORY include/
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/cpptools/data_structures
    FILES_MATCHING
    PATTERN "*.hpp")
endif()
