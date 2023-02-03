cmake_minimum_required(VERSION 3.10)
option(BUILD_SHARED_LIBS "Build Shared Libs" ON)

project(lodepng LANGUAGES C)
set(LODEPNG_SRC lodepng/lodepng.c)
add_library(lodepng SHARED ${LODEPNG_SRC})
target_compile_options(lodepng PRIVATE -W -Wall -Wextra -ansi -pedantic -O3)

if (NOT UNIX)
    target_link_libraries(lodepng PUBLIC -static)
endif (UNIX)

install(TARGETS lodepng
    RUNTIME DESTINATION "${CMAKE_SOURCE_DIR}"
    LIBRARY DESTINATION "${CMAKE_SOURCE_DIR}"
)