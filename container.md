# Container Development

---

## Docker

### Core 80%

```bash
docker ps
docker images
docker logs <container>
docker exec -it <container> bash
docker build -t app .
docker run app
docker stop <container>
docker rm <container>
```

Used for building and running containers.

---

## Docker Compose

### Core 80%

Start:

```bash
docker compose up
```

Background:

```bash
docker compose up -d
```

Logs:

```bash
docker compose logs -f
```

Stop:

```bash
docker compose down
```

Rebuild:

```bash
docker compose up --build
```

---

## dive

### What it does

Analyze Docker image layers.

### Common Commands

```bash
dive my-image:latest
```

### Typical Use

Reducing image size.

---

## lazydocker

### What it does

Terminal UI for Docker.

### Common Commands

```bash
lazydocker
```

### Typical Use

Daily Docker operations.

---

## ctop

### What it does

htop for containers.

### Common Commands

```bash
ctop
```

### Typical Use

Container resource monitoring.

---