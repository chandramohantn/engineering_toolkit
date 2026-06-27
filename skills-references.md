# My Skills Reference

A quick-reference guide to available agent skills — what they do and how to invoke them.

---

## agent-design-reviewer

Review whether an AI agent is actually needed and if the design is sound. Checks if a single prompt suffices, if workflow orchestration is needed, if tool usage is justified, and if multi-agent is warranted. Prevents over-engineering with agents.

**Invoke with:** "review my agent design", "do I need an agent", "agent architecture review", "is multi-agent necessary", "agent vs workflow", "should this be agentic"

---

## ai-project-reviewer

Review AI/ML/GenAI project proposals before committing resources. Validates business problem definition, success criteria, feasibility, data availability, and produces a go/no-go recommendation.

**Invoke with:** "review this AI project", "should we do this ML project", "project feasibility", "go no-go decision", "is this project viable"

---

## daily-summary

Summarize everything you did today across Jira, GitLab, and Gerrit. Covers issues created/updated, MRs opened/merged/reviewed, and Gerrit reviews. Useful for standup prep.

**Invoke with:** "what did I do today", "daily summary", "standup notes", "my activity", "summarize my day"

**Requires:** `GITLAB_TOKEN`, `JIRA_ETEAM_TOKEN` env vars, curl, jq, .netrc for Gerrit

---

## dataset-assessment-expert

Assess dataset suitability for ML/DL/GenAI projects. Evaluates sample size adequacy, class imbalance, label quality, data leakage risks, bias, and overall modeling readiness. Produces a scored readiness report.

**Invoke with:** "assess this dataset", "is this data enough", "dataset readiness", "can I train on this", "data feasibility", "enough data"

**Requires:** Python 3.10+, pandas, numpy, scikit-learn

---

## data-quality-auditor

Audit data quality for production datasets and ML pipelines. Checks nulls, duplicates, schema drift, integrity violations, freshness, and consistency. Produces a scored quality report with remediation priorities.

**Invoke with:** "audit data quality", "data quality check", "check for nulls and duplicates", "schema drift", "data integrity", "quality report"

**Requires:** Python 3.10+, pandas, numpy

---

## etl-review-expert

Review ETL/data pipeline designs for production readiness. Checks idempotency, replayability, backfill support, failure handling, monitoring, data contracts, and SLA compliance.

**Invoke with:** "review my ETL", "pipeline review", "data pipeline design review", "is my pipeline production ready", "ETL best practices", "backfill strategy"

---

## gitlab

GitLab workflows for everyday developers — MRs, pipelines, issues, CI/CD components, and API patterns.

**Invoke with:** "create MR", "push MR", "fix MR", "merge MR", "review MR", "check pipeline", "pipeline failed", "create issue", "gitlab api", "glab"

**Requires:** `GITLAB_TOKEN` env var, curl, jq, git

---

## jira

JIRA workflows — create issues, search with JQL, link issues, manage epics, format descriptions, and discover project fields via REST API.

**Invoke with:** "create issue", "create story", "create bug", "create epic", "search jira", "JQL", "link issues", "update issue", "jira comment"

**Requires:** `JIRA_ETEAM_TOKEN` env var, curl, jq

---

## kata-creator

Create structured kata exercises for hackathons, coding dojos, and workshops. Generates progressive hands-on exercises with prerequisites, step-by-step instructions, templates, checkpoints, and stretch goals.

**Invoke with:** "create kata", "write kata", "kata exercises", "hackathon exercises", "coding dojo", "workshop exercises", "training exercises"

---

## learn-by-asking

Answer questions in depth for learning. Explains what, why, when, how with scenarios, Python code examples, and mermaid diagrams. Writes answers to markdown files and suggests follow-up curiosity questions.

**Invoke with:** Start message with `learn:`, or use "explain", "how does", "what is", "why does", "teach me", "deep dive", "walk me through"

---

## optimize-dockerfile

Optimize Docker images for minimal size, enhanced security, and faster builds. Addresses large image size, slow build times, security vulnerabilities, and poor layer caching.

**Invoke with:** "optimize Docker", "reduce image size", "Docker security", "image optimization"

---

## paper-reviewer

Review research papers (AI/ML/systems). Extracts key contributions, identifies weaknesses, assesses reproducibility, and evaluates production applicability. Produces a structured review for learning and implementation decisions.

**Invoke with:** "review this paper", "paper review", "what's useful in this paper", "is this paper worth implementing", "arxiv paper review"

---

## rag-architect

Design RAG system architectures. Recommends chunking strategy, embedding model, retrieval approach, reranking, and evaluation plan based on document types, query patterns, and scale requirements.

**Invoke with:** "design RAG system", "RAG architecture", "chunking strategy", "retrieval design", "vector store selection", "how to build RAG"

---

## system-design-reviewer

Review system designs before implementation. Evaluates scalability, availability, consistency, performance bottlenecks, cost efficiency, and operational complexity. Identifies architectural risks and improvements.

**Invoke with:** "review my system design", "architecture review", "scalability review", "will this scale", "system design feedback", "is this architecture sound"

---

## deep-reading-assistant

Transform articles and blog posts into structured learning experiences. Analyzes prerequisites, teaches unknown concepts, explains section-by-section with analogies and mermaid diagrams, builds engineering intuition, and exports knowledge as markdown artifacts.

**Invoke with:** "read article", "understand article", "deep read", "explain article", "help me read", "break down this article", "teach me this article", "help me learn from this"

**Input:** URL, file path, or pasted article text


