cmake_minimum_required(VERSION 3.22)

# 选项设置
option(USE_LL_LIB "Use LL library instead of HAL" OFF)
option(ENABLE_PRINTF_FLOAT "Enable printf float %f support" OFF)
option(USE_FREERTOS "Build with FreeRTOS" OFF)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Check if SELECTED_DEVICE is provided
if(NOT DEFINED SELECTED_DEVICE)
    message(FATAL_ERROR "Please specify the target device using -DSELECTED_DEVICE=<device> (e.g., -DPY32F030x8)")
endif()

# todo)) For the time being, I have not sorted out the relationship between each model and the ld file, so I will assign them directly first, and some models may have errors
set(MCU_TYPE ${SELECTED_DEVICE}) # PY32F002Ax5, PY32F002Bx5, PY32F003x4, PY32F003x6, PY32F003x8, PY32F030x6, PY32F030x8, PY32F072xB

if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Debug")
endif()

include("cmake/gcc-arm-none-eabi.cmake")

# Enable compile command to ease indexing with e.g. clangd
set(CMAKE_EXPORT_COMPILE_COMMANDS TRUE)

# Enable CMake support for ASM and C languages
enable_language(C ASM CXX)

# 项目名称和版本
project(PY32F0xx_Template VERSION 1.0)

# 启用printf float支持
if(ENABLE_PRINTF_FLOAT)
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -u _printf_float")
endif()

add_executable(${CMAKE_PROJECT_NAME})

# 根据选择的宏定义添加编译选项
if(SELECTED_DEVICE)
    target_compile_definitions(${CMAKE_PROJECT_NAME} PUBLIC
            ${SELECTED_DEVICE}
    )
    message("Selected device: ${SELECTED_DEVICE}")
endif ()

target_compile_definitions(${CMAKE_PROJECT_NAME} PUBLIC
)

add_subdirectory(cmake/PY32F0xxLib)

# Link directories setup
target_link_directories(${CMAKE_PROJECT_NAME} PRIVATE
        # Add user defined library search paths
)

# Add sources to executable
target_sources(${CMAKE_PROJECT_NAME} PRIVATE
        User/py32f0xx_hal_msp.c
        User/py32f0xx_it.c
        User/main.c
)

# Add include paths
target_include_directories(${CMAKE_PROJECT_NAME} PRIVATE
        User
)

# Add project symbols (macros)
target_compile_definitions(${CMAKE_PROJECT_NAME} PRIVATE
        # Add user defined symbols
)

target_link_libraries(${CMAKE_PROJECT_NAME}
        PY32F0xxLib
)

# Add custom command to convert .elf to .bin
add_custom_command(
        TARGET ${CMAKE_PROJECT_NAME} POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E echo "Converting ${CMAKE_PROJECT_NAME} to binary..."
        COMMAND ${CMAKE_OBJCOPY} -O binary $<TARGET_FILE:${CMAKE_PROJECT_NAME}> ${CMAKE_BINARY_DIR}/${CMAKE_PROJECT_NAME}.bin
        WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
        COMMAND ${CMAKE_COMMAND} -E echo "Erase ${SELECTED_DEVICE} ..."
        COMMAND ${CMAKE_COMMAND} -E env pyocd erase -t ${SELECTED_DEVICE} --chip --config ${PROJECT_SOURCE_DIR}/Misc/pyocd.yaml
        COMMAND ${CMAKE_COMMAND} -E echo "Flash ${CMAKE_PROJECT_NAME} to ${SELECTED_DEVICE}"
        COMMAND ${CMAKE_COMMAND} -E env  pyocd load ${CMAKE_BINARY_DIR}/${CMAKE_PROJECT_NAME}.bin -t ${SELECTED_DEVICE} --config ${PROJECT_SOURCE_DIR}/Misc/pyocd.yaml
        COMMENT "Converting to binary"
)
