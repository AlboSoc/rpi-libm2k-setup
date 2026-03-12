#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$REPO_ROOT/env.sh"

mkdir -p "$SRC_ROOT" "$BUILD_ROOT"

LIBIIO_SRC="$SRC_ROOT/libiio"
LIBIIO_BUILD="$BUILD_ROOT/libiio"

if [[ ! -d "$LIBIIO_SRC/.git" ]]; then
    echo "==> Cloning libiio"
    git clone "$LIBIIO_REPO" "$LIBIIO_SRC"
fi

echo "==> Fetching libiio refs"
git -C "$LIBIIO_SRC" fetch --all --tags

echo "==> Checking out libiio ref: $LIBIIO_REF"
git -C "$LIBIIO_SRC" checkout "$LIBIIO_REF"

rm -rf "$LIBIIO_BUILD"
mkdir -p "$LIBIIO_BUILD"

echo "==> Configuring libiio"
cmake -S "$LIBIIO_SRC" -B "$LIBIIO_BUILD" \
    -G "$CMAKE_GENERATOR" \
    -DCMAKE_BUILD_TYPE="$CMAKE_BUILD_TYPE" \
    -DCMAKE_INSTALL_PREFIX="$PREFIX" \
    -DPYTHON_BINDINGS=ON \
    -DCPP_BINDINGS=ON \
    $LIBIIO_CMAKE_FLAGS

echo "==> Building libiio"
cmake --build "$LIBIIO_BUILD" -- -j"$JOBS"

echo "==> Installing libiio"
sudo cmake --install "$LIBIIO_BUILD"

echo "==> Refreshing linker cache"
sudo ldconfig

echo "==> libiio build/install complete"