cmake_minimum_required(VERSION 3.18)

project("cpp-iterative-parser")

option(BUILD_EMSCRIPTEN OFF BOOL)
if (BUILD_EMSCRIPTEN)
    include("cmake/AddEmscriptenTarget.cmake")
else()
    add_executable(${PROJECT_NAME}
        "src/main.cpp"
    )

    # target_link_libraries(${PROJECT_NAME} portaudio_static)
    target_link_options(${PROJECT_NAME} PRIVATE "-static")
endif()






