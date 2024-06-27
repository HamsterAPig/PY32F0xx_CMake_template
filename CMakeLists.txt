cmake_minimum_required(VERSION 3.22)

# 选项设置
option(USE_LL_LIB "Use LL library instead of HAL" OFF)
option(ENABLE_PRINTF_FLOAT "Enable printf float %f support" OFF)
option(USE_FREERTOS "Build with FreeRTOS" OFF)
option(USE_DSP "Build with CMSIS DSP functions" OFF)
option(USE_EPAPER "Build with Waveshare e-paper lib" OFF)

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

## 包含目录
#include_directories(
#        Libraries/CMSIS/Core/Include
#        Libraries/CMSIS/Device/PY32F0xx/Include
#        User
#)
#
## 源文件目录
#file(GLOB_RECURSE CSOURCES "User/*.c")
#file(GLOB_RECURSE CPPSOURCES "User/*.cpp")
#file(GLOB_RECURSE ASOURCES "User/*.s")
#
## 添加FreeRTOS库
#if(USE_FREERTOS)
#    file(GLOB_RECURSE FREERTOS_SOURCES "Libraries/FreeRTOS/*.c" "Libraries/FreeRTOS/portable/GCC/ARM_CM0/*.c")
#    list(APPEND CSOURCES ${FREERTOS_SOURCES})
#    include_directories(Libraries/FreeRTOS Libraries/FreeRTOS/portable/GCC/ARM_CM0)
#endif()
#
## 添加DSP库
#if(USE_DSP)
#    file(GLOB_RECURSE DSP_SOURCES "Libraries/CMSIS/DSP/Source/*.c")
#    list(APPEND CSOURCES ${DSP_SOURCES})
#    include_directories(Libraries/CMSIS/DSP/Include Libraries/CMSIS/DSP/PrivateInclude)
#endif()
#
## 添加EPaper库
#if(USE_EPAPER)
#    file(GLOB_RECURSE EPAPER_SOURCES "Libraries/EPaper/**/*.c")
#    list(APPEND CSOURCES ${EPAPER_SOURCES})
#    include_directories(Libraries/EPaper/Lib Libraries/EPaper/Examples Libraries/EPaper/Fonts Libraries/EPaper/GUI)
#endif()
#
## 设置目标文件
#add_executable(${PROJECT_NAME}.elf ${CSOURCES} ${CPPSOURCES} ${ASOURCES})

## 设置链接脚本
#set(LDSCRIPT "Libraries/LDScripts/${MCU_TYPE}.ld")
#set_target_properties(${PROJECT_NAME}.elf PROPERTIES LINK_DEPENDS ${LDSCRIPT})
#set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -T${LDSCRIPT}")
#
## 生成二进制文件
#add_custom_command(TARGET ${PROJECT_NAME}.elf POST_BUILD
#        COMMAND ${CMAKE_OBJCOPY} -O binary ${PROJECT_NAME}.elf ${BUILD_DIR}/${PROJECT_NAME}.bin
#        COMMAND ${CMAKE_OBJCOPY} -O ihex ${PROJECT_NAME}.elf ${BUILD_DIR}/${PROJECT_NAME}.hex
#        COMMAND ${CMAKE_SIZE} ${PROJECT_NAME}.elf
#)

## 清理命令
#add_custom_target(clean
#        COMMAND ${CMAKE_COMMAND} -P ${CMAKE_BINARY_DIR}/cmake_clean.cmake
#)
#
## 生成清理文件
#file(WRITE ${CMAKE_BINARY_DIR}/cmake_clean.cmake "
#file(REMOVE_RECURSE ${BUILD_DIR})
#")
