include(Utilities)
include(Linker)
include(Sanitizers)
include(Warnings)
include(StaticAnalysis)
include(Cache)

function(project_options)
  set(options
      ENABLE_CLANG_TIDY
      ENABLE_CPPCHECK
      ENABLE_CACHE
      ENABLE_SANITIZER_ADDRESS
      ENABLE_SANITIZER_LEAK
      ENABLE_SANITIZER_UNDEFINED_BEHAVIOR
      ENABLE_SANITIZER_THREAD
      ENABLE_SANITIZER_MEMORY)
  set(one_value_args LINKER PREFIX)
  set(multi_value_args DISABLE_STATIC_ANALYSIS)

  cmake_parse_arguments(
    PARSE_ARGV
    0
    ProjectOptions
    "${options}"
    "${one_value_args}"
    "${multi_value_args}")

  configure_build_type()

  set_property(
    DIRECTORY ${PROJECT_SOURCE_DIR}
    PROPERTY DISABLE_STATIC_ANALYSIS_FOR_TARGETS_CUSTOM_PROP
             ${ProjectOptions_DISABLE_STATIC_ANALYSIS})

  cmake_language(
    DEFER
    DIRECTORY
    ${PROJECT_SOURCE_DIR}
    CALL
    target_disable_static_analysis)

  if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    set(IS_GNU_COMPILER ON)
  elseif(${CMAKE_CXX_COMPILER_ID} MATCHES ".*Clang")
    set(IS_CLANG_COMPILER ON)
  endif()

  set(project_options_library project_options)
  set(project_warnings_library project_warnings)

  if(DEFINED ProjectOptions_PREFIX)
    set(project_options_library ${ProjectOptions_PREFIX}_project_options)
    set(project_warnings_library ${ProjectOptions_PREFIX}_project_warnings)
  elseif(TARGET project_options)
    message(
      FATAL_ERROR
        "Multiple calls to `project_options` in the same `project` detected, but the argument `PREFIX` that is prepended to `project_options` and `project_warnings` is not set."
    )
  endif()

  add_library(${project_options_library} INTERFACE)
  add_library(${project_warnings_library} INTERFACE)

  configure_warnings(${project_warnings_library})

  configure_common(${project_options_library})
  configure_linker(${project_options_library} "${ProjectOptions_LINKER}")
  configure_sanitizers(
    ${project_options_library}
    ${ProjectOptions_ENABLE_SANITIZER_ADDRESS}
    ${ProjectOptions_ENABLE_SANITIZER_LEAK}
    ${ProjectOptions_ENABLE_SANITIZER_UNDEFINED_BEHAVIOR}
    ${ProjectOptions_ENABLE_SANITIZER_THREAD}
    ${ProjectOptions_ENABLE_SANITIZER_MEMORY})

  if(ProjectOptions_ENABLE_CLANG_TIDY)
    enable_clang_tidy()
  endif()

  if(ProjectOptions_ENABLE_CPPCHECK)
    enable_cppcheck()
  endif()

  if(ProjectOptions_ENABLE_CACHE)
    enable_cache()
  endif()

  propagate_required_vars_to_parent()
endfunction()

# See Professional CMake: A Practical Guide 13th Edition, ch. 14.3
function(configure_build_type)
  get_property(is_multi_config GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)

  if(is_multi_config)
    return()
  endif()

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
    message(
      FATAL_ERROR
        "Unsupported CMAKE_BUILD_TYPE `${CMAKE_BUILD_TYPE}`. Please select one of `${allowed_build_types}`."
    )
  endif()
endfunction()

function(configure_common project_name)
  target_compile_definitions(${project_name}
                             INTERFACE $<$<PLATFORM_ID:Windows>:IS_WINDOWS>)
  target_compile_options(
    ${project_name}
    INTERFACE $<$<BOOL:${IS_CLANG_COMPILER}>:-fcolor-diagnostics>
              $<$<BOOL:${IS_GNU_COMPILER}>:-fdiagnostics-color=always>)
endfunction()
