cmake_minimum_required(VERSION 3.5.1)
cmake_policy(SET CMP0048 NEW) # enable project VERSION
cmake_policy(SET CMP0056 NEW) # honor link flags in try_compile()
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

project(schmutz VERSION 0.0.0)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED on)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Werror")
set(CMAKE_EXPORT_COMPILE_COMMANDS on)
set(CMAKE_CXX_EXTENSIONS off)

#  Options
#  =======

set(DEPS_DIR "${CMAKE_BINARY_DIR}/deps")

option(SCHMUTZ_ENABLE_COVERAGE "compile with test coverage support")

include(SchmutzUtils)

#  Dependencies
#  ============

include(ExternalProject)

set_directory_properties(PROPERTIES EP_BASE "${DEPS_DIR}")

add_custom_target(deps COMMENT "Download and prepare dependencies")
add_custom_target(deps-core COMMENT "Get core dependencies")
add_dependencies(deps deps-core)

find_package(Threads)
find_package(PkgConfig)
pkg_check_modules(Guile guile-2.2)

find_program(CCACHE ccache)
if (CCACHE)
  message(STATUS "Using ccache: ${CCACHE}")
  set_property(GLOBAL PROPERTY RULE_LAUNCH_COMPILE ${CCACHE})
  set_property(GLOBAL PROPERTY RULE_LAUNCH_LINK ${CCACHE})
else()
  message(STATUS "Could not find ccache")
endif()

#  Targets
#  =======

add_library(schmutz INTERFACE)
target_include_directories(schmutz INTERFACE
  $<BUILD_INTERFACE:${schmutz_BINARY_DIR}/>
  $<BUILD_INTERFACE:${schmutz_SOURCE_DIR}/>
  $<INSTALL_INTERFACE:include>)

if (SCHMUTZ_ENABLE_COVERAGE)
  target_compile_options(schmutz INTERFACE "--coverage")
  target_link_libraries(schmutz INTERFACE "--coverage")
endif()

#  Testing
#  =======

enable_testing()

add_custom_target(check
  COMMAND ${CMAKE_CTEST_COMMAND} --output-on-failure
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
  COMMENT "Buld and run all the tests and examples.")

add_subdirectory(test)
add_subdirectory(example)
add_subdirectory(doc)