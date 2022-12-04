include_guard()

function(clang_tidy target)
  find_program(clang_tidy_path clang-tidy)

  if(NOT clang_tidy_path)
    message(FATAL_ERROR "clang-tidy requested but executable not found")
  endif()

  if(NOT IS_CLANG_COMPILER)
    message(
      FATAL_ERROR
        "clang-tidy cannot be enabled with non-clang compiler. Please select an appropriate toolchain"
    )
  endif()

  set(cxx_clang_tidy ${clang_tidy_path} -extra-arg=-Wno-unknown-warning-option)

  if(CMAKE_COMPILE_WARNING_AS_ERROR)
    list(APPEND cxx_clang_tidy -warnings-as-errors=*)
  endif()

  set(c_clang_tidy ${cxx_clang_tidy})

  if(DEFINED CMAKE_CXX_STANDARD)
    if("${CMAKE_CXX_CLANG_TIDY_DRIVER_MODE}" STREQUAL "cl")
      list(APPEND cxx_clang_tidy -extra-arg=/std:c++${CMAKE_CXX_STANDARD})
    else()
      list(APPEND cxx_clang_tidy -extra-arg=-std=c++${CMAKE_CXX_STANDARD})
    endif()
  endif()

  if(DEFINED CMAKE_C_STANDARD)
    if("${CMAKE_C_CLANG_TIDY_DRIVER_MODE}" STREQUAL "cl")
      list(APPEND c_clang_tidy -extra-arg=/std:c${CMAKE_C_STANDARD})
    else()
      list(APPEND c_clang_tidy -extra-arg=-std=c${CMAKE_C_STANDARD})
    endif()
  endif()

  set_target_properties(${target} PROPERTIES CXX_CLANG_TIDY "${cxx_clang_tidy}"
                                             C_CLANG_TIDY "${c_clang_tidy}")

endfunction()

function(configure_cppcheck)

endfunction()
