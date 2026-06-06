#!/bin/sh
# Apply OpenIndiana/Solaris patches to Wine 8.0.2 source tree.
# Run from the Wine source root (directory containing configure.ac).
set -e
PATCHDIR=$(cd "$(dirname "$0")" && pwd)
cd "$(dirname "$PATCHDIR")" 2>/dev/null || cd .
if [ ! -f configure.ac ] || [ ! -f VERSION ]; then
  echo "Error: run from Wine 8.0.2 source root (configure.ac not found)" >&2
  exit 1
fi
PATCH=${PATCH:-/usr/gnu/bin/patch}
[ -x "$PATCH" ] || PATCH=patch
for p in $(sed s/#.*// "$PATCHDIR/series" | sed /^$/d); do
  echo "Applying $p ..."
  "$PATCH" -p1 --forward < "$PATCHDIR/$p"
done
echo "All patches applied."
