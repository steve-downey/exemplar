# Branch Policy: `copier-extended`

## DO NOT REBASE THIS BRANCH

**This branch MUST NOT be rebased onto `main` or any other branch.**

Copier records the commit hash and VCS ref of the template source in every
generated project's `.copier-answers.yml`. If this branch is rebased, those
recorded commit hashes become invalid, breaking `copier update` for every
project that was generated from this template.

## Merge Policy

Changes from `exemplar/main` or `copier` **must be merged** into this branch,
never rebased:

```bash
git checkout copier-extended
git merge copier          # merge upstream copier changes
# resolve conflicts if any
```

## What This Branch Is

`copier-extended` adds developer infrastructure on top of the upstream
`copier` branch:

- **Makefile** -- build workflow driver using `uv run cmake`
- **pyproject.toml** -- Python dev dependencies (cmake, clang-format, gcovr, pre-commit)
- **cmake/** -- local toolchain files for compiler version selection
- **GitHub workflows** -- CodeQL, OSSF Scorecard, Doxygen
- **Git subtree targets** -- `make subtree-pull`, `make subtree-split` for infra management

These additions are purely additive (new files) to minimize merge conflicts
when incorporating upstream changes.

## Updating From Upstream

```bash
# Merge upstream copier branch changes
git checkout copier-extended
git fetch origin
git merge origin/copier

# Or merge main into copier first, then copier into copier-extended
git checkout copier
git merge origin/main
git checkout copier-extended
git merge copier
```
