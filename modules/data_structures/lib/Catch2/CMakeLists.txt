
FetchContent_Declare(
  Catch2
  GIT_REPOSITORY https://github.com/catchorg/Catch2.git
  # https://github.com/catchorg/Catch2/releases/tag/v3.2.0
  GIT_TAG 65cc7fd2ae39a7a543767f661b096d7d521ee4f0)

FetchContent_MakeAvailable(Catch2)

list(APPEND CMAKE_MODULE_PATH "${catch2_SOURCE_DIR}/extras")

include(CTest)
include(Catch)
