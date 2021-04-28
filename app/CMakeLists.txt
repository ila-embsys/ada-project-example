cmake_minimum_required(VERSION 3.15)

# If we are not the top level project
# we should not make Zephyr init again
if (CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR)
    # Zephyr initialization
    include(${CMAKE_CURRENT_SOURCE_DIR}/../modules/zephyr-cmake-helpers/zephyr.cmake)
endif()

# Application project
# ===================

project(app C CXX ASM ADA)

target_sources(
    app 
    PRIVATE
        src/main.cpp
        src/hello.adb
)
