
cmake_minimum_required(VERSION 3.20)

# --- Config toolchain (doit être AVANT project()) ---
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)

set(CMAKE_C_COMPILER   arm-none-eabi-gcc)
set(CMAKE_ASM_COMPILER arm-none-eabi-gcc)
set(CMAKE_OBJCOPY      arm-none-eabi-objcopy)
set(CMAKE_SIZE         arm-none-eabi-size)

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

# --- Projet (STM32F103CBT6 — Cortex-M3) ---
project(firmware C ASM)

set(CPU_FLAGS "-mcpu=cortex-m3 -mthumb")

set(CMAKE_C_FLAGS "${CPU_FLAGS} -Wall -Wextra -ffunction-sections -fdata-sections -O0 -g")
set(CMAKE_ASM_FLAGS "${CPU_FLAGS}")

set(LINKER_SCRIPT ${CMAKE_SOURCE_DIR}/linker.ld)

# Pas de -T ici — il est ajouté une seule fois via target_link_options plus bas
set(CMAKE_EXE_LINKER_FLAGS
    "${CPU_FLAGS} --specs=nano.specs --specs=nosys.specs -nostartfiles -Wl,--gc-sections -Wl,-Map=firmware.map"
)

# --- Sources ---
file(GLOB SOURCES CONFIGURE_DEPENDS "src/*.c")

if(NOT SOURCES)
    message(FATAL_ERROR "Aucun fichier .c trouvé dans src/ — vérifie le chemin.")
endif()

message(STATUS "Fichiers sources trouvés : ${SOURCES}")

add_executable(firmware
    startup.s
    ${SOURCES}
)

target_include_directories(firmware PRIVATE
    ${CMAKE_SOURCE_DIR}/include
)

target_link_options(firmware PRIVATE -T${LINKER_SCRIPT})

# --- Post-build : génère le .bin et affiche la taille flash/RAM ---
add_custom_command(TARGET firmware POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} -O binary firmware firmware.bin
    COMMAND ${CMAKE_SIZE} firmware
)

# --- Target de flash via OpenOCD (ST-Link, STM32F1) ---
find_program(OPENOCD openocd REQUIRED)

add_custom_target(flash
    COMMAND ${OPENOCD} -f interface/stlink.cfg -f target/stm32f1x.cfg
            -c "program firmware.bin 0x08000000 verify reset exit"
    DEPENDS firmware
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
)


