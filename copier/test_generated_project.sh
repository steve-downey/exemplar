#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

# Generate a project from the copier template under a name other than
# "exemplar", then build, test, and install it, and run its own pre-commit
# hooks. check_copier.sh only proves that the template reproduces exemplar;
# this proves that a project somebody else would generate works out of the
# box.
#
# Usage: copier/test_generated_project.sh <gtest|catch2> [work-dir]
#
# The project is generated into <work-dir>/generated_project, and built and
# installed into <work-dir>/build and <work-dir>/dist, outside the source tree:
# beman-tidy takes the project name from the directory name, and checks every
# file under it, tracked or not.
#
# Can also be sourced, and generate / build / lint called one at a time, which
# is how the CI workflow reports each phase as its own step.

set -euo pipefail

declare script_dir
script_dir=$(realpath "$(dirname "${BASH_SOURCE[0]}")")

# Chosen to differ from "exemplar" in length, so that line wrapping in the
# generated CMake and C++ is not the same as exemplar's.
declare generated_project_name="generated_project"

function setup_generated_venv() {
    local venv_path="$1" ; shift
    python3 -m venv "$venv_path"
    source "$venv_path/bin/activate"
    python3 -m pip install --quiet copier pre-commit
}

function generate() {
    local unit_test_library="$1" ; shift
    local work_dir="$1" ; shift
    local output_dir="$work_dir/$generated_project_name"
    python3 -m copier copy \
            --vcs-ref=HEAD \
            --defaults \
            "$script_dir/.." \
            "$output_dir" \
            -d project_name="$generated_project_name" \
            -d maintainer="test_maintainer" \
            -d minimum_cpp_build_version="20" \
            -d paper="PnnnnRr" \
            -d description="A generated project, to check that the template works under a name other than its own" \
            -d unit_test_library="$unit_test_library"
    # pre-commit only looks at tracked files, so the output has to be a
    # repository with everything added, as it would be after a first commit.
    git -C "$output_dir" init --quiet
    git -C "$output_dir" add --all
    git -C "$output_dir" \
        -c user.name="test_maintainer" -c user.email="test_maintainer@example.com" \
        commit --quiet --message="Initial commit from copier template"
}

function build() {
    local work_dir="$1" ; shift
    local output_dir="$work_dir/$generated_project_name"
    cmake -S "$output_dir" -B "$work_dir/build" \
          -DCMAKE_PROJECT_TOP_LEVEL_INCLUDES="$output_dir/infra/cmake/use-fetch-content.cmake" \
          -DCMAKE_CXX_STANDARD=20 \
          -DCMAKE_INSTALL_PREFIX="$work_dir/dist"
    cmake --build "$work_dir/build"
    ctest --test-dir "$work_dir/build" --output-on-failure
    cmake --install "$work_dir/build"
}

function lint() {
    local work_dir="$1" ; shift
    (cd "$work_dir/$generated_project_name" \
         && pre-commit run --all-files --show-diff-on-failure)
}

function main() {
    local unit_test_library="${1:?usage: $0 <gtest|catch2> [work-dir]}"
    local work_dir="${2:-$(mktemp --directory --dry-run)}"
    work_dir=$(realpath --canonicalize-missing "$work_dir")
    local venv_path
    venv_path=$(mktemp --directory --dry-run)
    setup_generated_venv "$venv_path"
    generate "$unit_test_library" "$work_dir"
    build "$work_dir"
    lint "$work_dir"
    rm -rf "$venv_path"
}

[[ "${BASH_SOURCE[0]}" != "${0}" ]] || main "$@"
