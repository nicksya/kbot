# Pre-commit Setup Guide

This repository uses **pre-commit** to manage and run Git hooks in a consistent and reproducible way. Pre-commit helps catch common issues (formatting, linting, configuration errors, etc.) *before* code is committed, improving code quality and reducing CI failures.

---

## What is pre-commit?

**pre-commit** is a framework for managing Git hooks. It allows you to define checks in a single configuration file and ensures they run automatically before each commit.

Key benefits:
- Consistent checks across all developers
- Reproducible hook versions
- Language-agnostic (Python, Go, Node.js, Docker, Bash, etc.)
- Same behavior locally and in CI

---

## Installation

### Option 1: Install using pip (recommended)

```bash
pip install pre-commit
```

### Option 2: Install using pipx

```bash
pipx install pre-commit
```
### Option 3: Install using apt

```bash
apt-get install pre-commit
```

Verify installation:

```bash
pre-commit --version
```

---

## Configuration

Pre-commit is configured using a file named:

```text
.pre-commit-config.yaml
```

This file is **already committed to the repository** and serves as the single source of truth for all configured hooks.

### Example configuration

```yaml
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.5.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-added-large-files
  - repo: https://github.com/gitleaks/gitleaks
    rev: v8.24.2
    hooks:
      - id: gitleaks
```

Each hook repository is pinned to a specific version (`rev`) to ensure reproducible behavior.

---

## Installing Git Hooks

After cloning the repository and installing pre-commit, install the Git hooks:

```bash
pre-commit install
```

This command:
- Installs a lightweight hook into `.git/hooks/pre-commit`
- Uses the **already committed** `.pre-commit-config.yaml`
- Ensures hooks run automatically on `git commit`

This step must be done **once per repository clone**.

---

## Usage

### Automatic execution

Once installed, pre-commit runs automatically on:

```bash
git commit
```

Only **staged files** are checked. If any hook fails, the commit is aborted and errors are displayed.

### Run hooks manually

Run all configured hooks against all files:

```bash
pre-commit run --all-files
```

Run a specific hook:

```bash
pre-commit run <hook-id>
```

---

## Updating Hooks

To update hooks to their latest compatible versions:

```bash
pre-commit autoupdate
```

This updates the `rev` fields in `.pre-commit-config.yaml`.

---

## Troubleshooting

- Ensure `pre-commit install` has been run
- Try cleaning environments if hooks fail unexpectedly:

```bash
pre-commit clean
```

- Re-run hooks manually with verbose output:

```bash
pre-commit run --all-files --verbose
```

---

## Additional Resources

- Official documentation: https://pre-commit.com
- Available hooks: https://pre-commit.com/hooks.html

---



