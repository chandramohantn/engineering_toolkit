# Portable Workspace Template

Use these files to turn any directory into an AI/ML workspace using your pre-built toolkit images.

## Setup Instructions

1.  **Build your images** once in the main `engineering_toolkit/workspaces` directory using `make build-all`.
2.  **Copy** `docker-compose.yml` and `Makefile` from this folder into your project (e.g., `/Users/learner/projects/my-new-project`).
3.  **Customize** the `WORKSPACE_IMAGE` variable in the `Makefile` to choose your environment (ML, DL, or LLM).
4.  **Run** the workspace:
    ```bash
    make up
    ```

## Benefits
- **No Build Required**: Uses the images already stored in your local Docker registry.
- **Project-Specific**: Keep your launch commands and environment choice versioned with your project code.
- **Seamless Monitoring**: Dozzle starts automatically for every project.
