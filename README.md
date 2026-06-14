# Engineering Toolkit

A comprehensive suite of specialized AI skills, optimized development environments, and engineering tools designed to streamline modern software development, AI/ML experimentation, and system architecture.

## 🚀 Overview

The Engineering Toolkit provides a unified framework for developers and researchers to leverage AI assistants across various domains—from project management in Jira and GitLab to deep learning experimentation and system design reviews.

## 📁 Project Structure

```text
.
├── skills/             # Specialized AI skills for various domains
├── workspaces/         # Docker-based AI/ML development environments
├── tools/              # Engineering utility guides and checklists
└── windows_setup/      # Environment setup guides for Windows/macOS
```

## 🧠 Specialized Skills (`skills/`)

The toolkit includes a wide array of specialized skills that can be activated to provide expert guidance and automation:

- **GitLab & Jira:** Unified workflows for merge requests, pipelines, issue management, and worklog tracking.
- **Architecture & Design:** Skills for RAG architecture, system design reviews, and agent design assessment.
- **Data Engineering:** Experts for ETL review, data quality auditing, and tabular data analysis.
- **Reviewers:** Specialized agents for AI project reviews, paper reviews, and Dockerfile optimization.
- **Learning & Creation:** Tools for creating coding katas and learning by asking.

## 🐳 Development Workspaces (`workspaces/`)

Optimized Docker images for various stages of AI and Machine Learning development:

- **base-python-dev:** Lean foundation with `uv`, JupyterLab, and code quality tools.
- **ml-workspace:** Classical ML (Scikit-learn, XGBoost, Polars, DuckDB).
- **dl-workspace-cpu:** Deep Learning for CPU (PyTorch, Transformers).
- **dl-workspace-gpu:** Deep Learning for GPU (NVIDIA CUDA toolkit).
- **llm-workspace:** LLM experimentation (PEFT, TRL, LlamaIndex, LangGraph).

See [workspaces/README.md](workspaces/README.md) for detailed build and run instructions.

## 🛠️ Utility Tools (`tools/`)

Practical guides and checklists for core engineering tasks:

- **API Development:** Best practices and design patterns.
- **Code Quality & Testing:** Frameworks and standards for robust software.
- **Containerization:** Docker and orchestration best practices.
- **System Monitoring & Log Analysis:** Strategies for observability.

## 🏁 Getting Started

### Using Skills
Skills are designed to be used by AI assistants (like Gemini CLI). You can activate a skill by name:
```bash
activate_skill <skill_name>
```

### Building Workspaces
To build the complete AI/ML workspace stack:
```bash
cd workspaces
docker compose build
```

---
*Created by the AI Engineering Team.*
