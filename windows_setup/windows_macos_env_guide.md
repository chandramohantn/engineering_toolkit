# Guide: Replicating a macOS Development Environment on Windows

This guide provides a comprehensive, step-by-step walkthrough for setting up a high-performance, Unix-like development environment on Windows that mirrors the macOS experience (iTerm2, Homebrew, Oh My Zsh, tmux).

---

## Table of Contents
1. [Core Concepts & Performance Principles](#1-core-concepts--performance-principles)
2. [Step 1: The Engine (WSL2 Installation)](#step-1-the-engine-wsl2-installation)
3. [Step 2: The Interface (Windows Terminal)](#step-2-the-interface-windows-terminal)
4. [Step 3: The Shell (Zsh & Oh My Zsh)](#step-3-the-shell-zsh--oh-my-zsh)
5. [Step 4: Package Management (Homebrew)](#step-4-package-management-homebrew)
6. [Step 5: Productivity Tools (tmux & Plugins)](#step-5-productivity-tools-tmux--plugins)
7. [Summary & Maintenance](#summary--maintenance)

---

## 1. Core Concepts & Performance Principles

### The "Linux on Windows" Strategy
Instead of trying to make Windows commands work like Mac commands, we use **WSL2 (Windows Subsystem for Linux)**. This runs a real Linux kernel alongside Windows. It allows you to use `bash`, `zsh`, `grep`, `sed`, and `brew` natively.

### ⚠️ CRITICAL PERFORMANCE RULE: The Filesystem Boundary
Windows and Linux have different ways of handling files. 
*   **DO:** Store all your code, git repos, and project files in the Linux home directory (e.g., `~/projects`).
*   **DON'T:** Work on files located in the Windows side (e.g., `/mnt/c/Users/...`).
*   **WHY?** Accessing Windows files from Linux is roughly **10x to 20x slower**. If your `git status` or `npm install` feels slow, it's almost certainly because you are crossing this boundary.

---

## Step 1: The Engine (WSL2 Installation)

We need to install the Linux subsystem.

1.  Open **PowerShell** as **Administrator**.
2.  Run the following command:
    ```powershell
    wsl --install
    ```
    *   **What this does:** This command enables the necessary Windows features (Virtual Machine Platform and WSL), downloads the latest Linux kernel, and installs **Ubuntu** as the default distribution.
3.  **Restart your computer.** This is required to finalize the virtualization settings.
4.  After restarting, a terminal will open. Follow the prompts to create a **Username** and **Password**. 
    *   *Note: This password is for Linux (sudo) and doesn't have to match your Windows password.*

---

## Step 2: The Interface (Windows Terminal)

On Mac, you likely used iTerm2. On Windows, the best alternative is **Windows Terminal**.

1.  Download **Windows Terminal** from the Microsoft Store (it's usually pre-installed on Windows 11).
2.  **Install a Nerd Font:** To see icons in your terminal (like the git branch icon), you need a patched font.
    *   Download [MesloLGS NF](https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf).
    *   Install it on Windows.
3.  **Configure Settings:** Press `Ctrl + ,` in Windows Terminal to open Settings.
    *   **Default Profile:** Set this to **Ubuntu**.
    *   **Starting Directory:** Set this to `\\wsl$\Ubuntu\home\<your-username>` so it opens in Linux, not Windows.
    *   **Font:** Under Profiles > Ubuntu > Appearance, set the font to **MesloLGS NF**.
4.  **iTerm2 Keybindings:** Add these to your `settings.json` (Actions section) to match iTerm2 shortcuts:
    ```json
    { "command": { "action": "splitPane", "split": "auto" }, "keys": "alt+d" },
    { "command": "closePane", "keys": "alt+w" }
    ```

---

## Step 3: The Shell (Zsh & Oh My Zsh)

Now we move *inside* the Linux terminal.

1.  **Update Linux Packages:**
    ```bash
    sudo apt update && sudo apt upgrade -y
    ```
2.  **Install Zsh:**
    ```bash
    sudo apt install zsh -y
    ```
3.  **Set Zsh as Default:**
    ```bash
    chsh -s $(which zsh)
    ```
    *   **Why?** This tells Linux that whenever you open a terminal, you want Zsh instead of the default Bash.
4.  **Install Oh My Zsh:**
    ```bash
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    ```
    *   **What this does:** It installs the framework that manages your plugins and themes.

---

## Step 4: Package Management (Homebrew)

Homebrew works on Linux exactly like it does on Mac.

1.  **Install Dependencies:**
    ```bash
    sudo apt install build-essential procps curl file git -y
    ```
2.  **Run the Brew Script:**
    ```bash
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    ```
3.  **ADD BREW TO YOUR PATH (Important):** The installer will show 3 commands at the end. They look like this (copy-paste from your terminal output):
    ```bash
    (echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> ~/.zshrc
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    ```
    *   **Why?** Without this, the `brew` command won't be recognized when you open a new terminal.

---

## Step 5: Productivity Tools (tmux & Plugins)

1.  **Install tmux:**
    ```bash
    brew install tmux
    ```
2.  **Install Productivity Plugins:**
    *   **Syntax Highlighting:** Colors your commands (green for valid, red for invalid).
        ```bash
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
        ```
    *   **Auto-suggestions:** Predicts your commands based on history.
        ```bash
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
        ```
3.  **Enable Plugins in `.zshrc`:**
    Open the file: `nano ~/.zshrc`
    Find the line `plugins=(git)` and change it to:
    ```bash
    plugins=(git zsh-syntax-highlighting zsh-autosuggestions)
    ```
    Save and exit (`Ctrl+O`, `Enter`, `Ctrl+X`), then run `source ~/.zshrc`.

---

## Summary & Maintenance

### Daily Usage Tips
*   **VS Code:** Install the **"WSL" extension**. From your terminal, type `code .` and VS Code will open on Windows but run the code *inside* Linux.
*   **Browser Access:** If you run a web server (like React or FastAPI) inside WSL on port 8000, you can just go to `localhost:8000` in your Windows browser. WSL handles the networking automatically.

### File Access
To see your Linux files in Windows Explorer, type this in the Windows address bar:
`\\wsl$\Ubuntu\home\<username>`

### Updating
To keep everything fresh, run this periodically:
```bash
brew update && brew upgrade && sudo apt update && sudo apt upgrade -y
```
