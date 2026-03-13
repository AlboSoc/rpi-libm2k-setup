#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$REPO_ROOT/env.sh"
validate_python_target

echo "==> Using WORK_ROOT=$WORK_ROOT"
echo "==> Using PREFIX=$PREFIX"
echo "==> Using LIBIIO_REF=$LIBIIO_REF"
echo "==> Using LIBM2K_REF=$LIBM2K_REF"
echo "==> Using PYTHON_EXE=$PYTHON_EXE"
echo "==> Python site-packages: $(python_site_packages)"

mkdir -p "$SRC_ROOT" "$BUILD_ROOT"

bash "$REPO_ROOT/scripts/install-system-deps.sh"
bash "$REPO_ROOT/scripts/build-libiio.sh"
bash "$REPO_ROOT/scripts/build-libm2k.sh"
bash "$REPO_ROOT/scripts/install-python-bindings.sh"
bash "$REPO_ROOT/scripts/verify-libm2k.sh"

echo
echo "Setup complete."