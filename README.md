# rpi-libm2k-setup

Reproducible Raspberry Pi setup for building and installing:

- **libiio**
- **libm2k**

## Intended use

Validated on a Raspberry Pi 4 and 5 with base full Raspberry Pi OS  
(installed fresh by Raspberry Pi Imager v2.0.6).

## Quick start

```bash
git clone https://github.com/AlboSoc/rpi-libm2k-setup.git
cd rpi-libm2k-setup
bash setup-rpi-libm2k.sh
```

## Python install behaviour

The setup uses a split install model:

- Native libraries (`libiio`, `libm2k`) are installed system-wide into `$PREFIX`
  (default: `/usr/local`)
- Python bindings are built against the currently active `python3`
- If that `python3` is a virtual environment interpreter, the bindings are installed
  into that venv using `pip`
- Otherwise, the bindings are installed system-wide via the projects' CMake install step

This means:

- If you run the setup normally, Python bindings go into the system Python install path
- If you activate a virtual environment first, the bindings go into that venv

### Example: system Python

```bash
bash setup-rpi-libm2k.sh
```

### Example: active virtual environment

```bash
python3 -m venv ~/venvs/m2k
source ~/venvs/m2k/bin/activate

bash setup-rpi-libm2k.sh
```

In the second case:

- the bindings are built against `~/venvs/m2k/bin/python3`
- the Python packages are installed into that virtual environment
- the native shared libraries are still installed into `/usr/local`

> Note:
>
> On Raspberry Pi OS Bookworm and newer, pip usually refuses to install into the system Python. This setup handles that by installing Python bindings into a venv when one is active, and otherwise using the projects’ normal system install path.

## Customising release versions

By default the setup installs:

- **libiio**: `v0.26`
- **libm2k**: `v0.9.0`

These defaults are defined in `env.sh`:

```bash
export LIBIIO_REF="${LIBIIO_REF:-v0.26}"
export LIBM2K_REF="${LIBM2K_REF:-v0.9.0}"
```

You can override them either by editing `env.sh` or by setting environment variables when running the setup script:

```bash
LIBIIO_REF=v0.25 LIBM2K_REF=v0.8.0 ./setup-rpi-libm2k.sh
```

Release lists are available at:

- https://github.com/analogdevicesinc/libiio/releases
- https://github.com/analogdevicesinc/libm2k/releases

## Verifying the installation

You can verify the installation at any time using:

```bash
bash scripts/verify-libm2k.sh
```

If you installed the Python bindings into a virtual environment, activate that environment first:

```bash
source ~/venvs/m2k/bin/activate
bash scripts/verify-libm2k.sh
```

The verification script checks:

- that `libiio` and `libm2k` native libraries are visible
- that the Python modules `iio` and `libm2k` import correctly
- that a connected ADALM2000 device can be opened and queried

## Notes

- Native libraries are intentionally installed system-wide
- Only the Python bindings follow the active Python environment
- If you switch Python environments later, rerun:

```bash
bash scripts/install-python-bindings.sh
```

inside the desired environment.
