function(enable_clang_tidy)
  find_program(CLANGTIDY clang-tidy)

  if(NOT CLANGTIDY)
    message(WARNING "clang-tidy requested but executable not found")
    return()
  endif()

  set(CMAKE_CXX_CLANG_TIDY
      ${CLANGTIDY}
      -checks=-*
      clang-analyzer-*
      readability-*
      modernize-*
      performance-*
      cppcoreguidelines-*)

  set(CMAKE_C_CLANG_TIDY ${CMAKE_CXX_CLANG_TIDY})

  if(NOT
     "${CMAKE_CXX_STANDARD}"
     STREQUAL
     "")
    if("${CMAKE_CXX_CLANG_TIDY_DRIVER_MODE}" STREQUAL "cl")
      set(CMAKE_CXX_CLANG_TIDY ${CMAKE_CXX_CLANG_TIDY}
                               -extra-arg=/std:c++${CMAKE_CXX_STANDARD})
    else()
      set(CMAKE_CXX_CLANG_TIDY ${CMAKE_CXX_CLANG_TIDY}
                               -extra-arg=-std=c++${CMAKE_CXX_STANDARD})
    endif()
  endif()

  if(NOT
     "${CMAKE_C_STANDARD}"
     STREQUAL
     "")
    if("${CMAKE_C_CLANG_TIDY_DRIVER_MODE}" STREQUAL "cl")
      set(CMAKE_C_CLANG_TIDY ${CMAKE_C_CLANG_TIDY}
                             -extra-arg=/std:c${CMAKE_C_STANDARD})
    else()
      set(CMAKE_C_CLANG_TIDY ${CMAKE_C_CLANG_TIDY}
                             -extra-arg=-std=c${CMAKE_C_STANDARD})
    endif()
  endif()

endfunction()
