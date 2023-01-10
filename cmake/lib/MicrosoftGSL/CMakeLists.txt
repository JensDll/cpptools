include_guard()

FetchContent_Declare(
  GSL
  GIT_REPOSITORY "https://github.com/microsoft/GSL"
  # https://github.com/microsoft/GSL/releases/tag/v4.0.0
  GIT_TAG a3534567187d2edc428efd3f13466ff75fe5805c
  GIT_SHALLOW ON)

FetchContent_MakeAvailable(GSL)
