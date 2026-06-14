---
name: kata-creator
description: >-
  Create structured kata exercises for hackathons, coding dojos, and workshops.
  Generates progressive hands-on exercises with prerequisites, step-by-step instructions,
  templates, checkpoints, and stretch goals. Supports difficulty calibration for
  mixed-skill audiences and multi-track delivery. Handles full kata design from topic
  definition through audit. Trigger on "create kata", "write kata", "kata exercises",
  "hackathon exercises", "coding dojo", "workshop exercises", "create hands-on",
  "write exercises", "training exercises", "hands-on lab", "tutorial exercises",
  "step-by-step workshop". Exclude: running katas, general documentation,
  presentation slides, course curricula.
compatibility: Requires fs_read, fs_write, execute_bash for creating directory structure and writing files.
metadata:
  author: ai-engineering-team
  version: "2.0.0"
tags:
  - kata-creator
  - training
  - kata
  - hackathon
  - workshop
---

# Kata Creator

Create structured kata exercises for hackathons, coding dojos, and workshops. Produces progressive hands-on exercises calibrated to audience skill level, with support for multi-track delivery when audiences are mixed.

## Workflow

### 1. Interview

Gather requirements before writing anything:

- **Topic** — what are participants learning? (e.g., AI agents, Kubernetes, CI/CD)
- **Audience** — skill level, role, what they already know
- **Duration** — total hands-on time available
- **Tools** — what participants will use (CLI tools, platforms, services)
- **Outcome** — what should participants have built/learned by the end?
- **Format** — solo, paired, group? In-person or remote?
- **Mixed levels?** — is the audience uniform or mixed skill? (determines single-track vs multi-track)

### 2. Calibrate Difficulty

Based on the audience, select the difficulty level. This determines HOW instructions are written, not just WHAT is covered.

| Level | Audience | Instruction Style | Example Action |
|-------|----------|------------------|----------------|
| **Beginner** | First time with this tool/concept | Guided copy-paste. Every command provided. Explain what each step does. | "Run this command: `kubectl get pods`. You should see..." |
| **Intermediate** | Used similar tools, new to this specific one | Provide the goal + hints. Show the pattern, let them adapt. | "Deploy the app using the manifest in `templates/`. Modify the image name to match yours." |
| **Advanced** | Experienced practitioners | State the objective + constraints. Minimal hand-holding. | "Create a multi-stage build that keeps the final image under 100MB. Use `templates/base.Dockerfile` as reference." |

**Mixing within a single kata:** Use the primary level for main instructions, then:
- Add "💡 Hint" callouts for beginners who are struggling
- Add "🚀 Challenge" callouts for advanced participants who finish early

### 3. Map Learning Objectives (Bloom's Taxonomy)

Each kata should target a specific cognitive level. A good kata sequence progresses up this ladder:

| Level | Verb | Kata Purpose | Example |
|-------|------|--------------|---------|
| **Remember** | Identify, List, Name | Recognize the tool/concept exists | "List all running pods" |
| **Understand** | Explain, Describe, Compare | Know what it does and why | "Explain what happened when you ran the command" |
| **Apply** | Use, Execute, Implement | Use it to accomplish a task | "Deploy the provided template" |
| **Analyze** | Compare, Differentiate, Debug | Break down how it works | "Compare output with/without the flag — what changed?" |
| **Evaluate** | Judge, Recommend, Critique | Assess quality or approach | "Which approach is better for production? Why?" |
| **Create** | Design, Build, Compose | Produce something original | "Create your own skill/pipeline/config from scratch" |

**Rule of thumb:** A 3-kata sequence should cover Apply → Analyze → Create. A 5-kata sequence can start at Remember and reach Create.

### 4. Design the Flow

Structure katas as a progressive sequence. Each kata builds on the previous one.

**Proven pattern (install → use → create):**

| Phase | Purpose | Bloom's Level | Example |
|-------|---------|---------------|---------|
| Setup | Get tools and access ready | — | Pre-flight check |
| Install | Get resources in place | Remember / Apply | Install CLI, agents, skills |
| Use | See it work, experience the value | Apply / Analyze | Run tools, compare approaches |
| Create | Build something yourself | Create | Create your own artifact |
| Explore | Apply to own ideas | Evaluate / Create | Free exploration time |

