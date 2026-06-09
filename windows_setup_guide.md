# Windows Development Setup Guide

This guide provides a detailed, step-by-step roadmap for setting up a fresh Windows machine with a modern, high-performance development environment.

---

## Table of Contents
1. [Core OS Components](#1-core-os-components)
2. [Open Source Container Runtimes (Docker Alternatives)](#2-open-source-container-runtimes-docker-alternatives)
3. [Package Management (Homebrew)](#3-package-management-homebrew)
4. [Modern CLI Utilities](#4-modern-cli-utilities)
5. [Database & API Tools](#5-database--api-tools)
6. [System Monitoring](#6-system-monitoring)
7. [Python Development & Code Quality](#7-python-development--code-quality)

---

## 1. Core OS Components

### Windows Terminal
*   **Description:** A modern host for command-line shells like PowerShell, CMD, and WSL. It supports tabs, panes, and themes.
*   **Installation:** Usually pre-installed on Windows 11. If not, install via the Microsoft Store.
*   **Setup:** Open and press `Ctrl+,` to configure settings, themes, and default profiles.

### WSL2 + Ubuntu
*   **Description:** Windows Subsystem for Linux allows you to run a native Linux kernel on Windows. Ubuntu is the recommended distribution.
*   **Installation:**
    1. Open PowerShell as Administrator.
    2. Run `wsl --install`.
    3. Restart your computer.
    4. Set up your Linux username and password when prompted.

### VS Code
*   **Description:** The industry-standard code editor.
*   **Installation:** Download from [code.visualstudio.com](https://code.visualstudio.com/).
*   **Essential Extensions:**
    *   **WSL:** Allows VS Code to run "inside" your Linux environment for native performance.
    *   **Python:** Microsoft's official Python support.
    *   **Docker:** Managing containers from the sidebar.

### Git
*   **Description:** Version control system.
*   **Installation:**
    *   **Windows:** Download from [git-scm.com](https://git-scm.com/).
    *   **Linux (WSL):** Run `sudo apt install git -y` inside your Ubuntu terminal.

---

## 2. Open Source Container Runtimes (Docker Alternatives)

Since Docker Desktop is not free for professional use in larger organizations, we recommend these open-source alternatives:

### Rancher Desktop (Recommended)
*   **Description:** A 100% open-source (Apache 2.0) replacement for Docker Desktop. It provides a GUI for managing images and containers and includes a built-in Kubernetes cluster (K3s).
*   **Why use it?** It is a "drop-in" replacement that feels almost identical to Docker Desktop.
*   **Installation:** Download the Windows installer from [rancherdesktop.io](https://rancherdesktop.io/).
*   **Setup:** Choose the `dockerd` (moby) runtime during setup for maximum compatibility with existing scripts.

### Podman Desktop
*   **Description:** A security-focused, daemonless container engine.
*   **Why use it?** It's extremely lightweight and offers better security (rootless containers).
*   **Installation:** Download from [podman-desktop.io](https://podman-desktop.io/).
*   **Note:** You may want to alias `docker=podman` in your shell to use your existing muscle memory.

---

## 3. Package Management (Homebrew)

*   **Description:** The same package manager you use on Mac, now available for Linux (WSL).
*   **Installation (Inside WSL):**
    1. `sudo apt install build-essential procps curl file git -y`
    2. `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
    3. Follow the "Next Steps" in the terminal to add Homebrew to your `~/.zshrc`.

---

## 4. Modern CLI Utilities

Install these inside WSL using `brew install <tool>`.

| Tool | Description | Common Command |
| :--- | :--- | :--- |
| **uv** | Extremely fast Python package manager and resolver. | `uv pip install ...` |
| **tmux** | Terminal multiplexer. Keeps sessions alive and allows splitting panes. | `tmux` |
| **ripgrep (rg)** | Faster and smarter `grep`. | `rg "pattern"` |
| **fd** | Fast and user-friendly alternative to `find`. | `fd config` |
| **fzf** | Command-line fuzzy finder. | `fzf` |
| **bat** | A `cat` clone with syntax highlighting and Git integration. | `bat file.py` |
| **jq** | Command-line JSON processor. | `curl ... | jq '.'` |
| **eza** | A modern, feature-rich replacement for `ls`. | `eza -la` |
| **zoxide** | A smarter `cd` command that learns your habits. | `z project` |

---

## 5. Database & API Tools

### DBeaver
*   **Description:** Universal database tool for developers and DBAs. Supports PostgreSQL, MySQL, SQLite, etc.
*   **Installation:** Download the Windows Community Edition from [dbeaver.io](https://dbeaver.io/).

### HTTPie
*   **Description:** A user-friendly command-line HTTP client (alternative to curl).
*   **Installation:** `brew install httpie`.
*   **Usage:** `http GET localhost:8000/health`.

### Bruno
*   **Description:** A fast, open-source, Git-friendly API client (alternative to Postman).
*   **Installation:** Download the Windows installer from [usebruno.com](https://www.usebruno.com/).

---

## 6. System Monitoring

Install these inside WSL using `brew install <tool>`.

| Tool | Description | Purpose |
| :--- | :--- | :--- |
| **btop** | Modern interactive system monitor (CPU/Mem/Disk/Network). | Replacing Task Manager. |
| **duf** | Disk Usage/Free Utility. A better `df`. | Quick disk checks. |
| **ncdu** | NCurses Disk Usage. Interactive disk explorer. | Finding what's filling the disk. |
| **glances** | Cross-platform system monitoring tool. | Dashboard overview. |

---

## 7. Python Development & Code Quality

Install these inside WSL using `brew install <tool>` or `uv pip install --system <tool>`.

### Ruff
*   **Description:** An extremely fast Python linter and code formatter.
*   **Usage:** `ruff check .`

### MyPy
*   **Description:** Optional static typing for Python.
*   **Usage:** `mypy .`

### Pre-Commit
*   **Description:** A framework for managing and maintaining multi-language pre-commit hooks.
*   **Usage:** `pre-commit install` (run this inside your git repo).

---

## ⚠️ Performance Tip: The Filesystem Boundary
To ensure the best performance (identical to your Mac):
1. **NEVER** store your code on the Windows side (`/mnt/c/...`).
2. **ALWAYS** store your code in the Linux home directory (`~/projects/`).
3. Running `npm install` or `git status` across the filesystem boundary (Windows files accessed from Linux) is roughly **20x slower**.
