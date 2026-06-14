---
name: data-quality-auditor
description: >-
  Audit data quality for production datasets and ML pipelines — checks nulls, duplicates,
  schema drift, integrity violations, freshness, and consistency. Produces a scored
  quality report with severity classification and remediation priorities.
  Trigger on "audit data quality", "data quality check", "check for nulls and duplicates",
  "schema drift", "data integrity", "quality report", "data health check",
  "validate this data", "production data quality".
  Exclude: EDA, feature engineering, model training, data cleaning implementation.
compatibility: Requires Python 3.10+, pandas, numpy
metadata:
  author: ai-engineering-team
  version: "1.0.0"
tags:
  - data-quality-auditor
  - data-quality
  - production-data
---

# Data Quality Auditor

Audits a dataset against production-quality standards. Runs automated checks (nulls, duplicates, schema, ranges, freshness) and scores quality across 6 dimensions. Designed for recurring use on production data pipelines — not just one-time EDA.

## Behavior

### Step 1: Gather Context

Ask for:
1. Path to the dataset (or table/query)
2. Expected schema (optional — if provided, enables drift detection)
3. Previous audit results (optional — enables trend comparison)
4. SLA/quality thresholds (optional — defaults provided)

### Step 2: Run Audit Script

```bash
python ~/.kiro/skills/data-quality-auditor/scripts/audit.py <file_path> [--schema expected_schema.json] [--output report.json]
```

The script checks:
- **Completeness:** Null counts, null patterns, column-level and row-level completeness
- **Uniqueness:** Exact duplicates, key-column duplicates, near-duplicates
- **Validity:** Type violations, range violations, format violations (emails, dates, IDs)
- **Consistency:** Cross-column contradictions, referential integrity
- **Freshness:** Most recent timestamp, data age, gaps in time series
- **Schema:** Column presence, type changes, new/dropped columns vs expected

### Step 3: Agent Reasoning

Interpret the audit results:

**Severity Classification:** For each violation, classify as:
- CRITICAL: Breaks downstream systems or models (nulls in required fields, schema changes)
- HIGH: Significantly impacts quality (>10% missing in key columns, duplicates)
- MEDIUM: Noticeable but manageable (format inconsistencies, minor drift)
- LOW: Cosmetic or negligible impact

**Root Cause Hypothesis:** For each issue, suggest likely causes:
- Upstream pipeline failure
- Schema migration without backfill
- Data source change
- ETL bug
- Legitimate business change

**Trend Analysis:** If previous audit exists, compare and flag:
- Degrading quality (getting worse over time)
- New issues (didn't exist before)
- Resolved issues (fixed since last audit)

### Step 4: Generate Audit Report

```markdown
# Data Quality Audit Report

## Quality Score: [X/100]

## Summary
| Dimension | Score | Issues | Severity |
|-----------|-------|--------|----------|
| Completeness | X/100 | N | ... |
| Uniqueness | X/100 | N | ... |
| Validity | X/100 | N | ... |
| Consistency | X/100 | N | ... |
| Freshness | X/100 | N | ... |
| Schema | X/100 | N | ... |

## Critical Issues (fix immediately)
...

## High Issues (fix before next model training)
...

## Medium/Low Issues (track and improve)
...

## Remediation Plan
| Priority | Issue | Action | Owner | Effort |
|----------|-------|--------|-------|--------|

## Trend (if previous audit available)
...
```

## Scoring

| Dimension | Weight | 100 (Perfect) | 70 (Acceptable) | 40 (Poor) |
|-----------|--------|---------------|-----------------|-----------|
| Completeness | 25% | <1% missing | <5% missing | >20% missing |
| Uniqueness | 20% | 0 duplicates | <1% dupes | >5% dupes |
| Validity | 20% | All valid | <2% invalid | >10% invalid |
| Consistency | 15% | No contradictions | Minor inconsistencies | Systemic issues |
| Freshness | 10% | Within SLA | <2x SLA | >5x SLA |
| Schema | 10% | Matches exactly | Minor additions | Breaking changes |

## Gotchas

- "No nulls" doesn't mean "no missing" — check for empty strings, "N/A", "null", -999 sentinels
- Freshness check needs timezone awareness — a dataset that looks stale may just be UTC vs local
- Schema drift can be intentional (new feature added) — don't auto-flag as critical without context
- Duplicate detection on large datasets should use key columns, not all columns
- For streaming data, check both batch completeness AND record-level quality
