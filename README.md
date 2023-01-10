# Building with CMake example

```bash
cmake -S ./modules/algorithms/ -B out --log-context --log-level=verbose \
  -DENABLE_DEVELOPER_MODE=OFF \
  -DCMAKE_CXX_COMPILER=clang++-14 \
  -DCMAKE_BUILD_TYPE=Release
```

```bash
cmake --build ./out/ -j $(nproc)
```
