---
name: paper-reviewer
description: >-
  Review research papers (AI/ML/systems) — extracts key contributions, identifies
  weaknesses, assesses reproducibility, and evaluates production applicability.
  Produces a structured review useful for learning and implementation decisions.
  Trigger on "review this paper", "summarize this research paper", "paper review",
  "what's useful in this paper", "is this paper worth implementing",
  "paper critique", "research paper analysis", "arxiv paper review".
  Exclude: writing papers, literature surveys, citation management, general summarization.
metadata:
  author: ai-engineering-team
  version: "1.0.0"
tags:
  - paper-reviewer
  - research
  - ml-papers
---

# Paper Reviewer

Reviews research papers through the lens of a practitioner — not just "is it good research?" but "should I use this?" Extracts what matters for implementation decisions and flags reproducibility concerns.

## Behavior

### Step 1: Gather Context

Ask for:
1. The paper (URL, PDF, or paste the abstract + key sections)
2. What's their interest — learning, implementing, or evaluating for their use case?
3. Their specific domain (if they want applicability assessment)

Read the paper thoroughly before generating the review.

### Step 2: Structured Analysis

**Core Contribution:**
- What is the ONE thing this paper claims to contribute?
- Is this genuinely novel or incremental?
- What existing method does it improve upon?
- By how much (quantitative improvement)?

**Methodology:**
- Is the approach sound?
- Are there hidden assumptions?
- Does the evaluation setup favor the proposed method?
- Are baselines fair and current?
- Is there ablation study (which component matters)?

**Results:**
- Are results statistically significant?
- Are error bars / confidence intervals reported?
- Do results generalize beyond the specific benchmarks?
- Is there a gap between academic benchmarks and real-world performance?

**Reproducibility:**
- Is code available?
- Are hyperparameters fully specified?
- Is the dataset available?
- Are compute requirements stated?
- Could you reproduce this in a week?

**Production Applicability:**
- Does this solve a real production problem?
- What's the inference cost / latency?
- Does it require special hardware?
- How does it handle edge cases the paper doesn't mention?
- Is the complexity justified for the improvement?

**Limitations (what the paper doesn't say):**
- What failure modes are not discussed?
- What datasets/domains might break this?
- What scale limitations exist?
- What are the computational costs at production scale?

### Step 3: Generate Review

```markdown
# Paper Review: [Title]

## TL;DR (1-2 sentences)
[What this paper does and whether you should care]

## Key Contribution
[The ONE thing this paper adds to the field]

## Summary
[3-5 sentence summary of the approach]

## Strengths
- ...

## Weaknesses
- ...

## Results Assessment
| Benchmark | Improvement | Significant? | Generalizable? |
|-----------|-------------|-------------|----------------|

## Reproducibility: [High | Medium | Low | Cannot Reproduce]
- Code: [Available | Partial | Not Available]
- Data: [Public | Restricted | Not Available]
- Compute: [Reasonable | Significant | Prohibitive]

## Production Applicability: [High | Medium | Low | Research Only]
- Inference cost: ...
- Integration complexity: ...
- Maintenance burden: ...

## Should You Implement This?
[Clear recommendation for the practitioner]
- If YES: key considerations for implementation
- If NO: what to use instead

## Key Takeaways for Practitioners
1. ...
2. ...
3. ...

## Related Work Worth Reading
- ...
```

## Gotchas

- Papers cherry-pick benchmarks — always check if they tested on YOUR domain
- SOTA on academic benchmarks often doesn't translate to production improvement
- "3% improvement" might not justify the 10x complexity increase
- Papers rarely discuss failure modes — always assume there are undisclosed edge cases
- Open-source code != reproducible — many repos are broken or incomplete
- Conference papers are optimized for reviewers, not practitioners — read through the framing
- Preprints (arxiv) haven't been peer-reviewed — higher variance in quality