**Key principle:** Deliver value early. Participants should see something working before they need to understand how it works.

### 5. Handle Multi-Track Delivery

When audiences have mixed skill levels, use one of these patterns:

**Pattern A — Shared Start, Branching End:**
```
Kata 0: Preflight (all)
Kata 1: Install (all — same steps)
Kata 2: Basic Use (all — same steps, different stretch goals)
Kata 3a: Guided Create (beginners — copy + modify template)
Kata 3b: Advanced Create (experienced — build from requirements)
```

**Pattern B — Parallel Tracks with Shared Checkpoints:**
```
Track A (Beginner):  01a-guided-install → 02a-follow-along → 03a-modify-template
Track B (Advanced):  01b-quick-setup   → 02b-build-from-scratch → 03b-production-ready
Shared checkpoints: Everyone demos at the same time
```

**Pattern C — Single Track with Depth Layers:**
```
Each kata has:
- Core instructions (everyone completes)
- 🚀 Challenge section (intermediate: modify, optimize)
- 🏆 Expert section (advanced: build from scratch, handle edge cases)
```

**Selection guidance:**
- Audience is mostly uniform → Single track (Section 4 flow)
- Audience has 2 clear groups → Pattern A or B
- Audience has a spectrum → Pattern C (most common for company hackathons)

### 6. Generate Folder Structure

```
<hackathon-name>/
├── README.md                    # Landing page — date, quick start, structure
├── katas/
│   ├── README.md                # Kata index — table, session flow, tips
│   ├── 00-preflight/
│   │   └── README.md            # Prerequisites checklist
│   ├── 01-<first-kata>/
│   │   ├── README.md            # Kata instructions
│   │   └── templates/           # Starter files (optional)
│   ├── 02-<second-kata>/
│   │   ├── README.md
│   │   └── templates/
│   └── 03-<third-kata>/
│       └── README.md
```

For multi-track (Pattern B), add track suffixes:
```
├── katas/
│   ├── 01a-beginner-install/
│   ├── 01b-advanced-setup/
│   ├── 02a-guided-use/
│   ├── 02b-build-own/
```

### 7. Write Each Kata

Follow this template for every kata README:

```markdown
# Kata N — <Title>

**Difficulty:** [Beginner | Intermediate | Advanced]
**Time:** ~X minutes
**Learning Objective:** [Bloom's level] — [specific objective]

## Goal
One sentence — what will you build/learn?

## Concept
2-3 sentences — why this matters, what pattern it teaches.

## Step by Step

### 1. <First step>
Concrete action with copy-paste commands.

### 2. <Second step>
...

💡 **Hint:** [For participants who are stuck — provide the next breadcrumb]

📣 **Checkpoint:** Post [specific output] in the chat — [specific question].

🚀 **Challenge:** [For fast learners — a harder variant of the same task]

## What Just Happened
Table or short explanation of what the steps accomplished.

## Stretch Goals
- Optional extensions for fast learners

## Next
→ [Kata N+1 — <Title>](../0N+1-<name>/README.md)
```

### 8. Write the Preflight (Kata 0) — SEND BEFORE THE SESSION

⚠️ **The preflight is NOT part of the session itself.** It MUST be sent to participants well in advance (ideally 2 weeks, minimum 1 week before). Access requests, token generation, and tool installations can take up to a week to process.

**Creator responsibility:**
- Send the preflight as early as possible after participants are confirmed
- Send a reminder at least 3-4 days before the session
- Make it crystal clear which steps are MANDATORY
- Provide a contact/channel for participants who get stuck

Structure as numbered sections with verification commands:

```markdown
# Preflight — Complete BEFORE the session

⚠️ You MUST complete these steps BEFORE attending. Some access requests
take up to a week to be granted.

**Deadline:** Complete by <date, at least 1 week before session>.
**Stuck?** Ask in <channel/contact>.

### 1. <Tool Name>
\`\`\`bash
<verification command>
\`\`\`
Expected: <what success looks like>. If not: <how to fix>.
```

