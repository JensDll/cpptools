include_guard()

include(ProjectOptions)

function(project_options_defaults)
  option(ENABLE_DEVELOPER_MODE
         "Configure project options with recommended default for development."
         OFF)

  if(ENABLE_DEVELOPER_MODE)
    message(
      STATUS
        "Developer mode is ON. For production, please use `-DENABLE_DEVELOPER_MODE:BOOL=OFF`"
    )
  else()
    message(
      STATUS
        "Developer mode is OFF. For developement, please use `-DENABLE_DEVELOPER_MODE:BOOL=ON`"
    )
    message(STATUS "Treating all warnings as errors")

    set(CMAKE_COMPILE_WARNING_AS_ERROR
        ON
        CACHE BOOL "Treat warnings as errors" FORCE)
  endif()

  if(CMAKE_CXX_COMPILER_ID MATCHES ".*Clang.*" OR CMAKE_CXX_COMPILER_ID MATCHES
                                                  ".*GNU.*")
    set(SUPPORTS_ASAN ON)
    set(SUPPORTS_UBSAN ON)
  endif()

  if(WIN32)
    set(SUPPORTS_ASAN OFF)
    set(SUPPORTS_UBSAN OFF)
  endif()

  if(CMAKE_GENERATOR MATCHES ".*Makefile*." OR CMAKE_GENERATOR MATCHES
                                               ".*Ninja*")
    set(MAKEFILE_OR_NINJA ON)
  else()
    set(MAKEFILE_OR_NINJA OFF)
  endif()

  include(CMakeDependentOption)

  # <option name>;<user mode default>;<developer mode default>;<description>
  set(options
      "ENABLE_CACHE\;${MAKEFILE_OR_NINJA}\;${MAKEFILE_OR_NINJA}\;Enable ccache on Unix"
      "ENABLE_CLANG_TIDY\;OFF\;${MAKEFILE_OR_NINJA}\;Enable clang-tidy analysis during compilation"
      "ENABLE_CPPCHECK\;OFF\;${MAKEFILE_OR_NINJA}\;Enable cppcheck analysis during compilation"
      "ENABLE_SANITIZER_ADDRESS\;OFF\;${SUPPORTS_ASAN}\;Make memory errors into hard runtime errors (windows/linux/macos)"
      "ENABLE_SANITIZER_UNDEFINED_BEHAVIOR\;OFF\;${SUPPORTS_UBSAN}\;Make certain types (numeric mostly) of undefined behavior into runtime errors"
      "ENABLE_SANITIZER_LEAK\;OFF\;OFF\;Make memory leaks into hard runtime errors"
      "ENABLE_SANITIZER_THREAD\;OFF\;OFF\;Make thread race conditions into hard runtime errors"
      "ENABLE_SANITIZER_MEMORY\;OFF\;OFF\;Make other memory errors into runtime errors"
  )

  foreach(option IN LISTS options)
    list(GET option 0 option_name)
    list(GET option 1 option_user_default)
    list(GET option 2 option_developer_default)
    list(GET option 3 option_description)

    if(DEFINED ${option_name}_DEFAULT)
      if(DEFINED ${option_name}_DEVELOPER_DEFAULT
         OR DEFINED ${option_name}_USER_DEFAULT)
        message(
          FATAL_ERROR
            "You have separately defined user/developer defaults and general defaults for ${option_name}. Please either provide a general default OR separate developer/user overrides."
        )
      endif()

      set(option_user_default ${${option_name}_DEFAULT})
      set(option_developer_default ${${option_name}_DEFAULT})
    endif()

    if(DEFINED ${option_name}_USER_DEFAULT)
      set(option_user_default ${${option_name}_USER_DEFAULT})
    endif()

    if(DEFINED ${option_name}_DEVELOPER_DEFAULT)
      set(option_developer_default ${${option_name}_DEVELOPER_DEFAULT})
    endif()

    cmake_dependent_option(
      OPT_${option_name}
      "${option_description}"
      ${option_developer_default}
      ENABLE_DEVELOPER_MODE
      ${option_user_default})

    if(OPT_${option_name})
      message(DEBUG "+ `${option_name}`")
      set(${option_name}_VALUE ${option_name})
    else()
      message(DEBUG "- `${option_name}`")
      unset(${option_name}_VALUE)
    endif()
  endforeach()

  project_options(
    ${ENABLE_CACHE_VALUE}
    ${ENABLE_CLANG_TIDY_VALUE}
    ${ENABLE_CPPCHECK_VALUE}
    ${ENABLE_SANITIZER_ADDRESS_VALUE}
    ${ENABLE_SANITIZER_UNDEFINED_BEHAVIOR_VALUE}
    ${ENABLE_SANITIZER_LEAK_VALUE}
    ${ENABLE_SANITIZER_THREAD_VALUE}
    ${ENABLE_SANITIZER_MEMORY_VALUE}
    ${ARGN})

  propagate_required_vars_to_parent()
endfunction()
