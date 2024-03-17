cpp-iterative-parser
====================
### Notes
- Only Python is additionally required for Emscripten build (emsdk will fetch Java, etc.)
- Currently CMakeLists only support either one target, multiple target WIP
    - add `-DBUILD_EMSCRIPTEN=ON -DCMAKE_TOOLCHAIN_FILE="emsdk/upstream/emscripten/cmake/Modules/Platform/Emscripten.cmake"` for Emscripten build