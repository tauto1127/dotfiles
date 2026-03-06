#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
IMAGE_NAME="${IMAGE_NAME:-dotfiles-installer-test:latest}"
MODE="${1:-test}"

docker build -f "$ROOT_DIR/tests/installer/Dockerfile" -t "$IMAGE_NAME" "$ROOT_DIR"

if [[ "$MODE" == "--shell" || "$MODE" == "shell" ]]; then
  docker run --rm -it --entrypoint bash "$IMAGE_NAME"
else
  docker run --rm "$IMAGE_NAME"
fi
