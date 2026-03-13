# rpi-libm2k-setup

Reproducible Raspberry Pi setup for building and installing:

- libiio
- libm2k

## Intended use

Validated on a Raspberry Pi 4 and 5 with base full Raspberry Pi OS (installed fresh by Raspberry Pi Imager v2.0.6).

## Quick start

```bash
git clone https://github.com/AlboSoc/rpi-libm2k-setup.git
cd rpi-libm2k-setup
chmod +x setup-rpi-libm2k.sh scripts/*.sh
./setup-rpi-libm2k.sh
```

## Customising release versions

The above sequence will install libm2k version v0.9.0 and libiio v0.26.
You can override these versions by either editing `env.sh` at these lines:
```bash
export LIBIIO_REF="${LIBIIO_REF:-v0.26}"
export LIBM2K_REF="${LIBM2K_REF:-v0.9.0}"
```
or by setting these env vars when launching `setup-rpi-libm2k.sh`, like so:
```
LIBIIO_REF="v0.25" LIBM2K_REF="v0.8.0" ./setup-rpi-libm2k.sh
```
using version numbers found in [libiio releases](https://github.com/analogdevicesinc/libiio/releases) and [libm2k releases](https://github.com/analogdevicesinc/libm2k/releases).
