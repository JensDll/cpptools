include_guard()

macro(enable_clang_tidy)
  find_program(CLANG_TIDY_PATH clang-tidy REQUIRED)

  message(VERBOSE "Enabling `clang-tidy` (${CLANG_TIDY_PATH})")

  if(NOT IS_CLANG_COMPILER)
    message(
      FATAL_ERROR
        "clang-tidy cannot be enabled with non-clang compiler. Please select an appropriate toolchain."
    )
  endif()

  set(cxx_clang_tidy ${CLANG_TIDY_PATH} -extra-arg=-Wno-unknown-warning-option)

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

  set(CMAKE_CXX_CLANG_TIDY "${cxx_clang_tidy}")
  set(CMAKE_C_CLANG_TIDY "${c_clang_tidy}")
endmacro()

macro(enable_cppcheck)
  find_program(CPPCHECK_PATH cppcheck REQUIRED)

  message(VERBOSE "Enabling `cppcheck` (${CPPCHECK_PATH})")

  set(cxx_cppcheck
      ${CPPCHECK_PATH}
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

  set(CMAKE_CXX_CPPCHECK "${cxx_cppcheck}")
  set(CMAKE_C_CPPCHECK "${c_cppcheck}")
endmacro()

function(target_disable_clang_tidy target)
  find_program(CLANG_TIDY_PATH clang-tidy)
  if(CLANG_TIDY_PATH)
    message(VERBOSE "Disabling `clang-tidy` for target `${target}`")
    set_target_properties(${target} PROPERTIES C_CLANG_TIDY "" CXX_CLANG_TIDY
                                                               "")
  endif()
endfunction()

function(target_disable_cppcheck target)
  find_program(CPPCHECK_PATH cppcheck)
  if(CPPCHECK_PATH)
    message(VERBOSE "Disabling `cppcheck` for target `${target}`")
    set_target_properties(${target} PROPERTIES C_CPPCHECK "" CXX_CPPCHECK "")
  endif()
endfunction()

function(target_disable_static_analysis)
  if(CMAKE_GENERATOR MATCHES "Visual Studio")
    return()
  endif()

  get_directory_property(
    to_disable DIRECTORY ${PROJECT_SOURCE_DIR}
                         DISABLE_STATIC_ANALYSIS_FOR_TARGETS_CUSTOM_PROP)

  foreach(target IN LISTS ARGN to_disable)
    if(NOT TARGET ${target})
      message(
        WARNING
          "Disabling static analysis for target `${target}`, which does not exist (skipping)"
      )
      continue()
    endif()

    target_disable_clang_tidy(${target})
    target_disable_cppcheck(${target})
  endforeach()
endfunction()
