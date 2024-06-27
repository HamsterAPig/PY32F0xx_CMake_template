cmake_minimum_required(VERSION 3.22)

project(PY32F0xxLib)
add_library(${PROJECT_NAME} INTERFACE)

# Enable CMake support for ASM and C languages
enable_language(C ASM)

target_compile_definitions(${PROJECT_NAME} INTERFACE
        $<$<CONFIG:Debug>:DEBUG>
)

target_include_directories(${PROJECT_NAME} INTERFACE
        ../../Libraries/CMSIS/Core/Include
        ../../Libraries/CMSIS/Device/PY32F0xx/Include
        ../../Libraries/CMSIS/DSP/Include
        ../../Libraries/CMSIS/DSP/Include/dsp
        ../../Libraries/PY32F0xx_HAL_Driver/Inc
        ../../Libraries/PY32F0xx_HAL_BSP/Inc
)

target_sources(${PROJECT_NAME} INTERFACE
        ../../Libraries/CMSIS/Device/PY32F0xx/Source/system_py32f0xx.c
        ../../Libraries/CMSIS/Device/PY32F0xx/Source/gcc/startup_py32f030.s
        ../../Libraries/PY32F0xx_HAL_BSP/Src/py32f0xx_bsp_clock.c
        ../../Libraries/PY32F0xx_HAL_BSP/Src/py32f0xx_bsp_led.c
        ../../Libraries/PY32F0xx_HAL_BSP/Src/py32f0xx_bsp_printf.c
        ../../Libraries/PY32F0xx_HAL_Driver/Src/py32f0xx_hal.c
        ../../Libraries/PY32F0xx_HAL_Driver/Src/py32f0xx_hal_adc.c
        ../../Libraries/PY32F0xx_HAL_Driver/Src/py32f0xx_hal_adc_ex.c
        ../../Libraries/PY32F0xx_HAL_Driver/Src/py32f0xx_hal_comp.c
        ../../Libraries/PY32F0xx_HAL_Driver/Src/py32f0xx_hal_cortex.c
        ../../Libraries/PY32F0xx_HAL_Driver/Src/py32f0xx_hal_crc.c
        ../../Libraries/PY32F0xx_HAL_Driver/Src/py32f0xx_hal_dma.c
        ../../Libraries/PY32F0xx_HAL_Driver/Src/py32f0xx_hal_exti.c
        ../../Libraries/PY32F0xx_HAL_Driver/Src/py32f0xx_hal_flash.c
        ../../Libraries/PY32F0xx_HAL_Driver/Src/py32f0xx_hal_gpio.c
        ../../Libraries/PY32F0xx_HAL_Driver/Src/py32f0xx_hal_i2c.c
        ../../Libraries/PY32F0xx_HAL_Driver/Src/py32f0xx_hal_irda.c
        ../../Libraries/PY32F0xx_HAL_Driver/Src/py32f0xx_hal_iwdg.c
        ../../Libraries/PY32F0xx_HAL_Driver/Src/py32f0xx_hal_led.c
        ../../Libraries/PY32F0xx_HAL_Driver/Src/py32f0xx_hal_lptim.c
        ../../Libraries/PY32F0xx_HAL_Driver/Src/py32f0xx_hal_pwr.c
        ../../Libraries/PY32F0xx_HAL_Driver/Src/py32f0xx_hal_rcc.c
        ../../Libraries/PY32F0xx_HAL_Driver/Src/py32f0xx_hal_rcc_ex.c
        ../../Libraries/PY32F0xx_HAL_Driver/Src/py32f0xx_hal_rtc.c
        ../../Libraries/PY32F0xx_HAL_Driver/Src/py32f0xx_hal_rtc_ex.c
        ../../Libraries/PY32F0xx_HAL_Driver/Src/py32f0xx_hal_spi.c
        ../../Libraries/PY32F0xx_HAL_Driver/Src/py32f0xx_hal_tim.c
        ../../Libraries/PY32F0xx_HAL_Driver/Src/py32f0xx_hal_tim_ex.c
        ../../Libraries/PY32F0xx_HAL_Driver/Src/py32f0xx_hal_uart.c
        ../../Libraries/PY32F0xx_HAL_Driver/Src/py32f0xx_hal_usart.c
        ../../Libraries/PY32F0xx_HAL_Driver/Src/py32f0xx_hal_wwdg.c
)