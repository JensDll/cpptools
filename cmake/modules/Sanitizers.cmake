include_guard()

function(
  configure_sanitizers
  project_name
  enable_sanitizer_address
  enable_sanitizer_leak
  enable_sanitizer_undefined_behavior
  enable_sanitizer_thread
  enable_sanitizer_memory)

  set(sanitizers "")

  if(IS_GNU_COMPILER OR IS_CLANG_COMPILER)
    if(enable_sanitizer_address)
      list(APPEND sanitizers "address")
    endif()

    if(enable_sanitizer_leak)
      list(APPEND sanitizers "leak")
    endif()

    if(enable_sanitizer_undefined_behavior)
      list(APPEND sanitizers "undefined")
    endif()

    if(enable_sanitizer_thread)
      if("address" IN_LIST sanitizers OR "leak" IN_LIST sanitizers)
        message(
          WARNING
            "Thread sanitizer does not work with Address and Leak sanitizer enabled"
        )
      else()
        list(APPEND sanitizers "thread")
      endif()
    endif()

    if(enable_sanitizer_memory AND IS_CLANG_COMPILER)
      message(
        WARNING
          "Memory sanitizer requires all the code (including libc++) to be MSan-instrumented otherwise it reports false positives"
      )

      if("address" IN_LIST sanitizers
         OR "thread" IN_LIST sanitizers
         OR "leak" IN_LIST sanitizers)
        message(
          WARNING
            "Memory sanitizer does not work with Address, Thread, and Leak sanitizers enabled"
        )
      else()
        list(APPEND sanitizers "memory")
      endif()
    endif()
  elseif(MSVC)
    if(${enable_sanitizer_address})
      list(APPEND sanitizers "address")
    endif()

    if(enable_sanitizer_leak
       OR enable_sanitizer_undefined_behavior
       OR enable_sanitizer_thread
       OR enable_sanitizer_memory)
      message(WARNING "MSVC only supports address sanitizer")
    endif()
  endif()

  list(
    JOIN
    sanitizers
    ","
    list_of_sanitizers)

  if(NOT list_of_sanitizers)
    return()
  endif()

  if(NOT MSVC)
    target_compile_options(${project_name}
                           INTERFACE -fsanitize=${list_of_sanitizers})

    target_link_options(${project_name} INTERFACE
                        -fsanitize=${list_of_sanitizers})

    return()
  endif()

  string(FIND "$ENV{PATH}" "$ENV{VSINSTALLDIR}" vs_install_dir_idx)

  if(vs_install_dir_idx EQUAL -1)
    message(
      FATAL_ERROR
        "Using MSVC sanitizers requires setting the MSVC environment before building the project. Please manually open the MSVC command prompt and rebuild the project"
    )
  endif()

  target_compile_options(
    ${project_name} INTERFACE /fsanitize=${list_of_sanitizers} /Zi
                              /INCREMENTAL:NO)

  target_link_options(${project_name} INTERFACE /INCREMENTAL:NO)

endfunction()
