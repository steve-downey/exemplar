# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
{% set identity = "identity" if cookiecutter._generating_exemplar else "todo" %}

{% if cookiecutter.unit_test_library == "gtest" %}
find_package(GTest REQUIRED)
{% elif cookiecutter.unit_test_library == "catch2" %}
find_package(Catch2 3 REQUIRED)
{% endif %}

add_executable(beman.{{cookiecutter.__project_ident}}.tests.{{identity}})
target_sources(beman.{{cookiecutter.__project_ident}}.tests.{{identity}} PRIVATE {{identity}}.test.cpp)
target_link_libraries(
    beman.{{cookiecutter.__project_ident}}.tests.{{identity}}
{% if cookiecutter.unit_test_library == "gtest" %}
    PRIVATE beman::{{cookiecutter.__project_ident}} GTest::gtest_main
{% elif cookiecutter.unit_test_library == "catch2" %}
    PRIVATE beman::{{cookiecutter.__project_ident}} Catch2::Catch2WithMain
{% endif %}
)
if(BEMAN_{{cookiecutter.__project_ident.upper()}}_USE_MODULES)
    set_target_properties(
        beman.{{cookiecutter.__project_ident}}.tests.{{identity}}
        PROPERTIES CXX_MODULE_STD ON
    )
endif()

{% if cookiecutter.unit_test_library == "gtest" %}
include(GoogleTest)
gtest_discover_tests(beman.{{cookiecutter.__project_ident}}.tests.{{identity}} DISCOVERY_TIMEOUT 60)
{% elif cookiecutter.unit_test_library == "catch2" %}
include(Catch)
catch_discover_tests(beman.{{cookiecutter.__project_ident}}.tests.{{identity}})
{% endif %}
