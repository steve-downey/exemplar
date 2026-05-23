#!/usr/bin/env bash
set -euo pipefail

script_dir=$(realpath "$(dirname "${BASH_SOURCE[0]}")")
repo_root=$(realpath "$script_dir/..")

work_dir=$(mktemp -d)
cleanup() {
    rm -rf "$work_dir"
}
trap cleanup EXIT

echo "Generating standard project in $work_dir..."
uvx --from copier copier copy --vcs-ref HEAD \
    --trust \
    --defaults \
    -d project_name=test_project \
    -d generating_exemplar=false \
    "$repo_root" \
    "$work_dir"

echo "Building standard project..."
cd "$work_dir"
cmake --preset gcc-release -B build
cmake --build build
ctest --test-dir build --output-on-failure
