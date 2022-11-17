cmake_minimum_required(VERSION 3.24)

project(
  Asm
  VERSION 0.0.0
  LANGUAGES C CXX ASM_NASM)

include(cmake/assure_out_of_source_build.cmake)

# Link this library to set the project's compile-time options
add_library(project_options INTERFACE)

# Link this library to use the warnings specified in Warnings.cmake
add_library(project_warnings INTERFACE)

# Configure common options
include(cmake/configure_common.cmake)
configure_common(project_options)

# Configure linker options
include(cmake/configure_linker.cmake)
configure_linker(project_options)

# Configure compiler warnings
include(cmake/configure_warnings.cmake)
configure_warnings(project_warnings)

add_subdirectory(modules/main)
