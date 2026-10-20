# Host-side tests for the mmic sample.
#
# Each .cpp file here is treated as an independent test binary whose exit
# status is the pass/fail result (0 = pass). Tests are registered with CTest,
# so after building you can run them all with:
#
#   ctest --test-dir build --output-on-failure
#
# Or run a single binary directly, e.g. ./build/test/verify_test.

set(MMIC_TEST_SOURCES
    verify_test.cpp
)

foreach(test_src IN LISTS MMIC_TEST_SOURCES)
    get_filename_component(test_name ${test_src} NAME_WE)
    add_executable(${test_name} ${test_src})
    target_link_libraries(${test_name} PRIVATE mmic_core)
    target_compile_options(${test_name} PRIVATE -Wall -Wextra)
    add_test(NAME ${test_name} COMMAND ${test_name})
endforeach()
