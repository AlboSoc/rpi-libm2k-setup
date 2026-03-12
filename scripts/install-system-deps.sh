#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$REPO_ROOT/env.sh"

export DEBIAN_FRONTEND=noninteractive

echo "==> Installing system dependencies"

sudo apt-get update

sudo apt-get install -y \
    git \
    cmake \
    build-essential \
    g++ \
    pkg-config \
    swig \
    python3 \
    python3-dev \
    python3-setuptools \
    libusb-1.0-0-dev \
    libxml2 \
    libzstd-dev \
    libxml2-dev \
    bison \
    flex \
    libcdk5-dev \
    libaio-dev \
    libserialport-dev \
    libavahi-client-dev \
    doxygen \
    graphviz \
    libgoogle-glog-dev

echo "==> System dependencies installed"