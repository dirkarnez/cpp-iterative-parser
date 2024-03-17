set(PROJECT_NAME_EMSCRIPTEN "${PROJECT_NAME}_emscripten")

find_package(Git)
if(Git_FOUND)
    message("Git found: ${GIT_EXECUTABLE}")
else()
    message(FATAL "Git Not Found")
endif()

find_package(Python)
if(Python_FOUND)
    message("Python found: ${Python_EXECUTABLE}")
else()
    message(FATAL "Python Not Found")
endif()

execute_process(COMMAND 
    ${GIT_EXECUTABLE} clone
    --recurse-submodules
    https://github.com/emscripten-core/emsdk.git
)

execute_process(COMMAND 
    ${GIT_EXECUTABLE} 
    checkout 
    3.1.56 
    WORKING_DIRECTORY emsdk
)

set(EMSDK "${CMAKE_SOURCE_DIR}\\emsdk")
set(EMSDK_NODE_BIN_DIR "${EMSDK}\\node\\16.20.0_64bit\\bin")
set(EMSDK_NODE_EXECUTABLE "${EMSDK_NODE_BIN_DIR}\\node.exe")
set(EMSDK_PYTHON "${EMSDK}\\python\\3.9.2-nuget_64bit\\python.exe")
set(JAVA_HOME "${EMSDK}\\java\\8.152_64bit")
set(EMSDK_EMSCRIPTEN_DIR "${EMSDK}\\upstream\\emscripten")
set(CMAKE_TOOLCHAIN_FILE "${EMSDK_EMSCRIPTEN_DIR}/cmake/Modules/Platform/Emscripten.cmake")

set(ENV{PATH} "$ENV{PATH};${EMSDK};${EMSDK_EMSCRIPTEN_DIR};${EMSDK_NODE_BIN_DIR};")

execute_process(COMMAND 
    emsdk.bat 
    "install" 
    "latest"
    WORKING_DIRECTORY emsdk
)

execute_process(COMMAND 
    emsdk.bat 
    "activate" 
    "latest"
    WORKING_DIRECTORY emsdk
)

add_executable(${PROJECT_NAME_EMSCRIPTEN} 
    "src/main.cpp"
)

target_link_options(${PROJECT_NAME_EMSCRIPTEN} PRIVATE "-static")

set_target_properties(${PROJECT_NAME_EMSCRIPTEN} PROPERTIES LINK_FLAGS "-sDEMANGLE_SUPPORT=1 --bind")