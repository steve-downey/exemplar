export module beman.{{cookiecutter.__project_ident}};

import std;

#define BEMAN_{{cookiecutter.__project_ident.upper()}}_INCLUDED_FROM_INTERFACE_UNIT
export {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Winclude-angled-in-module-purview"
#include <beman/{{cookiecutter.__project_ident}}/{{cookiecutter.__project_ident}}.hpp>
#pragma clang diagnostic pop
}
