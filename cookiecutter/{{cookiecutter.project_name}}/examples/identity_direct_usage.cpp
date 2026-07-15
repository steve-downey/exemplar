// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
{% set identity = "identity" if cookiecutter._generating_exemplar else "todo" %}

#include <beman/{{cookiecutter.__project_ident}}/config.hpp>
#include <beman/{{cookiecutter.__project_ident}}/{{identity}}.hpp>

{% if cookiecutter._generating_exemplar %}
#if BEMAN_{{cookiecutter.__project_ident.upper()}}_USE_MODULES()
import std;
#else
    #include <iostream>
#endif

namespace exe = beman::{{cookiecutter.__project_ident}};

int main() {
    std::cout << exe::identity()(2024) << '\n';
    return 0;
}
{% else %}
int main() {
    // TODO
}
{% endif %}
