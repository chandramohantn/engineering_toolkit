---
name: dataset-assessment-expert
description: >-
  Assess dataset suitability for ML/DL/GenAI projects — evaluates sample size adequacy,
  class imbalance severity, label quality, data leakage risks, bias, and overall
  modeling readiness. Produces a scored readiness report with go/no-go recommendation.
  Trigger on "assess this dataset", "is this data enough", "dataset readiness",
  "can I train on this", "data feasibility", "dataset suitability", "enough data",
  "label quality check", "data leakage check".
  Exclude: EDA execution, data cleaning, feature engineering implementation, model training.
compatibility: Requires Python 3.10+, pandas, numpy, scikit-learn
metadata:
  author: ai-engineering-team
  version: "1.0.0"
tags:
  - dataset-assessment-expert
  - ml-readiness
  - data-assessment
---

# Dataset Assessment Expert

Evaluates whether a dataset is suitable for a specific ML task. Runs automated checks (sample size, balance, leakage signals) and applies judgment (label quality, bias, domain fit) to produce a readiness score and go/no-go recommendation.

## Behavior

### Step 1: Gather Context

Ask the user for:
1. Path to the dataset
2. Target column
3. Task type (classification, regression, ranking, generation) — infer if obvious
4. Minimum performance requirement (if known)

### Step 2: Run Assessment Scripts

```bash
python ~/.kiro/skills/dataset-assessment-expert/scripts/assess.py <file_path> --target <col> --task <type> --output assessment.json
```

The script computes:
- Sample size adequacy (vs feature count, class count)
- Class imbalance ratio and severity
- Feature-to-sample ratio
- Target leakage signals (features with >0.95 correlation to target)
- Missing value impact on effective sample size
- Near-duplicate percentage
- Feature stability (first half vs second half KS test)

### Step 3: Agent Reasoning

Using script output, reason about:

**Label Quality:** Are labels likely correct? Check for:
- High inter-class overlap (low separability)
- Suspicious patterns (all same label for a time period)
- Label leakage from feature names

**Bias Assessment:** Check for:
- Demographic underrepresentation
- Temporal bias (data only from one period)
- Selection bias (only successful outcomes)
- Geographic concentration

**Domain Fit:** Is this data appropriate for the stated task?
- Do features plausibly relate to the target?
- Are there obvious missing features?
- Is the problem actually learnable from this data?

**Data Leakage Deep Check:**
- Features derived from the target
- Future information in features
- Train-test contamination risk

### Step 4: Generate Assessment Report

```markdown
# Dataset Assessment Report: [Name]

## Readiness Score: [X/100]

## Verdict: [READY | READY WITH CONDITIONS | NOT READY]

## 1. Sample Size Assessment
- Total samples: X
- Effective samples (after dedup + missing): X
- Feature-to-sample ratio: X
- Adequacy: [Sufficient | Marginal | Insufficient]

## 2. Class Balance
- Imbalance ratio: X
- Severity: [None | Mild | Moderate | Severe | Extreme]
- Recommended strategy: [None needed | Stratified sampling | SMOTE | Class weights | Anomaly framing]

## 3. Label Quality
- Assessment: [High | Acceptable | Questionable | Poor]
- Evidence: ...

## 4. Data Leakage Risk
- Risk level: [None detected | Low | Medium | High]
- Suspect features: ...

## 5. Bias Assessment
- Identified biases: ...
- Impact: ...

## 6. Missing Data Impact
- Effective sample loss: X%
- Critical columns affected: ...

## 7. Recommendations
- Blocking issues: ...
- Before modeling: ...
- During modeling: ...

## 8. Go/No-Go
[Clear recommendation with rationale]
```

## Scoring Rubric

| Dimension | Weight | Score Criteria |
|-----------|--------|---------------|
| Sample size | 20% | 5=abundant, 3=marginal, 1=insufficient |
| Class balance | 15% | 5=balanced, 3=moderate imbalance, 1=extreme |
| Label quality | 20% | 5=verified, 3=assumed OK, 1=known issues |
| Leakage risk | 20% | 5=none detected, 3=minor suspects, 1=confirmed leakage |
| Bias | 15% | 5=representative, 3=some bias, 1=severe bias |
| Completeness | 10% | 5=<5% missing, 3=5-20%, 1=>50% |

**Verdict thresholds:** ≥75 = READY | 50-74 = READY WITH CONDITIONS | <50 = NOT READY

## Gotchas

- A dataset can have 1M rows but still be insufficient if there are 500 classes
- High accuracy on imbalanced data is meaningless — always check per-class performance
- Time-series data needs temporal splits, not random splits — flag this
- "Enough data" depends entirely on the task complexity and model type
- Synthetic/augmented data should be assessed separately from real data
