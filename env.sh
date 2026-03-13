#!/usr/bin/env bash
set -euo pipefail

# Where source trees and build directories live
export WORK_ROOT="${WORK_ROOT:-$HOME/src/rpi-libm2k}"
export SRC_ROOT="$WORK_ROOT/src"
export BUILD_ROOT="$WORK_ROOT/build"

# Installation prefix for locally built native packages
export PREFIX="${PREFIX:-/usr/local}"

# Parallelism
export JOBS="${JOBS:-$(nproc)}"

# Pin exact refs here.
export LIBIIO_REPO="${LIBIIO_REPO:-https://github.com/analogdevicesinc/libiio.git}"
export LIBIIO_REF="${LIBIIO_REF:-v0.26}"

export LIBM2K_REPO="${LIBM2K_REPO:-https://github.com/analogdevicesinc/libm2k.git}"
export LIBM2K_REF="${LIBM2K_REF:-v0.9.0}"

# Build type
export CMAKE_BUILD_TYPE="${CMAKE_BUILD_TYPE:-Release}"

# CMake generator
export CMAKE_GENERATOR="${CMAKE_GENERATOR:-Unix Makefiles}"

# Extra CMake flags can be injected by environment if needed
export LIBIIO_CMAKE_FLAGS="${LIBIIO_CMAKE_FLAGS:-}"
export LIBM2K_CMAKE_FLAGS="${LIBM2K_CMAKE_FLAGS:-}"

# Active Python interpreter.
# If a virtual environment is activated, this will usually resolve to that venv.
export PYTHON_EXE="${PYTHON_EXE:-$(command -v python3)}"

validate_python_target() {
    if [[ -z "${PYTHON_EXE:-}" ]]; then
        echo "ERROR: PYTHON_EXE is empty"
        exit 1
    fi

    if [[ ! -x "$PYTHON_EXE" ]]; then
        echo "ERROR: Python executable '$PYTHON_EXE' was not found or is not executable."
        exit 1
    fi
}

python_site_packages() {
    "$PYTHON_EXE" - <<'PY'
import sysconfig
print(sysconfig.get_path("platlib"))
PY
}