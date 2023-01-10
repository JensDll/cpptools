cmake_minimum_required(VERSION 3.24)

project(Assembly LANGUAGES CXX ASM_NASM)

list(APPEND CMAKE_MESSAGE_CONTEXT ${CMAKE_PROJECT_NAME})

if(NOT DEFINED CPPTOOLS_COMMON_CMAKE_UTILS)
  set(CPPTOOLS_COMMON_CMAKE_UTILS ${CMAKE_CURRENT_LIST_DIR}/../../cmake)
endif()

list(PREPEND CMAKE_MODULE_PATH "${CPPTOOLS_COMMON_CMAKE_UTILS}/modules")

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
