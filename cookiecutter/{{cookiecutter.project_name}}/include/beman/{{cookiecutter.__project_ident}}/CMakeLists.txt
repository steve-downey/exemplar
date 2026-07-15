# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
{% set identity = "identity" if cookiecutter._generating_exemplar else "todo" %}

if(BEMAN_{{cookiecutter.__project_ident.upper()}}_USE_MODULES)
    target_sources(
        beman.{{cookiecutter.__project_ident}}
        PUBLIC
            FILE_SET CXX_MODULES FILES {{cookiecutter.__project_ident}}.cppm
            FILE_SET HEADERS
                FILES
                    config.hpp
                    {{cookiecutter.__project_ident}}.hpp
                    {{identity}}.hpp
                    "${PROJECT_BINARY_DIR}/include/beman/{{cookiecutter.__project_ident}}/config_generated.hpp"
    )
else()
    target_sources(
        beman.{{cookiecutter.__project_ident}}
        PUBLIC
            FILE_SET HEADERS
                FILES
                    config.hpp
                    {{cookiecutter.__project_ident}}.hpp
                    {{identity}}.hpp
                    "${PROJECT_BINARY_DIR}/include/beman/{{cookiecutter.__project_ident}}/config_generated.hpp"
    )
endif()
