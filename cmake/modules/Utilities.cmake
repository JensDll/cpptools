include_guard()

macro(set_local_and_parent_scope name value)
  set(${name} ${value})
  set(${name}
      ${value}
      PARENT_SCOPE)
endmacro()

function(assure_out_of_source_build)
  # Make sure to resolve possible symlinks
  file(REAL_PATH ${CMAKE_SOURCE_DIR} src_dir)
  file(REAL_PATH ${CMAKE_BINARY_DIR} bin_dir)

  # Disallow in-source builds
  if("${src_dir}" STREQUAL "${bin_dir}")
    message(FATAL_ERROR "In-source builds are disabled.
        Please create a separate build directory and run cmake from there")
  endif()
endfunction()
