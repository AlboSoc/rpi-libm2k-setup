#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$REPO_ROOT/env.sh"
validate_python_target

mkdir -p "$SRC_ROOT" "$BUILD_ROOT"

LIBM2K_SRC="$SRC_ROOT/libm2k"
LIBM2K_BUILD="$BUILD_ROOT/libm2k"

if [[ ! -d "$LIBM2K_SRC/.git" ]]; then
    echo "==> Cloning libm2k"
    git clone "$LIBM2K_REPO" "$LIBM2K_SRC"
fi

echo "==> Fetching libm2k refs"
git -C "$LIBM2K_SRC" fetch --all --tags

echo "==> Checking out libm2k ref: $LIBM2K_REF"
git -C "$LIBM2K_SRC" checkout "$LIBM2K_REF"

rm -rf "$LIBM2K_BUILD"
mkdir -p "$LIBM2K_BUILD"

export PKG_CONFIG_PATH="$PREFIX/lib/pkgconfig:$PREFIX/lib64/pkgconfig:${PKG_CONFIG_PATH:-}"
export CMAKE_PREFIX_PATH="$PREFIX:${CMAKE_PREFIX_PATH:-}"

echo "==> Configuring libm2k (native library only)"
cmake -S "$LIBM2K_SRC" -B "$LIBM2K_BUILD" \
    -G "$CMAKE_GENERATOR" \
    -DCMAKE_BUILD_TYPE="$CMAKE_BUILD_TYPE" \
    -DCMAKE_INSTALL_PREFIX="$PREFIX" \
    -DENABLE_PYTHON=OFF \
    $LIBM2K_CMAKE_FLAGS

echo "==> Building libm2k"
cmake --build "$LIBM2K_BUILD" -- -j"$JOBS"

echo "==> Installing libm2k"
sudo cmake --install "$LIBM2K_BUILD"

echo "==> Refreshing linker cache"
sudo ldconfig

echo "==> libm2k native build/install complete"