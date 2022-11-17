# See https://github.com/cpp-best-practices/cppbestpractices/blob/master/02-Use_the_Tools_Available.md#compilers

function(configure_warnings project_name)
  set(msvc_warnings
      /W4
      /w14242
      /w14254
      /w14263
      /w14265
      /w14287
      /we4289
      /w14296
      /w14311
      /w14545
      /w14546
      /w14547
      /w14549
      /w14555
      /w14619
      /w14640
      /w14826
      /w14905
      /w14906
      /w14928
      /permissive-)

  set(clang_warnings
      -Wall
      -Wextra
      -Wshadow
      -Wnon-virtual-dtor
      -Wold-style-cast
      -Wcast-align
      -Wunused
      -Woverloaded-virtual
      -Wpedantic
      -Wconversion
      -Wsign-conversion
      -Wnull-dereference
      -Wdouble-promotion
      -Wformat=2
      -Wimplicit-fallthrough)

  set(gcc_warnings
      ${clang_warnings}
      -Wmisleading-indentation
      -Wduplicated-cond
      -Wduplicated-branches
      -Wlogical-op
      -Wuseless-cast)

  if(MSVC)
    set(project_warnings ${msvc_warnings})
  elseif(is_clang_compiler)
    set(project_warnings ${clang_warnings})
  elseif(is_gnu_compiler)
    set(project_warnings ${gcc_warnings})
  else()
    message(
      FATAL_ERROR "Failed to configure warnings for `${CMAKE_CXX_COMPILER_ID}`")
  endif()

  target_compile_options(${project_name} INTERFACE ${project_warnings})
endfunction()
