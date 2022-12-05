include_guard()

function(enable_cache)
  set(CACHE_OPTION
      "ccache"
      CACHE STRING "Compiler cache to be used")
  set(allowed_cache_options "ccache" "sccache")
  set_property(CACHE CACHE_OPTION PROPERTY STRINGS ${allowed_cache_options})

  if(NOT
     CACHE_OPTION
     IN_LIST
     allowed_cache_options)
    message(
      FATAL_ERROR
        "Unsupported CACHE_OPTION `${CACHE_OPTION}`. Please select one of `${allowed_cache_options}`."
    )
  endif()

  find_program(cache_path NAMES ${allowed_cache_options})

  if(NOT cache_path)
    message(FATAL_ERROR "cache requested but executable not found.")
  endif()

  message(VERBOSE "Enabling `cache` (${cache_path})")

  set(CMAKE_CXX_COMPILER_LAUNCHER
      ${cache_path}
      CACHE FILEPATH "CXX compiler cache used")
  set(CMAKE_C_COMPILER_LAUNCHER
      ${cache_path}
      CACHE FILEPATH "C compiler cache used")
endfunction()
