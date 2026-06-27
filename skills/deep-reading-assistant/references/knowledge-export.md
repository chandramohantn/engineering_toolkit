# Knowledge Export (Stages 5–6)

## Stage 5 — Knowledge Consolidation

Reinforce the learning by producing structured retention materials.

### Executive Summary

A concise 200-300 word summary covering:
- The problem the article addresses
- The proposed solution or approach
- Key insights and contributions
- Practical implications

### Cheat Sheet

One-page quick reference:

```
## Cheat Sheet: [Article Topic]

### Core Definitions
- **Term**: definition
- **Term**: definition

### Key Concepts
1. ...
2. ...

### Trade-offs
| Choice | Pros | Cons |
|--------|------|------|
| ... | ... | ... |

### Best Practices
- ...
- ...

### When to Use / When to Avoid
- Use when: ...
- Avoid when: ...
```

### Glossary

Alphabetical list of every technical term from the article with a one-sentence explanation. Include terms the user already knew — this serves as a reference, not a teaching tool.

### Interview Questions

Organize by difficulty:

```
## Interview Questions

### Easy (test recall)
1. ...
2. ...

### Intermediate (test understanding)
1. ...
2. ...

### Advanced (test application and judgment)
1. ...
2. ...
```

Include brief model answers for each question.

### Flashcards

Question → Answer pairs for spaced repetition:

```
## Flashcards

**Q**: [Question]
**A**: [Concise answer]

---

**Q**: [Question]
**A**: [Concise answer]
```

Aim for 10-20 flashcards covering the most important concepts.

### Practical Applications

Suggest concrete ways to apply the knowledge:

```
## Practical Applications

### Mini Project
[A small project that exercises the core concept — completable in 1-2 hours]

### Proof of Concept
[A slightly larger exploration — completable in a day]

### Architecture Exercise
[A design problem that uses the article's ideas]

### Coding Challenge
[A specific implementation challenge]
```

Focus on applications relevant to AI/ML, backend systems, agents, and infrastructure.

---

## Stage 6 — Export Learning Artifacts

Generate markdown files in the user's current working directory (or a path they specify).

### Directory Structure

```
[article-slug]/
├── README.md
├── 01_summary.md
├── 02_prerequisites.md
├── 03_guided_notes.md
├── 04_diagrams.md
├── 05_glossary.md
├── 06_cheatsheet.md
├── 07_interview_questions.md
├── 08_flashcards.md
└── 09_practical_projects.md
```

### File Contents

**README.md** — Article metadata, link to source, learning objectives, and a table of contents linking to all other files.

**01_summary.md** — Executive summary and key takeaways from Stage 1.

**02_prerequisites.md** — All prerequisite lessons taught in Stage 2, organized by dependency order.

**03_guided_notes.md** — The section-by-section guided reading from Stage 3, including engineering intuition sections.

**04_diagrams.md** — All mermaid diagrams from Stage 4, each with a title and explanation. This file should render correctly in any markdown viewer that supports mermaid.

**05_glossary.md** — Alphabetical glossary from Stage 5.

**06_cheatsheet.md** — One-page cheat sheet from Stage 5.

**07_interview_questions.md** — All interview questions with model answers from Stage 5.

**08_flashcards.md** — Flashcards in Q/A format from Stage 5.

**09_practical_projects.md** — Project ideas and exercises from Stage 5.

### Naming Convention

The `[article-slug]` should be derived from the article title:
- Lowercase
- Replace spaces with hyphens
- Remove special characters
- Max 50 characters

Example: "Building RAG with Knowledge Graphs" → `building-rag-with-knowledge-graphs/`

### Export Behavior

- Ask the user where to save before writing files
- Default to current working directory if they don't specify
- Show the file structure that will be created before writing
- After writing, confirm what was created and show the path
