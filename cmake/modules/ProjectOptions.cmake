include(
  "${CMAKE_CURRENT_LIST_DIR}/../functions/assure_out_of_source_build.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/../functions/configure_linker.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/../functions/configure_warnings.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/../functions/configure_clang_tidy.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/../functions/configure_cppcheck.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/../functions/configure_sanitizers.cmake")

function(project_options)
  set(options
      ENABLE_CPPCHECK
      ENABLE_CLANG_TIDY
      ENABLE_USER_LINKE
      ENABLE_SANITIZER_ADDRESS
      ENABLE_SANITIZER_LEAK
      ENABLE_SANITIZER_UNDEFINED_BEHAVIOR
      ENABLE_SANITIZER_THREAD
      ENABLE_SANITIZER_MEMORY)
  set(one_value_args LINKER PREFIX)
  set(multi_value_args CPPCHECK_OPTIONS)

  cmake_parse_arguments(
    PARSE_ARGV
    0
    ProjectOptions
    "${options}"
    "${one_value_args}"
    "${multi_value_args}")

  set(project_options_library project_options)
  set(project_warnings_library project_warnings)

  if(NOT
     "${ProjectOptions_PREFIX}"
     STREQUAL
     "")
    set(project_options_library ${ProjectOptions_PREFIX}_project_options)
    set(project_warnings_library ${ProjectOptions_PREFIX}_project_warnings)
  elseif(TARGET project_options)
    message(
      FATAL_ERROR
        "Multiple calls to `project_options` in the same `project` detected, but the argument `PREFIX` that is prepended to `project_options` and `project_warnings` is not set"
    )
  endif()

  get_property(is_multi_config GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)

  if(is_multi_config)
    # See Professional CMake: A Practical Guide 13th Edition, ch. 14
  else()
    set(allowed_build_types Debug Release RelWithDebInfo)

    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS ${allowed_build_types})

    if(NOT CMAKE_BUILD_TYPE)
      message(
        STATUS "Setting build type to `RelWithDebInfo` as none was specified")

      set(CMAKE_BUILD_TYPE
          RelWithDebInfo
          CACHE STRING "Choose the type of build" FORCE)
    elseif(
      NOT
      CMAKE_BUILD_TYPE
      IN_LIST
      allowed_build_types)
      message(FATAL_ERROR "Unsupported CMAKE_BUILD_TYPE: ${CMAKE_BUILD_TYPE}")
    endif()
  endif()

  add_library(${project_options_library} INTERFACE)
  add_library(${project_warnings_library} INTERFACE)

  target_compile_definitions(${project_options_library}
                             INTERFACE $<$<PLATFORM_ID:Windows>:IS_WINDOWS>)

  configure_warnings(${project_warnings_library})

  configure_linker(${project_options_library} "${ProjectOptions_LINKER}")

  configure_sanitizers(
    ${project_options_library}
    ${ProjectOptions_ENABLE_SANITIZER_ADDRESS}
    ${ProjectOptions_ENABLE_SANITIZER_LEAK}
    ${ProjectOptions_ENABLE_SANITIZER_UNDEFINED_BEHAVIOR}
    ${ProjectOptions_ENABLE_SANITIZER_THREAD}
    ${ProjectOptions_ENABLE_SANITIZER_MEMORY})

  if(${ProjectOptions_ENABLE_CPPCHECK})
    configure_cppcheck("${ProjectOptions_CPPCHECK_OPTIONS}")
  endif()

  if(${ProjectOptions_ENABLE_CLANG_TIDY})
    configure_clang_tidy()
  endif()
endfunction()
