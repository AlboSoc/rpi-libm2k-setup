#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$REPO_ROOT/env.sh"

echo "==> Using WORK_ROOT=$WORK_ROOT"
echo "==> Using PREFIX=$PREFIX"
echo "==> Using LIBIIO_REF=$LIBIIO_REF"
echo "==> Using LIBM2K_REF=$LIBM2K_REF"

mkdir -p "$SRC_ROOT" "$BUILD_ROOT"

"$REPO_ROOT/scripts/install-system-deps.sh"
"$REPO_ROOT/scripts/build-libiio.sh"
"$REPO_ROOT/scripts/build-libm2k.sh"
"$REPO_ROOT/scripts/verify-libm2k.sh"

echo
echo "Setup complete."