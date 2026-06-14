---
name: optimize-dockerfile
description: >-
  Analyze and optimize Dockerfiles for size, security, and build performance.
  Reads the user's Dockerfile, scores it across dimensions, and produces an
  optimized version with explanation. Covers multi-stage builds, layer optimization,
  base image selection (alpine, distroless, scratch), HEALTHCHECK, BuildKit,
  and CI caching. Trigger on "optimize Dockerfile", "reduce image size",
  "Docker image too big", "docker build slow", "container security",
  "Dockerfile review", "image optimization", "make my Docker image smaller",
  "review my Dockerfile". Exclude: creating new Dockerfiles from scratch,
  Docker Compose authoring, Kubernetes manifests.
compatibility: Requires docker (for validation commands). Optional dive, trivy for analysis.
metadata:
  author: ai-engineering-team
  version: "2.0.0"
tags:
  - optimize-dockerfile
  - docker
  - containers
  - security
---

# Optimize Dockerfile

Analyze a Dockerfile, score it, and produce an optimized version. This is an analysis workflow, not a reference document — read first, then recommend.

## Behavior

### Step 1: Read the Dockerfile

Read the user's Dockerfile (and .dockerignore if it exists). Understand:
- Base image(s) used
- Language/framework (Go, Python, Java, Node.js, etc.)
- Build steps
- Runtime requirements
- Current layer count

### Step 2: Analyze Against Checklist

Score each dimension (0-10):

| Dimension | Checks |
|-----------|--------|
| **Size** | Multi-stage? Minimal base? .dockerignore? Build deps removed? Unnecessary files? |
| **Security** | Non-root user? No secrets? Pinned versions? Minimal attack surface? HEALTHCHECK? |
| **Build Performance** | Layer ordering? Cache-friendly COPY? BuildKit features? Dependency caching? |
| **Production Readiness** | HEALTHCHECK? Signal handling? Graceful shutdown? Labels? |

### Step 3: Generate Report + Optimized Dockerfile

```markdown
# Dockerfile Optimization Report

## Score: [X/40] → [Y/40] (after optimization)

| Dimension | Before | After | Key Change |
|-----------|--------|-------|-----------|
| Size | /10 | /10 | |
| Security | /10 | /10 | |
| Build Performance | /10 | /10 | |
| Production Readiness | /10 | /10 | |

## Issues Found (priority order)
1. [Critical] ...
2. [High] ...
3. [Medium] ...

## Optimized Dockerfile
\`\`\`dockerfile
# Full optimized Dockerfile here
\`\`\`

## Changes Explained
- Change 1: why and impact
- Change 2: why and impact

## Estimated Size Reduction
- Before: ~XXX MB (estimated)
- After: ~XXX MB (estimated)

## Validation
\`\`\`bash
docker build -t myapp:optimized .
docker images myapp:optimized
\`\`\`
```

## Optimization Techniques

### Base Image Selection

| Option | Size | Use When | Tradeoffs |
|--------|------|----------|-----------|
| `scratch` | 0 MB | Go, Rust (static binaries) | No shell, no debugging, no certs |
| `distroless` | ~20 MB | Java, Python, Node (need runtime, not shell) | No package manager, limited debugging |
| `alpine` | ~5 MB | Need a shell/package manager | musl libc — some packages break (numpy, grpc) |
| `*-slim` | ~80 MB | Need glibc + basic tools | Larger but compatible |
| Full image | 200+ MB | Only during build stages | Never for runtime |

### Multi-Stage Pattern (by language)

**Python:**
```dockerfile
FROM python:3.11-slim AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

FROM python:3.11-slim
WORKDIR /app
COPY --from=builder /install /usr/local
COPY . .
USER 1000
HEALTHCHECK --interval=30s --timeout=3s CMD curl -f http://localhost:8000/health || exit 1
CMD ["python", "app.py"]
```

**Go:**
```dockerfile
FROM golang:1.21 AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 go build -ldflags="-w -s" -o app

FROM scratch
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /app/app /app
USER 1000
ENTRYPOINT ["/app"]
```

**Node.js:**
```dockerfile
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

FROM node:20-alpine
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY . .
USER 1000
HEALTHCHECK --interval=30s --timeout=3s CMD wget -q --spider http://localhost:3000/health || exit 1
CMD ["node", "server.js"]
```

**Java:**
```dockerfile
FROM eclipse-temurin:17-jdk AS builder
WORKDIR /app
COPY . .
RUN ./gradlew bootJar --no-daemon

FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=builder /app/build/libs/*.jar app.jar
USER 1000
HEALTHCHECK --interval=30s --timeout=3s CMD curl -f http://localhost:8080/actuator/health || exit 1
ENTRYPOINT ["java", "-jar", "app.jar"]
```

