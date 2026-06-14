---
name: etl-review-expert
description: >-
  Review ETL/data pipeline designs and implementations for production readiness —
  checks idempotency, replayability, backfill support, failure handling, monitoring,
  data contracts, and SLA compliance. Produces a review report with issues and fixes.
  Trigger on "review my ETL", "pipeline review", "data pipeline design review",
  "is my pipeline production ready", "ETL best practices", "backfill strategy",
  "pipeline failure handling", "idempotent pipeline check".
  Exclude: building pipelines, writing ETL code, data quality checks on data content,
  EDA, ML model training.
metadata:
  author: ai-engineering-team
  version: "1.0.0"
tags:
  - etl-review-expert
  - data-engineering
  - pipeline-review
---

# ETL Review Expert

Reviews ETL/data pipeline designs or implementations against production-grade standards. Checks for common failure modes that cause data incidents in production. This is a pure reasoning skill — reads code, configs, or design docs and evaluates against a checklist.

## Behavior

### Step 1: Gather Context

Ask for:
1. Pipeline code/config OR design document to review
2. Pipeline type: batch, streaming, or hybrid
3. Data volume and frequency (daily, hourly, real-time)
4. Current pain points or concerns (if any)

Read the provided files before starting the review.

### Step 2: Evaluate Against Checklist

Review the pipeline against each dimension:

**Idempotency (Critical):**
- Can the pipeline be re-run without creating duplicates?
- Are writes using UPSERT/MERGE or DELETE+INSERT with proper keys?
- Is there a deduplication mechanism?
- Are intermediate states cleaned up on retry?

**Replayability (Critical):**
- Can historical data be re-processed?
- Are source snapshots or event logs retained?
- Is there a mechanism to replay from a specific timestamp/offset?
- Are transformations deterministic (same input → same output)?

**Backfill Support (High):**
- Can the pipeline backfill a date range without affecting current data?
- Is there parameterized date handling (not hardcoded "today")?
- Can backfills run in parallel without conflicts?
- Are backfills bounded (won't accidentally process entire history)?

**Failure Handling (Critical):**
- What happens on source system failure?
- What happens on transformation error (bad record)?
- What happens on sink write failure?
- Is there dead-letter queue / error table for failed records?
- Are partial failures handled (half-written batch)?
- Is there automatic retry with backoff?
- Are failures alertable?

**Data Contracts (High):**
- Is the input schema validated before processing?
- Is the output schema guaranteed to consumers?
- Are breaking changes handled (schema evolution)?
- Are null/empty value contracts defined?

**Monitoring & Observability (High):**
- Are pipeline runs logged (start, end, duration, record counts)?
- Are data quality metrics emitted (nulls, duplicates, freshness)?
- Are there alerts for SLA breaches?
- Can you trace a specific record through the pipeline?
- Is there a dashboard showing pipeline health?

**Performance & Scalability (Medium):**
- Can the pipeline handle 2x/5x/10x current volume?
- Are there bottlenecks (single-threaded steps, full table scans)?
- Is partitioning used for large tables?
- Are incremental loads used where possible (vs full reloads)?

**Testing (Medium):**
- Are there unit tests for transformations?
- Are there integration tests with sample data?
- Is there a staging environment that mirrors production?
- Are edge cases tested (empty data, schema changes, duplicates)?

**Security & Compliance (Medium):**
- Are credentials stored securely (not hardcoded)?
- Is PII handled correctly (masked, encrypted, or excluded)?
- Are access controls appropriate?
- Is there audit logging?

### Step 3: Generate Review Report

```markdown
# ETL Pipeline Review: [Pipeline Name]

## Overall Score: [X/100]
## Verdict: [Production Ready | Needs Work | Not Production Ready]

## Critical Issues
[Issues that will cause data incidents if not fixed]

## High Priority
[Issues that will cause problems under stress or edge cases]

## Improvements
[Nice-to-haves that improve operational excellence]

## Dimension Scores
| Dimension | Score | Key Issue |
|-----------|-------|-----------|
| Idempotency | /10 | |
| Replayability | /10 | |
| Backfill | /10 | |
| Failure Handling | /10 | |
| Data Contracts | /10 | |
| Monitoring | /10 | |
| Performance | /10 | |
| Testing | /10 | |
| Security | /10 | |

## Specific Findings
[Per-finding: what's wrong, why it matters, how to fix it]

## Recommended Architecture Changes
[If fundamental design issues exist]
```

## Gotchas

- "It works in dev" is not production-ready — always ask about failure modes
- Airflow DAGs that use `execution_date` incorrectly are the #1 source of backfill bugs
- "We'll add monitoring later" means it will never be added — flag it now
- Streaming pipelines need DIFFERENT review criteria than batch (exactly-once, watermarks, late data)
- Many "idempotent" pipelines break when schema changes mid-pipeline
- Check for implicit ordering assumptions — distributed systems don't guarantee order
