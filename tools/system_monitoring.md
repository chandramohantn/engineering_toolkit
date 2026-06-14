# CPU / Memory / Process Monitoring

---

## btop

### What it does

Modern interactive system monitor.

Shows:

* CPU utilization
* Memory usage
* Disk usage
* Network throughput
* Running processes

Think:

```text
Task Manager + top + graphs
```

### When to use

First tool to open when a machine feels slow.

### Common Commands

Launch:

```bash
btop
```

Useful keys:

```text
P -> sort by CPU
M -> sort by memory
F -> filter processes
ESC -> menu
```

### Typical Workflow

```bash
btop
```

Notice:

```text
python process consuming 700% CPU
```

Investigate PID further.

---

## htop

### What it does

Interactive process viewer.

More lightweight than btop.

### Common Commands

```bash
htop
```

Useful keys:

```text
F3 Search
F4 Filter
F5 Tree view
F6 Sort
F9 Kill process
```

### Typical Workflow

```bash
htop
```

Sort by CPU.

Find:

```text
gunicorn
worker
postgres
python
```

---

## atop

### What it does

Historical system monitoring.

Unlike htop/btop, it records data.

Can answer:

```text
What happened 2 hours ago?
```

### Common Commands

Live view:

```bash
atop
```

Read historical logs:

```bash
atop -r /var/log/atop/atop_20260608
```

### Typical Use

Production incident investigation.

---

## glances

### What it does

System dashboard.

Combines:

* CPU
* Memory
* Disk
* Processes
* Network
* Docker

into one screen.

### Common Commands

```bash
glances
```

Web UI:

```bash
glances -w
```

Visit:

```text
http://localhost:61208
```

### Typical Use

Quick health overview.

---

## psutil

### What it does

Python library for system monitoring.

Useful when writing:

* health checks
* monitoring agents
* diagnostics scripts

### Common Usage

```python
import psutil

psutil.cpu_percent()
psutil.virtual_memory()
psutil.disk_usage("/")
```

Find process:

```python
for p in psutil.process_iter():
    print(p.pid, p.name())
```

### Typical Use

Application diagnostics.

---

## pidstat

### What it does

Per-process performance monitoring.

Answers:

```text
Which process is consuming CPU?
Which process is causing IO?
```

### Common Commands

CPU:

```bash
pidstat 1
```

Memory:

```bash
pidstat -r 1
```

Disk IO:

```bash
pidstat -d 1
```

Threads:

```bash
pidstat -t 1
```

### Typical Use

Performance bottleneck analysis.

---

## dstat

### What it does

Combines:

```text
vmstat
iostat
netstat
```

into one tool.

### Common Commands

```bash
dstat
```

Detailed:

```bash
dstat -cdnm
```

Meaning:

```text
c CPU
d Disk
n Network
m Memory
```

### Typical Use

System bottleneck investigation.

---

# Disk Monitoring

---

## duf

### What it does

Beautiful replacement for df.

### Common Commands

```bash
duf
```

Specific filesystem:

```bash
duf /
```

### Typical Use

Quick disk-space checks.

---

## ncdu

### What it does

Interactive disk usage explorer.

Answers:

```text
What is filling my disk?
```

### Common Commands

Scan current directory:

```bash
ncdu .
```

Scan root:

```bash
sudo ncdu /
```

Delete files directly:

```text
d
```

### Typical Use

Disk full incidents.

---

## dust

### What it does

Fast disk analyzer.

Like:

```text
du
```

but human friendly.

### Common Commands

```bash
dust
```

Specific path:

```bash
dust /var
```

### Typical Use

Finding large directories quickly.

---

# Network Monitoring

---

## nethogs

### What it does

Shows bandwidth usage per process.

Answers:

```text
Who is consuming network?
```

### Common Commands

```bash
sudo nethogs
```

Specific interface:

```bash
sudo nethogs eth0
```

### Typical Use

Investigating unexpected traffic.

---

## mtr

### What it does

Combines:

```text
ping
+
traceroute
```

### Common Commands

```bash
mtr google.com
```

Report mode:

```bash
mtr --report google.com
```

### Typical Use

Network latency troubleshooting.

---