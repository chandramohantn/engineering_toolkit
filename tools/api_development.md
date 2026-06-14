# API Development

---

## curl

### GET

```bash
curl http://localhost:8000/health
```

### POST

```bash
curl \
-X POST \
-H "Content-Type: application/json" \
-d '{"name":"john"}' \
http://localhost:8000/users
```

---

## HTTPie

Human-friendly curl.

### GET

```bash
http localhost:8000/health
```

### POST

```bash
http POST localhost:8000/users name=john
```

### Typical Use

Daily API testing.

---

## Bruno

### What it does

Git-friendly Postman replacement.

### Workflow

```text
Create Collection
Create Request
Commit Collection
Review in Git
```

### Typical Use

Team API testing.

---