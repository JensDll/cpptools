add_executable(main main.cpp)

set_source_files_properties(main.asm PROPERTIES LANGUAGE ASM_NASM)

add_library(main_asm STATIC main.asm)

target_link_libraries(main PRIVATE project_options project_warnings main_asm)
