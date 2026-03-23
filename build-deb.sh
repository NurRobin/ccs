#!/usr/bin/env bash
# Build a .deb package for cc
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
VERSION=$(grep -oP 'CC_VERSION="\K[^"]+' "$SCRIPT_DIR/cc")
PKG_NAME="cc"
BUILD_DIR=$(mktemp -d)

trap 'rm -rf "$BUILD_DIR"' EXIT

# Package structure
mkdir -p "$BUILD_DIR/DEBIAN"
mkdir -p "$BUILD_DIR/usr/local/bin"

# Install script
install -m 755 "$SCRIPT_DIR/cc" "$BUILD_DIR/usr/local/bin/cc"

# Control file with current version
sed "s/^Version:.*/Version: ${VERSION}/" "$SCRIPT_DIR/debian/control" > "$BUILD_DIR/DEBIAN/control"

# Build
OUTPUT="${SCRIPT_DIR}/dist/${PKG_NAME}_${VERSION}_all.deb"
mkdir -p "$SCRIPT_DIR/dist"
dpkg-deb --build --root-owner-group "$BUILD_DIR" "$OUTPUT"

echo ""
echo "Built: $OUTPUT"
echo "Install: sudo dpkg -i $OUTPUT"
