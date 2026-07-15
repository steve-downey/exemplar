// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
{% set identity = "identity" if cookiecutter._generating_exemplar else "todo" %}

#ifndef BEMAN_{{cookiecutter.__project_ident.upper()}}_{{identity.upper()}}_HPP
#define BEMAN_{{cookiecutter.__project_ident.upper()}}_{{identity.upper()}}_HPP

#include <beman/{{cookiecutter.__project_ident}}/config.hpp>

#if BEMAN_{{cookiecutter.__project_ident.upper()}}_USE_MODULES() && !defined(BEMAN_{{cookiecutter.__project_ident.upper()}}_INCLUDED_FROM_INTERFACE_UNIT)

import beman.{{cookiecutter.__project_ident}};

#else

{% if cookiecutter._generating_exemplar %}
    // C++ Standard Library: std::identity equivalent.
    // See https://eel.is/c++draft/func.identity:
    //
    // 22.10.12 Class identity  [func.identity]
    //
    // struct identity {
    //   template<class T>
    //     constexpr T&& operator()(T&& t) const noexcept;
    //
    //   using is_transparent = unspecified;
    // };
    //
    // template<class T>
    //   constexpr T&& operator()(T&& t) const noexcept;
    //
    // Effects: Equivalent to: return std::forward<T>(t);

    #if !BEMAN_{{cookiecutter.__project_ident.upper()}}_USE_MODULES()
        #include <utility> // std::forward
    #endif

{% endif %}
namespace beman::{{cookiecutter.__project_ident}} {

{% if cookiecutter._generating_exemplar %}
struct __is_transparent; // not defined

// A function object that returns its argument unchanged.
struct identity {
    // Returns `t`.
    template <class T>
    constexpr T&& operator()(T&& t) const noexcept {
        return std::forward<T>(t);
    }

    using is_transparent = __is_transparent;
};

{% else %}
// TODO

{% endif %}
} // namespace beman::{{cookiecutter.__project_ident}}

#endif // BEMAN_{{cookiecutter.__project_ident.upper()}}_USE_MODULES() &&
       // !defined(BEMAN_{{cookiecutter.__project_ident.upper()}}_INCLUDED_FROM_INTERFACE_UNIT)

#endif // BEMAN_{{cookiecutter.__project_ident.upper()}}_{{identity.upper()}}_HPP
