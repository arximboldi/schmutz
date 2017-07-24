
#  Config
#  ======

set(CATCH_INCLUDE_DIR "${DEPS_DIR}/Source/catch/single_include")

set(GGSPEC "${DEPS_DIR}/Source/ggspec/ggspec")
set(GGSPEC_MODULE_DIR "${DEPS_DIR}/Source")

#  Dependencies
#  ============

add_custom_target(deps-test COMMENT "Get test dependencies")
add_dependencies(deps deps-test)

schmutz_external_dep_nobuild(deps-test catch
  # GIT_REPOSITORY git@github.com:philsquared/Catch.git
  # This fork has --break for GDB
  GIT_REPOSITORY https://github.com/lorenzhs/Catch.git)

schmutz_external_dep_nobuild(deps-test ggspec
  GIT_REPOSITORY https://github.com/yawaramin/ggspec.git)

#  Targets
#  =======

add_custom_target(tests
  COMMENT "Build all the unit tests.")
add_dependencies(tests examples)
add_dependencies(check tests)

# Build and run C++ unit tests
file(GLOB_RECURSE schmutz_unit_tests "*.test.cpp")
foreach(_file IN LISTS schmutz_unit_tests)
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

# Build Guile extensions and run all guile unit tests
file(GLOB_RECURSE schmutz_unit_tests "*.scm.cpp")
foreach(_file IN LISTS schmutz_unit_tests)
  schmutz_target_name_for(_target _output "${_file}")
  add_executable(${_target} EXCLUDE_FROM_ALL "${_file}")
  add_dependencies(tests ${_target})
  set_target_properties(${_target} PROPERTIES OUTPUT_NAME ${_output})
  target_link_libraries(${_target} PUBLIC schmutz)
endforeach()
add_test("test/ggspec" ${GGSPEC})
set_tests_properties("test/ggspec" PROPERTIES
  ENVIRONMENT GUILE_LOAD_PATH=${GGSPEC_MODULE_DIR})
