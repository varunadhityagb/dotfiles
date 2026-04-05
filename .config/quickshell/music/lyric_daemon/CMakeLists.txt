cmake_minimum_required(VERSION 3.16)
project(lyric_daemon)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(PkgConfig REQUIRED)

# sdbus-c++
pkg_check_modules(SDBUS REQUIRED sdbus-c++)

# curl
pkg_check_modules(CURL REQUIRED libcurl)

add_executable(lyric_daemon lyric_daemon.cpp)

target_include_directories(lyric_daemon PRIVATE
    ${SDBUS_INCLUDE_DIRS}
    ${CURL_INCLUDE_DIRS}
    ${CMAKE_CURRENT_SOURCE_DIR}
)

target_link_libraries(lyric_daemon PRIVATE
    ${SDBUS_LIBRARIES}
    ${CURL_LIBRARIES}
)

target_compile_options(lyric_daemon PRIVATE
    ${SDBUS_CFLAGS_OTHER}
    ${CURL_CFLAGS_OTHER}
)
