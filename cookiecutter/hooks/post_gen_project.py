#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

import shutil
import subprocess
from pathlib import Path
import os

project_ident = "{{ cookiecutter.__project_ident }}"
generating_exemplar = "{{ cookiecutter._generating_exemplar }}" == "True"

if not generating_exemplar:
    os.rename("include/beman/" + project_ident + "/identity.hpp", "include/beman/" + project_ident + "/todo.hpp")
    os.rename("examples/identity_direct_usage.cpp", "examples/todo.cpp")
    os.remove("examples/identity_as_default_projection.cpp")
    os.rename("tests/beman/" + project_ident + "/identity.test.cpp", "tests/beman/" + project_ident + "/todo.test.cpp")

    # Record the exemplar commit this project was stamped from.
    result = subprocess.run(
        ["git", "ls-remote", "https://github.com/bemanproject/exemplar.git", "HEAD"],
        capture_output=True,
        text=True,
        check=True,
    )
    sha = result.stdout.split()[0]
    Path(".exemplar_version").write_text(sha + "\n")