### 9. Write the Kata Index

The `katas/README.md` needs:
- Prerequisites link to preflight
- Table: kata number, linked title, difficulty, time estimate, learning objective
- Session flow timeline (approximate)
- Track information (if multi-track)
- Resource links
- Tips section

### 10. Add Checkpoints

One lightweight checkpoint per kata, framed as sharing not reporting:

| Kata phase | Checkpoint style |
|------------|-----------------|
| Install | "Post a screenshot of your installed list" |
| Use | "Post the output — is it accurate?" |
| Create | "Share what you built — inspire others!" |
| Analyze | "What surprised you? Post your finding." |

Use 📣 emoji to mark checkpoints visually.

### 11. Audit

After writing all katas, run an audit pass checking:

- [ ] All inter-kata links resolve to existing files
- [ ] Template filenames match what the instructions reference
- [ ] `cp` commands have correct relative paths (or `cd` instructions)
- [ ] Tool/CLI slugs are verified (not hallucinated)
- [ ] Env var names are consistent between preflight and kata instructions
- [ ] Each kata's "Next" link points to the correct following kata
- [ ] Preflight covers all tokens/tools needed by subsequent katas
- [ ] No secrets, tokens, or user-specific paths in templates
- [ ] Difficulty labels are consistent and appropriate for stated audience
- [ ] Learning objectives progress up Bloom's taxonomy across the sequence
- [ ] Multi-track katas (if any) have clear routing instructions

## Design Principles

- **15-25 min per kata** — don't let participants get stuck on the problem itself
- **Copy-paste friendly** — working examples they can modify, not blank-slate puzzles
- **Progressive** — each kata builds on the previous one
- **Immediate feedback** — run it and see results right away
- **Room to explore** — instructions get you started, stretch goals go further
- **Value early** — the "wow moment" should come in kata 1 or 2, not at the end
- **Teach the habit, not just the technique** — the last kata should connect to daily work
- **Templates as fallback** — always have a plan B if the primary path fails
- **Calibrate, don't patronize** — match the instruction depth to the audience level

## Kata Naming

Use numbered prefixes for ordering: `00-preflight`, `01-install`, `02-use`, `03-create`.

Names should be short and descriptive: `01-agenthub-cli`, `02-clean-default-agent`, `03-create-your-own-skill`.

For multi-track: `01a-beginner-setup`, `01b-advanced-setup`.

## Anti-patterns

- ❌ Too many katas — 3-4 is ideal for a 2-hour session, 5+ causes rushing
- ❌ Setup-heavy katas — if kata 1 is all config and no payoff, people disengage
- ❌ Mandatory checkpoints — "raise your hand when done" kills the flow
- ❌ Blank-slate exercises — "now create something" without examples or templates
- ❌ Assuming uniform pace — fast learners need stretch goals, slow learners need hints
- ❌ No fallback for access issues — always prepare to share content via chat/files
- ❌ Preflight on session day — send it days before so blockers have time to resolve
- ❌ One difficulty fits all — a beginner kata bores experts; an expert kata frustrates beginners
- ❌ No learning progression — random collection of tasks instead of building upward
- ❌ Skipping the "why" — participants who understand the concept retain the skill longer

## Gotchas

- CLI tool names change between versions — always verify the exact command slug before writing it into a kata (e.g., `kiro` vs `kiro-cli`, `glab` vs `gitlab`)
- Relative paths in `cp` commands break when participants don't `cd` first — always include a `cd` instruction or use absolute paths from a known root
- Corporate proxies block npm/pip installs — always list proxy configuration in the preflight
- Access tokens expire — if the preflight is sent 2 weeks early, tokens generated then may expire before the session. Note expiry in preflight.
- "It works on my machine" — always test katas on a fresh environment (new terminal, no custom aliases)
- Participants will copy-paste from rendered markdown — ensure code blocks don't have hidden characters or smart quotes
- GitLab/GitHub URLs in katas become broken if repos are moved or access changes — use relative links within the kata repo, not absolute URLs to external repos
- Checkpoint images/screenshots need an upload destination — verify that the chosen chat tool supports image pasting
