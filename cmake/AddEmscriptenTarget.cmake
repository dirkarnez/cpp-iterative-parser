set(PROJECT_NAME_EMSCRIPTEN "${PROJECT_NAME}-emscripten")

set(EMSDK "${CMAKE_SOURCE_DIR}\\emsdk")
set(EMSDK_NODE_BIN_DIR "${EMSDK}\\node\\16.20.0_64bit\\bin")
set(EMSDK_NODE_EXECUTABLE "${EMSDK_NODE_BIN_DIR}\\node.exe")
set(EMSDK_PYTHON "${EMSDK}\\python\\3.9.2-nuget_64bit\\python.exe")
set(JAVA_HOME "${EMSDK}\\java\\8.152_64bit")
set(EMSDK_EMSCRIPTEN_DIR "${EMSDK}\\upstream\\emscripten")

set(ENV{PATH} "$ENV{PATH};${EMSDK};${EMSDK_EMSCRIPTEN_DIR};${EMSDK_NODE_BIN_DIR};")

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

if(NOT EXISTS "${EMSDK}")
    execute_process(COMMAND 
        ${GIT_EXECUTABLE} clone
        --recurse-submodules
        https://github.com/emscripten-core/emsdk.git
    )
endif()

execute_process(COMMAND 
    ${GIT_EXECUTABLE} 
    checkout 
    3.1.56 
    WORKING_DIRECTORY emsdk
)

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

set_target_properties(
    ${PROJECT_NAME_EMSCRIPTEN}
    PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/emscripten"
)

set_target_properties(${PROJECT_NAME_EMSCRIPTEN} PROPERTIES LINK_FLAGS "--bind")

target_link_options(${PROJECT_NAME_EMSCRIPTEN} PRIVATE "-static")