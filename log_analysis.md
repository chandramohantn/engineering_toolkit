# Log Analysis

---

## jq

### What it does

JSON processor.

Essential for structured logs.

### Common Commands

Pretty print:

```bash
cat logs.json | jq
```

Extract field:

```bash
jq '.message'
```

Filter:

```bash
jq 'select(.level=="ERROR")'
```

### Typical Use

Application logs.

---

## gron

### What it does

Flattens JSON.

Turns:

```json
{
  "user": {
    "name": "john"
  }
}
```

into:

```text
json.user.name="john";
```

### Common Commands

```bash
cat data.json | gron
```

Search:

```bash
gron data.json | rg user
```

### Typical Use

Unknown JSON structures.

---

## lnav

### What it does

Interactive log viewer.

Supports:

* log formats
* filtering
* searching
* SQL queries

### Common Commands

```bash
lnav app.log
```

Multiple logs:

```bash
lnav *.log
```

### Typical Use

Incident investigation.

---

## multitail

### What it does

View multiple logs simultaneously.

### Common Commands

```bash
multitail app.log db.log
```

### Typical Use

Watching microservices.

---

## ripgrep (rg)

### What it does

Extremely fast grep replacement.

### Common Commands

Search:

```bash
rg ERROR
```

Specific file type:

```bash
rg ERROR --type py
```

Case insensitive:

```bash
rg -i timeout
```

### Typical Use

Logs, codebases, configs.

---