#!/usr/bin/bash

cmake -S ./modules/data_structures/ -B out --log-context \
  -DENABLE_DEVELOPER_MODE=OFF \
  -DCMAKE_BUILD_TYPE=Release

cmake --build ./out/ -j "$(nproc)"

cmake -DCMAKE_INSTALL_PREFIX=./install -P ./out/cmake_install.cmake
