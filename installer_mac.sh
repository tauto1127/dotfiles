#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "installer_mac.sh is deprecated; use installer.sh instead."
exec bash "$SCRIPT_DIR/installer.sh" "$@"
