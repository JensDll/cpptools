if(CMAKE_CXX_COMPILER_ID MATCHES ".*Clang")
  set(is_clang_compiler ON)
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
  set(is_gnu_compiler ON)
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

add_compile_definitions($<$<PLATFORM_ID:Windows>:IS_WINDOWS>)

# See Professional CMake: A Practical Guide 13th Edition, ch. 17
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_LINK_LIBRARIES_ONLY_TARGETS ON)

function(configure_common project_name)
  if(is_clang_compiler)
    target_compile_options(${project_name} INTERFACE -fcolor-diagnostics)
  elseif(is_gnu_compiler)
    target_compile_options(${project_name} INTERFACE -fdiagnostics-color=always)
  endif()
endfunction()
