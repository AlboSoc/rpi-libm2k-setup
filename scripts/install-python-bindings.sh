#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$REPO_ROOT/env.sh"
validate_python_target

mkdir -p "$SRC_ROOT" "$BUILD_ROOT"

export PKG_CONFIG_PATH="$PREFIX/lib/pkgconfig:$PREFIX/lib64/pkgconfig:${PKG_CONFIG_PATH:-}"
export CMAKE_PREFIX_PATH="$PREFIX:${CMAKE_PREFIX_PATH:-}"
export LD_LIBRARY_PATH="$PREFIX/lib:$PREFIX/lib64:${LD_LIBRARY_PATH:-}"

is_venv_python() {
    "$PYTHON_EXE" -c 'import sys; exit(int(sys.prefix == sys.base_prefix))'
}

echo "==> Installing Python bindings"
echo "==> PYTHON_EXE=$PYTHON_EXE"
echo "==> site-packages=$(python_site_packages)"

#
# libiio Python bindings
#
LIBIIO_SRC="$SRC_ROOT/libiio"
LIBIIO_PY_BUILD="$BUILD_ROOT/libiio-python"

rm -rf "$LIBIIO_PY_BUILD"
mkdir -p "$LIBIIO_PY_BUILD"

echo "==> Configuring libiio Python bindings build"
cmake -S "$LIBIIO_SRC" -B "$LIBIIO_PY_BUILD" \
    -G "$CMAKE_GENERATOR" \
    -DCMAKE_BUILD_TYPE="$CMAKE_BUILD_TYPE" \
    -DCMAKE_INSTALL_PREFIX="$PREFIX" \
    -DPYTHON_BINDINGS=ON \
    -DCPP_BINDINGS=OFF \
    -DPython_EXECUTABLE="$PYTHON_EXE" \
    $LIBIIO_CMAKE_FLAGS

echo "==> Building libiio Python bindings"
cmake --build "$LIBIIO_PY_BUILD" -- -j"$JOBS"

#
# libm2k Python bindings
#
LIBM2K_SRC="$SRC_ROOT/libm2k"
LIBM2K_PY_BUILD="$BUILD_ROOT/libm2k-python"

rm -rf "$LIBM2K_PY_BUILD"
mkdir -p "$LIBM2K_PY_BUILD"

echo "==> Configuring libm2k Python bindings build"
cmake -S "$LIBM2K_SRC" -B "$LIBM2K_PY_BUILD" \
    -G "$CMAKE_GENERATOR" \
    -DCMAKE_BUILD_TYPE="$CMAKE_BUILD_TYPE" \
    -DCMAKE_INSTALL_PREFIX="$PREFIX" \
    -DENABLE_PYTHON=ON \
    -DPython_EXECUTABLE="$PYTHON_EXE" \
    $LIBM2K_CMAKE_FLAGS

echo "==> Building libm2k Python bindings"
cmake --build "$LIBM2K_PY_BUILD" -- -j"$JOBS"

if is_venv_python; then
    echo "==> Detected virtual environment Python"
    echo "==> Installing Python bindings into active venv with pip"

    "$PYTHON_EXE" -m pip install --upgrade pip setuptools wheel

    "$PYTHON_EXE" -m pip install --no-deps --force-reinstall \
        "$LIBIIO_PY_BUILD/bindings/python"

    "$PYTHON_EXE" -m pip install --no-deps --force-reinstall \
        "$LIBM2K_PY_BUILD"
else
    echo "==> Detected system Python"
    echo "==> Installing Python bindings system-wide via CMake install"

    sudo cmake --install "$LIBIIO_PY_BUILD"
    sudo cmake --install "$LIBM2K_PY_BUILD"
    sudo ldconfig
fi

echo "==> Python bindings install complete"