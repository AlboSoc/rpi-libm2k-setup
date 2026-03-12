#!/usr/bin/env bash
set -euo pipefail

# Where source trees and build directories live
export WORK_ROOT="${WORK_ROOT:-$HOME/src/rpi-libm2k}"
export SRC_ROOT="$WORK_ROOT/src"
export BUILD_ROOT="$WORK_ROOT/build"

# Installation prefix for locally built packages
export PREFIX="${PREFIX:-/usr/local}"

# Parallelism
export JOBS="${JOBS:-$(nproc)}"

# Pin exact refs here.
# Replace these placeholders with the exact tag/commit you validate.
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