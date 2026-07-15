// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
{% set identity = "identity" if cookiecutter._generating_exemplar else "todo" %}

#ifndef BEMAN_{{cookiecutter.__project_ident.upper()}}_{{cookiecutter.__project_ident.upper()}}_HPP
#define BEMAN_{{cookiecutter.__project_ident.upper()}}_{{cookiecutter.__project_ident.upper()}}_HPP

#include <beman/{{cookiecutter.__project_ident}}/config.hpp>

#if BEMAN_{{cookiecutter.__project_ident.upper()}}_USE_MODULES() && !defined(BEMAN_{{cookiecutter.__project_ident.upper()}}_INCLUDED_FROM_INTERFACE_UNIT)

import beman.{{cookiecutter.__project_ident}};

#else

    #include <beman/{{cookiecutter.__project_ident}}/{{identity}}.hpp>

#endif // BEMAN_{{cookiecutter.__project_ident.upper()}}_USE_MODULES() &&
       // !defined(BEMAN_{{cookiecutter.__project_ident.upper()}}_INCLUDED_FROM_INTERFACE_UNIT)

#endif // BEMAN_{{cookiecutter.__project_ident.upper()}}_{{cookiecutter.__project_ident.upper()}}_HPP
