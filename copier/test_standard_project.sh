#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
set -euo pipefail

script_dir=$(realpath "$(dirname "${BASH_SOURCE[0]}")")
repo_root=$(realpath "$script_dir/..")

PRESET=${1:-gcc-release}

test_project_variant() {
    local variant_name="$1"
    local unit_test_library="$2"
    local use_modules="$3"
    local cmakelists_args=""

    if [[ "$use_modules" == "true" ]]; then
        cmakelists_args="-DBEMAN_TEST_PROJECT_USE_MODULES=ON"
    fi

    echo "=========================================================="
    echo "Testing variant: $variant_name"
    echo "Unit test: $unit_test_library, Modules: $use_modules, Preset: $PRESET"
    echo "=========================================================="

    local work_dir
    work_dir=$(mktemp -d)
    echo "Generating standard project in $work_dir..."

    # Use `--vcs-ref HEAD` in CI environment so we test the most recent commit
    # but use local tree if uncommitted for fast iteration locally. Use dirty copier behavior locally.
    uvx --from copier copier copy \
        --trust \
        --defaults \
        -d project_name=test_project \
        -d generating_exemplar=false \
        -d unit_test_library="$unit_test_library" \
        "$repo_root" \
        "$work_dir"

    echo "Building standard project variant $variant_name..."
    pushd "$work_dir" > /dev/null 
    cmake --preset "$PRESET" -B build $cmakelists_args || { 
        echo -e "\n\n*** configure failed: $variant_name ***"
        echo "*** Sometimes local CMake modules require a newer compiler than the host default."
        # If failure is just a module C++ scan lack of support, we could suppress, but let's hard fail.
        popd > /dev/null && rm -rf "$work_dir"
        exit 1
    }
    cmake --build build
    ctest --test-dir build --output-on-failure

    # Cleanup this variant's dir
    popd > /dev/null && rm -rf "$work_dir"
    echo "✔ Success for variant: $variant_name"
}

# 1. GTest + No Modules
test_project_variant "gtest-no-modules" "gtest" "false"

# 2. Catch2 + No Modules
test_project_variant "catch2-no-modules" "catch2" "false"

# Do not run modules locally if we cannot guarantee modern tooling, but CI will use clang/gcc containers
# We check if we are in github actions to enforce building modules, as locally it may fail CMake module requirements.
if [[ "${GITHUB_ACTIONS:-}" == "true" ]]; then
    # 3. GTest + Modules
    test_project_variant "gtest-modules" "gtest" "true"

    # 4. Catch2 + Modules
    test_project_variant "catch2-modules" "catch2" "true"
else
    echo "Skipping Modules test variants locally to avoid experimental CMake/C++ module failures on older host toolchains."
    echo "Pass GITHUB_ACTIONS=true to force."
fi

echo "=========================================================="
echo "✔ All variants successfully generated, built, and tested! "
echo "=========================================================="
