#!/usr/bin/env bash
# Build a .deb package for ccs
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
VERSION=$(grep -oP 'CCS_VERSION="\K[^"]+' "$SCRIPT_DIR/ccs")
PKG_NAME="ccs"
BUILD_DIR=$(mktemp -d)

trap 'rm -rf "$BUILD_DIR"' EXIT

mkdir -p "$BUILD_DIR/DEBIAN"
mkdir -p "$BUILD_DIR/usr/local/bin"
mkdir -p "$BUILD_DIR/usr/share/man/man1"
mkdir -p "$BUILD_DIR/usr/share/bash-completion/completions"
mkdir -p "$BUILD_DIR/usr/share/zsh/vendor-completions"

install -m 755 "$SCRIPT_DIR/ccs" "$BUILD_DIR/usr/local/bin/ccs"
gzip -9n -c "$SCRIPT_DIR/ccs.1" > "$BUILD_DIR/usr/share/man/man1/ccs.1.gz"
install -m 644 "$SCRIPT_DIR/completions/ccs.bash" "$BUILD_DIR/usr/share/bash-completion/completions/ccs"
install -m 644 "$SCRIPT_DIR/completions/_ccs" "$BUILD_DIR/usr/share/zsh/vendor-completions/_ccs"

sed "s/^Version:.*/Version: ${VERSION}/" "$SCRIPT_DIR/debian/control" > "$BUILD_DIR/DEBIAN/control"

OUTPUT="${SCRIPT_DIR}/dist/${PKG_NAME}_${VERSION}_all.deb"
mkdir -p "$SCRIPT_DIR/dist"
dpkg-deb --build --root-owner-group "$BUILD_DIR" "$OUTPUT"

echo ""
echo "Built: $OUTPUT"
echo "Install: sudo dpkg -i $OUTPUT"
