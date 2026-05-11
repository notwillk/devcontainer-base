# devcontainer-base

This repository builds and publishes a reusable base image for development containers.

The goal is to have one place to keep the common tooling needed across devcontainers so other repositories can start from a known-good image instead of repeating the same setup in every `Dockerfile`.

At the moment, this image extends the upstream Ubuntu-based devcontainer image and adds:

- Docker Engine and CLI tooling for Docker-in-Docker style workflows
- Docker Compose and Buildx plugins
- Ansible
- A small entrypoint that starts `dockerd` when the container launches

The published image is:

`ghcr.io/notwillk/devcontainer-base:latest`

## How to use it

Use the image directly in a devcontainer config:

```json
{
  "name": "my-project",
  "image": "ghcr.io/notwillk/devcontainer-base:latest"
}
```

If your workflow needs the Docker daemon inside the devcontainer, make sure the container is started with the privileges/capabilities needed for `dockerd`. This repository's image entrypoint is set up for that use case.

You can also pull and inspect the image manually:

```sh
docker pull ghcr.io/notwillk/devcontainer-base:latest
docker run --rm -it --privileged ghcr.io/notwillk/devcontainer-base:latest bash
```

## How this repository works

This repository is intentionally small:

- `Dockerfile` builds the image on top of `mcr.microsoft.com/devcontainers/base:ubuntu` and installs Docker plus Ansible
- `entrypoint.sh` starts `dockerd` in the background before handing off to the requested command
- `test.sh` verifies that Docker, Compose, Buildx, the Docker daemon, and Ansible are available inside the built image
- `.github/workflows/build.yml` builds the image in CI, runs `test.sh`, and pushes `latest` plus a SHA-tagged image to GHCR from `main`
- `LICENSE` contains the repository license

## What to know next time you come back

If you are picking this repository up later, the important mental model is:

1. `Dockerfile` defines the actual devcontainer base image
2. `entrypoint.sh` makes Docker available inside the container
3. `test.sh` is the contract for what the image is expected to provide
4. the GitHub Actions workflow is the release pipeline

So if you want to change what downstream devcontainers get, start with `Dockerfile`; if you want to change how the container boots, look at `entrypoint.sh`; and if you want confidence that the image still works, follow `test.sh` and the workflow.
