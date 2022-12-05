FetchContent_Declare(
  Catch2
  GIT_REPOSITORY https://github.com/catchorg/Catch2.git
  # https://github.com/catchorg/Catch2/releases/tag/v3.1.1
  GIT_TAG 5df88da16e276f853cc0c45f4b570419be77dd43)

FetchContent_MakeAvailable(Catch2)

list(APPEND CMAKE_MODULE_PATH "${catch2_SOURCE_DIR}/extras")

include(CTest)
include(Catch)
