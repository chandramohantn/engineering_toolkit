# Testing

---

## pytest

Run tests:

```bash
pytest
```

Specific test:

```bash
pytest tests/test_api.py
```

Verbose:

```bash
pytest -v
```

---

## pytest-cov

Coverage.

```bash
pytest --cov=app
```

HTML report:

```bash
pytest --cov=app --cov-report=html
```

---

## pytest-mock

Provides mocker fixture.

Example:

```python
def test_service(mocker):
    mocker.patch("app.db.get_user")
```

Typical use:

```text
Mock database
Mock API
Mock filesystem
```

---