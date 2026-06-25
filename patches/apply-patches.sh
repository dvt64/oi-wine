#!/usr/bin/env bash
# Apply Oracle Solaris patches to oi-wine (on top of upstream illumos patches).
# Usage: ./apply-patches.sh [path/to/solaris-wine]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SRC_DIR="${1:-$ROOT_DIR/solaris-wine}"

if [ ! -f "$SRC_DIR/configure.ac" ] || [ ! -f "$SRC_DIR/VERSION" ]; then
	echo "error: Wine source not found: $SRC_DIR" >&2
	exit 1
fi

PATCH=${PATCH:-patch}
[ -x "$PATCH" ] || PATCH=/usr/gnu/bin/patch

apply_patch() {
	local patch_file="$1"
	local name
	name="$(basename "$patch_file")"

	if "$PATCH" -p1 -R --dry-run --silent -i "$patch_file" </dev/null 2>/dev/null; then
		echo "already applied: $name"
		return 0
	fi

	echo "applying: $name"
	(cd "$SRC_DIR" && "$PATCH" -p1 --forward -i "$patch_file")
}

apply_patch "$SCRIPT_DIR/001-oracle-solaris-ucontext.patch"

echo "done."
