#!/usr/bin/ksh
# Wine 8.0.2 configure for OpenIndiana (32-bit, OSS, NVIDIA 32-bit libGL)
set -e
export PATH=/usr/gnu/bin:/usr/bin:$PATH
ROOT=$(cd "$(dirname "$0")/.." && pwd)
cd "$ROOT"
# 32-bit libGL: only /usr/X11/lib/NVIDIA/libGL.so (Mesa is amd64-only)
export LDFLAGS="-L/usr/X11/lib/NVIDIA -R/usr/X11/lib/NVIDIA -lumem -m32"
./configure --prefix="${WINE_PREFIX:-$HOME/opt/wine-8.0.2}" \
  --with-oss --without-pulse --without-alsa --without-capi --disable-tests \
  CFLAGS="-std=gnu99 -O2 -m32 -Wno-incompatible-pointer-types -fcommon -D_XOPEN_SOURCE=600 -D__EXTENSIONS__" \
  CXXFLAGS="-std=gnu++11 -O2 -m32" \
  PKG_CONFIG_PATH="/usr/lib/32/pkgconfig"
