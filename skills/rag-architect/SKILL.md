---
name: rag-architect
description: >-
  Design RAG (Retrieval-Augmented Generation) system architectures — recommends chunking
  strategy, embedding model, retrieval approach, reranking, and evaluation plan based
  on document types, query patterns, and scale requirements. Produces an architecture
  document with specific technology recommendations.
  Trigger on "design RAG system", "RAG architecture", "chunking strategy", "retrieval design",
  "vector store selection", "RAG evaluation", "embedding strategy", "how to build RAG",
  "RAG for my documents", "retrieval augmented generation design".
  Exclude: prompt engineering for non-RAG systems, fine-tuning, agent design,
  general LLM selection, chatbot UI design.
metadata:
  author: ai-engineering-team
  version: "1.0.0"
tags:
  - rag-architect
  - genai
  - retrieval
---

# RAG Architect

Designs RAG system architectures based on document corpus characteristics, query patterns, and production requirements. Recommends specific technology choices with rationale — not generic advice.

## Behavior

### Step 1: Gather Context

Ask for:
1. **Documents:** What types (PDF, code, web, structured data)? How many? Total size? Update frequency?
2. **Queries:** What will users ask? (factual lookup, synthesis, comparison, multi-step reasoning)
3. **Scale:** Expected QPS? Latency requirement? Number of concurrent users?
4. **Constraints:** Budget, existing infra, cloud/on-prem, data residency?

### Step 2: Design the Architecture

Make decisions in this order (each informs the next):

**1. Document Processing Pipeline:**

| Document Type | Parser | Considerations |
|--------------|--------|---------------|
| PDF (text-heavy) | `pymupdf`, `unstructured` | Table extraction, headers, footers |
| PDF (scanned) | `pdf2image` + OCR | Expensive, error-prone |
| Code | Language-aware splitter | Respect function/class boundaries |
| Web/HTML | `beautifulsoup`, `trafilatura` | Strip navigation, extract main content |
| Structured (CSV, DB) | Text2SQL or row-level embedding | Consider whether retrieval or query is better |
| Mixed | Multi-modal pipeline | Route by content type |

**2. Chunking Strategy:**

| Strategy | When to Use | Typical Size |
|----------|-------------|-------------|
| Fixed-size + overlap | Default for homogeneous docs | 512-1024 tokens, 20% overlap |
| Semantic (sentence boundaries) | When meaning integrity matters | Variable, ~300-800 tokens |
| Document-structure-aware | When docs have clear sections | Section-level chunks |
| Parent-child (hierarchical) | When context is needed around retrieved chunks | Small chunks for retrieval, large for context |
| Agentic/recursive | Complex multi-document queries | Varies |

Decision factors: embedding model max tokens, query complexity, document structure.

**3. Embedding Model:**

| Model | Dimension | When to Use |
|-------|-----------|-------------|
| `text-embedding-3-small` (OpenAI) | 1536 | General purpose, good cost/quality |
| `text-embedding-3-large` (OpenAI) | 3072 | Higher quality, higher cost |
| `bge-large-en-v1.5` | 1024 | Open source, self-hosted |
| `e5-mistral-7b-instruct` | 4096 | Best quality open source, needs GPU |
| Domain-specific fine-tuned | Varies | When generic models underperform |

**4. Vector Store:**

| Store | When to Use |
|-------|-------------|
| `pgvector` | Already using PostgreSQL, <10M vectors |
| `qdrant` | High performance, filtering, self-hosted |
| `pinecone` | Managed, serverless, fast setup |
| `chromadb` | Prototyping, local development |
| `weaviate` | Multi-modal, hybrid search built-in |

**5. Retrieval Strategy:**

| Strategy | When |
|----------|------|
| Dense only (vector similarity) | Default for semantic queries |
| Sparse only (BM25) | Keyword-heavy queries, exact term matching |
| Hybrid (dense + sparse) | Best of both — recommended for production |
| Multi-query (query expansion) | When single query doesn't capture intent |
| HyDE (hypothetical doc) | When queries are very different from documents |

**6. Reranking:**

Always recommend reranking for production. Retrieve 20-50 candidates, rerank to top-5.
- `cross-encoder/ms-marco-MiniLM-L-6-v2` — fast, good baseline
- `cohere.rerank` — API, high quality
- `bge-reranker-v2-m3` — open source, multilingual

**7. Generation:**
- Context window management (stuff vs map-reduce vs refine)
- System prompt with role + constraints
- Citation/source attribution
- Fallback when retrieval returns nothing relevant

### Step 3: Define Evaluation Plan

Every RAG system needs:
- **Retrieval metrics:** Recall@K, MRR, NDCG
- **Generation metrics:** Faithfulness, relevance, coherence
- **End-to-end:** Answer correctness (vs golden dataset)
- **Tools:** `ragas`, `deepeval`, or custom LLM-as-judge

### Step 4: Generate Architecture Document

```markdown
# RAG Architecture: [System Name]

## Overview
[1-paragraph summary of the system]

## Architecture Diagram
[Mermaid diagram or description of the flow]

## Document Processing
- Parser: ...
- Chunking: ... (strategy, size, overlap)
- Metadata: ... (what to extract and store)

## Embedding & Storage
- Embedding model: ... (with rationale)
- Vector store: ... (with rationale)
- Index configuration: ...

## Retrieval
- Strategy: ... (dense/sparse/hybrid)
- Top-K: ...
- Reranking: ...
- Filtering: ... (metadata filters)

## Generation
- LLM: ...
- Context strategy: ...
- System prompt approach: ...
- Citation format: ...

## Evaluation Plan
| Metric | Target | Tool |
|--------|--------|------|
| Retrieval recall@10 | >0.9 | ragas |
| Faithfulness | >0.85 | ragas |
| Answer relevance | >0.8 | deepeval |

## Scaling Considerations
- Current: ...
- Growth plan: ...

## Cost Estimate
| Component | Monthly Cost |
|-----------|-------------|
```

## Gotchas

- Chunking is the #1 lever for RAG quality — most teams under-invest here
- Small chunks improve retrieval precision but lose context — use parent-child to get both
- Embedding models have max token limits — chunks exceeding this are silently truncated
- Hybrid search (dense + sparse) almost always beats dense-only in production
- Without reranking, you're leaving 10-20% quality on the table
- "RAG isn't working" usually means bad chunking or missing metadata filters, not bad LLM
- Evaluation without a golden dataset is vibes-based — insist on ground truth
