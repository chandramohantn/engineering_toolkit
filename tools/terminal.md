# Terminal Productivity

---

## tmux

### What it does

Terminal multiplexer.

Never lose sessions.

### Essential Commands

Create:

```bash
tmux
```

Detach:

```text
Ctrl+b d
```

List:

```bash
tmux ls
```

Attach:

```bash
tmux attach
```

Split:

```text
Ctrl+b %
Ctrl+b "
```

### Typical Use

Remote servers.

---

## zoxide

### What it does

Smart cd.

Learns frequently visited directories.

### Common Commands

```bash
z project
```

instead of

```bash
cd ~/work/company/project
```

### Typical Use

Daily navigation.

---

## fzf

### What it does

Fuzzy finder.

### Common Commands

Search files:

```bash
fzf
```

Open selected file:

```bash
vim $(fzf)
```

Search command history:

```text
Ctrl+r
```

### Typical Use

File discovery.

---

## bat

### What it does

Better cat.

Syntax highlighting.

### Common Commands

```bash
bat file.py
```

View specific lines:

```bash
bat file.py -r 10:50
```

### Typical Use

Reading code.

---

## eza

### What it does

Modern replacement for ls.

### Common Commands

```bash
eza
```

Long view:

```bash
eza -la
```

Tree:

```bash
eza --tree
```

### Typical Use

Directory inspection.

---

## fd

### What it does

Fast replacement for find.

### Common Commands

Find file:

```bash
fd config
```

Only Python files:

```bash
fd -e py
```

### Typical Use

Large repositories.

---