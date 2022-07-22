cmake_minimum_required(VERSION 3.15)

list(
    APPEND
    CMAKE_MODULE_PATH
    "${CMAKE_CURRENT_LIST_DIR}/modules/zephyr-cmake-helpers/"
    "${CMAKE_CURRENT_LIST_DIR}/app/cmake/"
)

# Helpers boilerplate
include(zephyr_cmake_helpers_init)

## Here you can add modules path to ZEPHYR_EXTRA_MODULES list e.g.
# add_zephyr_extra_modules(
#     PATHS
# )

# Add Zephyr target and app target into scope
include(zephyr)

# Define the top-level project because CMake
# wants it in the top-level CMakeLists.txt
project(app C CXX ASM ADA)

# Go to the actual app
add_subdirectory(app)
