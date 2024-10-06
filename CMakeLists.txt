cmake_minimum_required(VERSION 3.18)

project("cpp-iterative-parser")

option(BUILD_EMSCRIPTEN OFF BOOL)
if (BUILD_EMSCRIPTEN)
    include("cmake/AddEmscriptenTarget.cmake")
else()
    add_executable(${PROJECT_NAME}
        "src/main.cpp"
    )

    if (CMAKE_HOST_SYSTEM_NAME MATCHES "Windows" AND NOT CMAKE_SYSTEM_NAME MATCHES "Emscripten")
        # target_link_libraries(${PROJECT_NAME} ws2_32)
    else()
        # target_link_libraries(${PROJECT_NAME} m)
    endif()
    
    target_link_options(${PROJECT_NAME} PRIVATE "-static")
endif()






