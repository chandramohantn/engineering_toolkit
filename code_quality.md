# Code Quality

---

## Ruff

Lint:

```bash
ruff check .
```

Fix:

```bash
ruff check . --fix
```

Format:

```bash
ruff format .
```

---

## mypy

Type checking.

```bash
mypy .
```

Specific file:

```bash
mypy app/main.py
```

---

## Pyright

Faster and stricter type checker.

```bash
pyright
```

Common in VS Code.

---

## Bandit

Security scanner.

```bash
bandit -r .
```

Typical findings:

```text
hardcoded passwords
unsafe subprocess
weak crypto
```

---

## pre-commit

Run checks before commit.

Install hooks:

```bash
pre-commit install
```

Run manually:

```bash
pre-commit run --all-files
```

---