
#  Config
#  ======

set(GUILE "guile")

#  Targets
#  =======

add_custom_target(tests
  COMMENT "Build all the unit tests.")
add_dependencies(check tests)

# Build Guile extensions.
#
# An extension should provide a *.scm.cpp file with the C++ part and a
# *.scm.in with the Scheme part
file(GLOB_RECURSE schmutz_unit_test_modules "*.scm.cpp")
foreach(_file IN LISTS schmutz_unit_test_modules)
  schmutz_target_name_for(_target _output "${_file}")
  add_library(${_target} SHARED EXCLUDE_FROM_ALL "${_file}")
  add_dependencies(tests ${_target})
  set_target_properties(${_target} PROPERTIES OUTPUT_NAME ${_output})
  target_link_libraries(${_target} PUBLIC schmutz)
  configure_file(${_output}.scm.in ${_output}.scm)
endforeach()

# Run each .scm file separatelly as a test
file(GLOB_RECURSE schmutz_scm_unit_tests "*.scm")
foreach(_file IN LISTS schmutz_scm_unit_tests)
  schmutz_target_name_for(_target _output "${_file}")
  add_test("test/${_output}" ${GUILE} ${_file})
  set_tests_properties("test/${_output}" PROPERTIES
    ENVIRONMENT GUILE_LOAD_PATH=${CMAKE_BINARY_DIR})
endforeach()
