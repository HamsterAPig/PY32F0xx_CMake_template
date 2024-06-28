cmake_minimum_required(VERSION 3.22)

project(PY32F0xxLib)
add_library(${PROJECT_NAME} INTERFACE)

# Enable CMake support for ASM and C languages
enable_language(C ASM)

target_compile_definitions(${PROJECT_NAME} INTERFACE
        $<$<CONFIG:Debug>:DEBUG>
)

if (SELECTED_DEVICE MATCHES "^PY32F002Bx[0-9]$")
    set(MCU_NUMBER "PY32F002B")
elseif (SELECTED_DEVICE MATCHES "^PY32F002Ax[0-9]$" OR SELECTED_DEVICE MATCHES "^PY32F003x[0-9]$" OR SELECTED_DEVICE MATCHES "^PY32F030x[0-9]$")
    set(MCU_NUMBER "PY32F0xx")
elseif (SELECTED_DEVICE MATCHES "^PY32F071x[0-9]$" "^PY32F040x[0-9]$" "^PY32F072x[0-9]$")
    set(MCU_NUMBER "PY32F07x")
else ()
    message(FATAL_ERROR "No match MCU_NUMBER")
endif ()
message("Using ${MCU_NUMBER} Series Lib")

if (SELECTED_DEVICE MATCHES "^PY32F002Bx[0-9]$")
    set(START_FILE_SUFFIX "py32f002b")
elseif(SELECTED_DEVICE MATCHES "^PY32F002Ax[0-9]$")
    set(START_FILE_SUFFIX "py32f002a")
elseif (SELECTED_DEVICE MATCHES "^PY32F003x[0-9]$")
    set(START_FILE_SUFFIX "py32f003")
elseif (SELECTED_DEVICE MATCHES "^PY32F030x[0-9]$")
    set(START_FILE_SUFFIX "py32f030")
elseif (SELECTED_DEVICE MATCHES "^PY32F071x[0-9]$" "^PY32F040x[0-9]$" "^PY32F072x[0-9]$")
    set(START_FILE_SUFFIX "py32f072")
else ()
    message(FATAL_ERROR "No match START_FILE_SUFFIX")
endif ()

target_include_directories(${PROJECT_NAME} INTERFACE
        ../../Libraries/CMSIS/Core/Include
        ../../Libraries/CMSIS/Device/PY32F0xx/Include
)

if(USE_FREERTOS)
    message("Enable FreeRTOS Support")
    target_include_directories(${PROJECT_NAME} INTERFACE
            ../../Libraries/FreeRTOS/include
            ../../Libraries/FreeRTOS/portable/GCC/ARM_CM0
    )
    file(GLOB SOURCES
            "../../Libraries/FreeRTOS/*.c"
            "../../Libraries/FreeRTOS/portable/GCC/ARM_CM0/*.c"
    )
    if (NOT DEFINED FREERTOS_HEAP)
        message("Not Defined FREERTOS_HEAP, default set it -DFREERTOS_HEAP=4")
        set(FREERTOS_HEAP "4")
    endif ()
    list(APPEND SOURCES "../../Libraries/FreeRTOS/portable/MemMang/heap_${FREERTOS_HEAP}.c")
endif ()

if (USE_LL_LIB)
    target_include_directories(${PROJECT_NAME} INTERFACE
            ../../Libraries/${MCU_NUMBER}_LL_Driver/Inc
            ../../Libraries/${MCU_NUMBER}_LL_BSP/Inc
    )
    file(GLOB SOURCES_TMP
            "../../Libraries/${MCU_NUMBER}_LL_BSP/Src/*.c"
            "../../Libraries/${MCU_NUMBER}_LL_Driver/Src/*.c"
    )
    list(APPEND SOURCES ${SOURCES_TMP})
else ()
    target_include_directories(${PROJECT_NAME} INTERFACE
            ../../Libraries/${MCU_NUMBER}_HAL_Driver/Inc
            ../../Libraries/${MCU_NUMBER}_HAL_BSP/Inc
    )
    file(GLOB SOURCES_TMP
            "../../Libraries/${MCU_NUMBER}_HAL_BSP/Src/*.c"
            "../../Libraries/${MCU_NUMBER}_HAL_Driver/Src/*.c"
    )
    list(APPEND SOURCES ${SOURCES_TMP})
endif ()

string(TOLOWER "${MCU_NUMBER}" LOWERCASE_MCU_NUMBER)
message("Using start file is startup_${START_FILE_SUFFIX}.s")
message("Using system file is system_${LOWERCASE_MCU_NUMBER}.c")
target_sources(${PROJECT_NAME} INTERFACE
        ${SOURCES}
        ../../Libraries/CMSIS/Device/PY32F0xx/Source/system_${LOWERCASE_MCU_NUMBER}.c
        ../../Libraries/CMSIS/Device/PY32F0xx/Source/gcc/startup_${START_FILE_SUFFIX}.s
)