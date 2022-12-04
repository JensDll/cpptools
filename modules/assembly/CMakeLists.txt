cmake_minimum_required(VERSION 3.25)

project(Assembly LANGUAGES CXX ASM_NASM)

set(PROJECT_COMMON_CMAKE_UTILS ${CMAKE_CURRENT_SOURCE_DIR}/../../cmake)

list(PREPEND CMAKE_MODULE_PATH "${PROJECT_COMMON_CMAKE_UTILS}/modules")

include(ProjectConfiguration)

add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/../data_structures data_structures)

add_library(fibonacci STATIC ${CMAKE_CURRENT_LIST_DIR}/assembly/fibonacci.asm)
add_library(some_function STATIC
            ${CMAKE_CURRENT_LIST_DIR}/assembly/some_function.asm)
add_library(compile_explorer STATIC
            ${CMAKE_CURRENT_LIST_DIR}/assembly/compile_explorer.asm)

add_executable(main main.cpp)

target_link_libraries(
  main
  PRIVATE project_options
          project_warnings
          assembly_playground_data_structures
          fibonacci
          some_function
          compile_explorer)