### HEALTHCHECK

Always add for production containers:
```dockerfile
# HTTP service
HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD curl -f http://localhost:8000/health || exit 1

# Non-HTTP (check process)
HEALTHCHECK --interval=30s --timeout=3s \
  CMD pgrep -x myapp || exit 1
```

### Security Essentials

```dockerfile
# Non-root user
RUN adduser -D -u 1000 appuser
USER appuser

# No secrets — use runtime env or mounted secrets
# BAD:  ENV API_KEY=secret123
# GOOD: docker run -e API_KEY=secret123 myapp

# Pin versions
FROM python:3.11.9-slim@sha256:abc123...

# BuildKit secret mount (for build-time secrets)
RUN --mount=type=secret,id=npmrc,target=/root/.npmrc npm ci
```

### BuildKit Features

```dockerfile
# syntax=docker/dockerfile:1

# Cache mount (persists between builds)
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install -r requirements.txt

# Secret mount (not stored in layer)
RUN --mount=type=secret,id=github_token \
    git clone https://$(cat /run/secrets/github_token)@github.com/...

# Heredoc (multi-line scripts cleanly)
RUN <<EOF
apt-get update
apt-get install -y curl
rm -rf /var/lib/apt/lists/*
EOF
```

### Docker Compose Considerations

When the Dockerfile is used in a compose context:
- Set `build.context` to minimize build context (not project root if avoidable)
- Use `build.cache_from` to pull cache layers from registry
- Named volumes for node_modules/venv avoid rebuild on code change
- `target` field in compose lets you stop at a build stage (for dev vs prod)

```yaml
services:
  app:
    build:
      context: .
      dockerfile: Dockerfile
      target: production  # stop at specific stage
      cache_from:
        - myregistry/myapp:latest
```

## Scoring Rubric

### Size (0-10)
| Score | Criteria |
|-------|----------|
| 0-2 | Full base image, no multi-stage, dev dependencies in runtime |
| 3-5 | Multi-stage used but base still large, or deps partially cleaned |
| 6-8 | Slim/alpine base, multi-stage, deps cleaned, .dockerignore present |
| 9-10 | Distroless/scratch, minimal layers, everything optimized |

### Security (0-10)
| Score | Criteria |
|-------|----------|
| 0-2 | Root user, secrets in image, unpinned versions |
| 3-5 | Non-root user OR pinned versions, but not both |
| 6-8 | Non-root, pinned, no secrets, minimal surface |
| 9-10 | All above + read-only filesystem, security scan clean |

### Build Performance (0-10)
| Score | Criteria |
|-------|----------|
| 0-2 | COPY . . before install, no caching strategy |
| 3-5 | Deps copied first, basic ordering |
| 6-8 | Cache mounts, good ordering, .dockerignore, BuildKit |
| 9-10 | All above + registry cache, parallel stages |

### Production Readiness (0-10)
| Score | Criteria |
|-------|----------|
| 0-2 | No HEALTHCHECK, no signal handling, no labels |
| 3-5 | HEALTHCHECK present OR labels present |
| 6-8 | HEALTHCHECK + labels + proper ENTRYPOINT (exec form) |
| 9-10 | All above + graceful shutdown, metadata labels (OCI) |

## Gotchas

- **Alpine + glibc:** Python packages with C extensions (numpy, grpc, pandas) often fail on alpine because it uses musl. Use `-slim` instead or install `gcompat`.
- **scratch without CA certs:** If your binary makes HTTPS calls from `scratch`, you MUST copy `/etc/ssl/certs/ca-certificates.crt` from the builder stage or TLS will fail.
- **COPY order matters more than you think:** `COPY . .` before `RUN pip install` means EVERY code change re-installs all dependencies. Always copy lockfile first, install, THEN copy code.
- **npm install vs npm ci:** Always use `npm ci` in Docker — it's faster, uses lockfile exactly, and cleans node_modules first.
- **Multi-stage variable scope:** ARGs defined before the first FROM are only available in FROM lines. ARGs needed in build commands must be redefined after FROM.
- **Layer count isn't everything:** 10 well-organized layers can be better than 3 massive ones because of cache reuse.
- **`--no-cache-dir` for pip:** Without it, pip stores downloaded packages in the image even though they'll never be used again.
- **HEALTHCHECK in K8s:** If deploying to Kubernetes, K8s has its own liveness/readiness probes — the Dockerfile HEALTHCHECK is still useful for `docker run` and compose but won't be used by K8s.
