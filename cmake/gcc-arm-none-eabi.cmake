set(CMAKE_SYSTEM_NAME               Generic)
set(CMAKE_SYSTEM_PROCESSOR          arm)

set(CMAKE_C_COMPILER_FORCED TRUE)
set(CMAKE_CXX_COMPILER_FORCED TRUE)
set(CMAKE_C_COMPILER_ID GNU)
set(CMAKE_CXX_COMPILER_ID GNU)

# Some default GCC settings
# arm-none-eabi- must be part of path environment
set(TOOLCHAIN_PREFIX                arm-none-eabi-)

set(CMAKE_C_COMPILER                ${TOOLCHAIN_PREFIX}gcc)
set(CMAKE_ASM_COMPILER              ${CMAKE_C_COMPILER})
set(CMAKE_CXX_COMPILER              ${TOOLCHAIN_PREFIX}g++)
set(CMAKE_LINKER                    ${TOOLCHAIN_PREFIX}g++)
set(CMAKE_OBJCOPY                   ${TOOLCHAIN_PREFIX}objcopy)
set(CMAKE_SIZE                      ${TOOLCHAIN_PREFIX}size)

set(CMAKE_EXECUTABLE_SUFFIX_ASM     ".elf")
set(CMAKE_EXECUTABLE_SUFFIX_C       ".elf")
set(CMAKE_EXECUTABLE_SUFFIX_CXX     ".elf")

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

if(CMAKE_BUILD_TYPE MATCHES Debug)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -O0 -g3")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O0 -g3")
endif()

if(CMAKE_BUILD_TYPE MATCHES Release)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Os -g0")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Os -g0")
endif()


set(ARCH_FLAGS "-mthumb -mcpu=cortex-m0plus")
set(DEBUG_FLAGS "-gdwarf-3")
set(CMAKE_C_LINK_FLAGS "${CMAKE_C_LINK_FLAGS} -T \"../Libraries/LDScripts/${MCU_TYPE}.ld\"")
set(CMAKE_C_FLAGS "${ARCH_FLAGS} ${DEBUG_FLAGS} ${OPT_FLAGS} -Wall -ffunction-sections -fdata-sections")
set(CMAKE_CXX_FLAGS "${ARCH_FLAGS} ${DEBUG_FLAGS} ${OPT_FLAGS} -Wall -ffunction-sections -fdata-sections")
set(CMAKE_ASM_FLAGS "${ARCH_FLAGS} ${DEBUG_FLAGS} ${OPT_FLAGS} -Wa,--warn")
set(CMAKE_EXE_LINKER_FLAGS "${ARCH_FLAGS} -specs=nano.specs -specs=nosys.specs -lc -lm -Wl,-Map=${BUILD_DIR}/${PROJECT_NAME}.map -Wl,--gc-sections -Wl,--print-memory-usage")