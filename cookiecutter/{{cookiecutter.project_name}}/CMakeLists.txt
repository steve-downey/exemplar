# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

cmake_minimum_required(VERSION 3.30...4.3)

include(infra/cmake/enable-experimental-import-std.cmake)

project(
    beman.{{cookiecutter.__project_ident}}
    DESCRIPTION "{{cookiecutter.description}}"
    LANGUAGES CXX
{% if cookiecutter._generating_exemplar %}
    VERSION 2.4.1
{% else %}
    VERSION 0.1.0
{% endif %}
)

# [CMAKE.SKIP_TESTS]
option(
    BEMAN_{{cookiecutter.__project_ident.upper()}}_BUILD_TESTS
    "Enable building tests and test infrastructure. Default: ${PROJECT_IS_TOP_LEVEL}. Values: { ON, OFF }."
    ${PROJECT_IS_TOP_LEVEL}
)

# [CMAKE.SKIP_EXAMPLES]
option(
    BEMAN_{{cookiecutter.__project_ident.upper()}}_BUILD_EXAMPLES
    "Enable building examples. Default: ${PROJECT_IS_TOP_LEVEL}. Values: { ON, OFF }."
    ${PROJECT_IS_TOP_LEVEL}
)

option(BEMAN_{{cookiecutter.__project_ident.upper()}}_USE_MODULES "Provide beman.{{cookiecutter.__project_ident}} as a C++ module" OFF)

if(BEMAN_{{cookiecutter.__project_ident.upper()}}_USE_MODULES)
    set(CMAKE_CXX_SCAN_FOR_MODULES ON)
endif()

configure_file(
    "${PROJECT_SOURCE_DIR}/include/beman/{{cookiecutter.__project_ident}}/config_generated.hpp.in"
    "${PROJECT_BINARY_DIR}/include/beman/{{cookiecutter.__project_ident}}/config_generated.hpp"
    @ONLY
)

# for find of beman_install_library and configure_build_telemetry
include(infra/cmake/beman-install-library.cmake)
include(infra/cmake/BuildTelemetryConfig.cmake)

if(BEMAN_{{cookiecutter.__project_ident.upper()}}_USE_MODULES)
    add_library(beman.{{cookiecutter.__project_ident}} STATIC)
else()
    add_library(beman.{{cookiecutter.__project_ident}} INTERFACE)
endif()
add_library(beman::{{cookiecutter.__project_ident}} ALIAS beman.{{cookiecutter.__project_ident}})

if(BEMAN_{{cookiecutter.__project_ident.upper()}}_USE_MODULES)
    target_sources(
        beman.{{cookiecutter.__project_ident}}
        PUBLIC
            FILE_SET CXX_MODULES
            FILE_SET HEADERS
                BASE_DIRS
                    "${CMAKE_CURRENT_SOURCE_DIR}/include"
                    "${CMAKE_CURRENT_BINARY_DIR}/include"
    )
    set_target_properties(beman.{{cookiecutter.__project_ident}} PROPERTIES CXX_MODULE_STD ON)
    target_compile_features(beman.{{cookiecutter.__project_ident}} PUBLIC cxx_std_23)
else()
    target_sources(
        beman.{{cookiecutter.__project_ident}}
        PUBLIC
            FILE_SET HEADERS
                BASE_DIRS
                    "${CMAKE_CURRENT_SOURCE_DIR}/include"
                    "${CMAKE_CURRENT_BINARY_DIR}/include"
    )
    set_target_properties(
        beman.{{cookiecutter.__project_ident}}
        PROPERTIES VERIFY_INTERFACE_HEADER_SETS ${PROJECT_IS_TOP_LEVEL}
    )
endif()

add_subdirectory(include/beman/{{cookiecutter.__project_ident}})

beman_install_library(beman.{{cookiecutter.__project_ident}} TARGETS beman.{{cookiecutter.__project_ident}})
configure_build_telemetry()

if(BEMAN_{{cookiecutter.__project_ident.upper()}}_BUILD_TESTS)
    enable_testing()
    add_subdirectory(tests/beman/{{cookiecutter.__project_ident}})
endif()

if(BEMAN_{{cookiecutter.__project_ident.upper()}}_BUILD_EXAMPLES)
    add_subdirectory(examples)
endif()
