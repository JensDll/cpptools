# Building with CMake example

```bash
cmake -S ./modules/algorithms/ -B out --log-context \
  -DENABLE_DEVELOPER_MODE=OFF \
  -DCMAKE_BUILD_TYPE=Release
```

```bash
cmake --build ./out/ -j $(nproc)
```

```bash
cmake -DCMAKE_INSTALL_PREFIX=./install -P ./out/cmake_install.cmake
```
