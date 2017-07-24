
#  Config
#  ======

set(GUILE "guile")

#  Targets
#  =======

add_custom_target(examples
  COMMENT "Build all examples.")
add_dependencies(check examples)

file(GLOB_RECURSE schmutz_examples "*.scm.cpp")
foreach(_file IN LISTS schmutz_examples)
  schmutz_target_name_for(_target _output "${_file}")
  # build the library.so file
  add_library(${_target} SHARED EXCLUDE_FROM_ALL "${_file}")
  add_dependencies(examples ${_target})
  set_target_properties(${_target} PROPERTIES OUTPUT_NAME ${_output})
  target_link_libraries(${_target} PUBLIC schmutz)
  # build the library.scm file
  set(GUILE_EXTENSION_DIR ${CMAKE_CURRENT_BINARY_DIR})
  configure_file(${_output}.scm.in ${_output}.scm)
  # add test that uses the library
  add_test("example/${_output}"
    ${GUILE} ${CMAKE_CURRENT_SOURCE_DIR}/${_output}-use.scm)
  set_tests_properties("example/${_output}" PROPERTIES
    ENVIRONMENT GUILE_LOAD_PATH=${CMAKE_BINARY_DIR})
endforeach()
