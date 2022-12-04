include(Utilities)
include(Linker)
include(Sanitizers)
include(Warnings)

function(project_options)
  set(options
      ENABLE_USER_LINKER
      ENABLE_SANITIZER_ADDRESS
      ENABLE_SANITIZER_LEAK
      ENABLE_SANITIZER_UNDEFINED_BEHAVIOR
      ENABLE_SANITIZER_THREAD
      ENABLE_SANITIZER_MEMORY)
  set(one_value_args LINKER PREFIX CXX_STANDARD)
  set(multi_value_args "")

  cmake_parse_arguments(
    PARSE_ARGV
    0
    ProjectOptions
    "${options}"
    "${one_value_args}"
    "${multi_value_args}")

  if(DEFINED ProjectOptions_CXX_STANDARD)
    configure_language_requirements(${ProjectOptions_CXX_STANDARD})
  else()
    configure_language_requirements(20)
  endif()

  configure_build_type()

  if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    set_local_and_parent_scope(IS_GNU_COMPILER ON)
  elseif(${CMAKE_CXX_COMPILER_ID} MATCHES ".*Clang")
    set_local_and_parent_scope(IS_CLANG_COMPILER ON)
  endif()

  set(project_options_library project_options)
  set(project_warnings_library project_warnings)

  if(DEFINED ProjectOptions_PREFIX)
    set(project_options_library ${ProjectOptions_PREFIX}_project_options)
    set(project_warnings_library ${ProjectOptions_PREFIX}_project_warnings)
  elseif(TARGET project_options)
    message(
      FATAL_ERROR
        "Multiple calls to `project_options` in the same `project` detected, but the argument `PREFIX` that is prepended to `project_options` and `project_warnings` is not set"
    )
  endif()

  add_library(${project_options_library} INTERFACE)
  add_library(${project_warnings_library} INTERFACE)

  configure_warnings(${project_warnings_library})

  configure_common_settings(${project_options_library})

  configure_linker(${project_options_library} "${ProjectOptions_LINKER}")

  configure_sanitizers(
    ${project_options_library}
    ${ProjectOptions_ENABLE_SANITIZER_ADDRESS}
    ${ProjectOptions_ENABLE_SANITIZER_LEAK}
    ${ProjectOptions_ENABLE_SANITIZER_UNDEFINED_BEHAVIOR}
    ${ProjectOptions_ENABLE_SANITIZER_THREAD}
    ${ProjectOptions_ENABLE_SANITIZER_MEMORY})

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
        "Unsupported CMAKE_BUILD_TYPE `${CMAKE_BUILD_TYPE}`, please select one of `${allowed_build_types}`"
    )
  endif()
endfunction()

# See Professional CMake: A Practical Guide 13th Edition, ch. 17
macro(configure_language_requirements language_standard)
  set_local_and_parent_scope(CMAKE_CXX_STANDARD ${language_standard})
  set(CMAKE_CXX_STANDARD_REQUIRED
      ON
      PARENT_SCOPE)
  set(CMAKE_CXX_EXTENSIONS
      OFF
      PARENT_SCOPE)

  set(CMAKE_EXPORT_COMPILE_COMMANDS
      ON
      PARENT_SCOPE)
  set(CMAKE_LINK_LIBRARIES_ONLY_TARGETS
      ON
      PARENT_SCOPE)
endmacro()

function(configure_common_settings project_name)
  target_compile_definitions(${project_name}
                             INTERFACE $<$<PLATFORM_ID:Windows>:IS_WINDOWS>)
  target_compile_options(
    ${project_name}
    INTERFACE $<$<BOOL:${IS_CLANG_COMPILER}>:-fcolor-diagnostics>
              $<$<BOOL:${IS_GNU_COMPILER}>:-fdiagnostics-color=always>)
endfunction()
