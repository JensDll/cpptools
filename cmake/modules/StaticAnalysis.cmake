include_guard()

macro(enable_clang_tidy)
  find_program(clang_tidy_path clang-tidy)

  message(STATUS "Enabling clang-tidy")

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

  set(CMAKE_CXX_CLANG_TIDY
      "${cxx_clang_tidy}"
      PARENT_SCOPE)

  set(CMAKE_C_CLANG_TIDY
      "${c_clang_tidy}"
      PARENT_SCOPE)

endmacro()

macro(enable_cppcheck)
  find_program(cppcheck_path cppcheck)

  message(STATUS "Enabling cppcheck")

  if(NOT cppcheck_path)
    message(FATAL_ERROR "cppcheck requested but executable not found")
  endif()

  set(cxx_cppcheck
      ${cppcheck_path}
      --enable=style,performance,warning,portability
      --inline-suppr
      --suppress=internalAstError
      --suppress=unmatchedSuppression
      --inconclusive)

  if(CMAKE_COMPILE_WARNING_AS_ERROR)
    list(APPEND cxx_cppcheck --error-exitcode=2)
  endif()

  set(c_cppcheck ${cxx_cppcheck})

  if(DEFINED CMAKE_CXX_STANDARD)
    list(APPEND cxx_cppcheck --std=c++${CMAKE_CXX_STANDARD})
  endif()

  if(DEFINED CMAKE_C_STANDARD)
    list(APPEND c_cppcheck --std=c${CMAKE_C_STANDARD})
  endif()

  set(CMAKE_CXX_CPPCHECK
      "${cxx_cppcheck}"
      PARENT_SCOPE)

  set(CMAKE_C_CPPCHECK
      "${c_cppcheck}"
      PARENT_SCOPE)

endmacro()

function(target_disable_clang_tidy target)
  find_program(clang_tidy_path clang-tidy)
  if(clang_tidy_path)
    set_target_properties(${target} PROPERTIES C_CLANG_TIDY "" CXX_CLANG_TIDY
                                                               "")
  endif()
endfunction()

function(target_disable_cppcheck target)
  find_program(cppcheck_path clang-tidy)
  if(cppcheck_path)
    set_target_properties(${target} PROPERTIES C_CPPCHECK "" CXX_CPPCHECK "")
  endif()
endfunction()

function(target_disable_static_analysis)
  if(CMAKE_GENERATOR MATCHES "Visual Studio")
    return()
  endif()

  foreach(target IN LISTS ARGN)
    if(NOT TARGET ${target})
      message(
        WARNING
          "Trying to disable static analysis for target `${target}`, which doesn't exist"
      )
      continue()
    endif()
    target_disable_clang_tidy(${target})
    target_disable_cppcheck(${target})
  endforeach()
endfunction()
