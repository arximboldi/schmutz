
#  Config
#  ======

set(GUILE "guile")

#  Targets
#  =======

add_custom_target(tests
  COMMENT "Build all the unit tests.")
add_dependencies(check tests)

# Build and run C++ unit tests
file(GLOB_RECURSE schmutz_cpp_unit_tests "*.test.cpp")
foreach(_file IN LISTS schmutz_cpp_unit_tests)
  schmutz_target_name_for(_target _output "${_file}")
  add_executable(${_target} EXCLUDE_FROM_ALL "${_file}")
  set_target_properties(${_target} PROPERTIES OUTPUT_NAME ${_output})
  add_dependencies(tests ${_target})
  target_compile_definitions(${_target} PUBLIC
    CATCH_CONFIG_MAIN)
  target_link_libraries(${_target} PUBLIC
    schmutz
    ${CMAKE_THREAD_LIBS_INIT})
  target_include_directories(${_target} SYSTEM PUBLIC
    ${CATCH_INCLUDE_DIR})
  add_test("test/${_output}" ${_output})
endforeach()

# Build Guile extensions that are needed for the unit tests to run
file(GLOB_RECURSE schmutz_unit_tests "*.scm.cpp")
foreach(_file IN LISTS schmutz_unit_tests)
  schmutz_target_name_for(_target _output "${_file}")
  # build the library.so file
  add_library(${_target} SHARED EXCLUDE_FROM_ALL "${_file}")
  add_dependencies(examples ${_target})
  set_target_properties(${_target} PROPERTIES OUTPUT_NAME ${_output})
  target_link_libraries(${_target} PUBLIC schmutz)
  # build the library.scm file
  set(GUILE_EXTENSION_DIR ${CMAKE_CURRENT_BINARY_DIR})
  configure_file(${_output}.scm.in ${_output}.scm)
endforeach()

file(GLOB_RECURSE schmutz_scm_unit_tests "*.scm")
foreach(_file IN LISTS schmutz_scm_unit_tests)
  schmutz_target_name_for(_target _output "${_file}")
  add_test("test/${_output}" ${GUILE} ${_file})
  set_tests_properties("test/${_output}" PROPERTIES
    ENVIRONMENT GUILE_LOAD_PATH=${GGSPEC_MODULE_DIR}:${CMAKE_BUILD_DIR})
endforeach()
