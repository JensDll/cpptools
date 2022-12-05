include_guard()

function(configure_linker project_name linker)
  if("${linker}" STREQUAL "")
    return()
  endif()

  include(CheckCXXCompilerFlag)

  set(linker_flag "-fuse-ld=${linker}")

  check_cxx_compiler_flag(${linker_flag} cxx_supports_linker_flag)

  if(cxx_supports_linker_flag)
    message(VERBOSE "Using linker `${linker}`")
    target_compile_options(${project_name} INTERFACE ${linker_flag})
  endif()
endfunction()
