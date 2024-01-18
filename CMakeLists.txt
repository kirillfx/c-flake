cmake_minimum_required(VERSION 3.27.7)

project(my-app)

# Add the source files from the "src" directory to a variable
file(GLOB SOURCES "src/*.c")

add_executable(${PROJECT_NAME} src/main.c)

install(TARGETS ${PROJECT_NAME} DESTINATION bin)

