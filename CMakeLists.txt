cmake_minimum_required(VERSION 3.27.7)

project(my-app)

# variable references alue in `prject(my-app)`
add_executable(${PROJECT_NAME} src/main.c)

install(TARGETS ${PROJECT_NAME} DESTINATION bin)

