#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$REPO_ROOT/env.sh"
validate_python_target

export PKG_CONFIG_PATH="$PREFIX/lib/pkgconfig:$PREFIX/lib64/pkgconfig:${PKG_CONFIG_PATH:-}"
export LD_LIBRARY_PATH="$PREFIX/lib:$PREFIX/lib64:${LD_LIBRARY_PATH:-}"

echo "==> Verifying installed native libraries"
ldconfig -p | grep -E 'libiio|libm2k' || true

echo
echo "==> Verifying pkg-config metadata"
pkg-config --modversion libiio || {
    echo "ERROR: pkg-config cannot find libiio"
    exit 1
}

if pkg-config --exists libm2k; then
    pkg-config --modversion libm2k
else
    echo "WARNING: pkg-config cannot find libm2k"
fi

echo
echo "==> Verifying Python imports with $PYTHON_EXE"
echo "==> site-packages=$(python_site_packages)"

"$PYTHON_EXE" - <<'PY'
import sys

print("Python executable:", sys.executable)
print("Python version:", sys.version)

try:
    import iio
    print("Imported iio OK")
    print("iio module:", getattr(iio, "__file__", "<unknown>"))
except Exception as e:
    print("ERROR importing iio:", e)
    raise

try:
    print(f"{iio.version=}")
except Exception as e:
    print("Could not get iio.version:", e)

try:
    import libm2k
    print("Imported libm2k OK")
    print("libm2k module:", getattr(libm2k, "__file__", "<unknown>"))
except Exception as e:
    print("ERROR importing libm2k:", e)
    raise

try:
    print(f"{libm2k.getVersion()=}")
except Exception as e:
    print("Could not call libm2k.getVersion():", e)
PY

echo
echo "==> Checking for locally connected M2k device"

"$PYTHON_EXE" - <<'PY'
import sys

try:
    import libm2k
except Exception as e:
    print("ERROR: libm2k import failed:", e)
    sys.exit(1)

ctx = None
try:
    ctx = libm2k.m2kOpen()
    if ctx is None:
        print("No ADALM2000 detected. Software install appears OK, but no device is connected.")
        sys.exit(0)

    print("ADALM2000 detected and opened successfully.")

    try:
        serial = ctx.getSerialNumber()
        print("Serial number:", serial)
    except Exception as e:
        print("Opened device, but could not read serial:", e)

    try:
        fw = ctx.getFirmwareVersion()
        print("Firmware version:", fw)
    except Exception as e:
        print("Opened device, but could not read firmware version:", e)

    print("libm2k functional smoke test passed.")
finally:
    if ctx is not None:
        try:
            libm2k.contextClose(ctx)
        except Exception:
            pass
PY

echo
echo "==> Verification complete"