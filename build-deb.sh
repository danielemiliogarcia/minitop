#!/bin/bash
set -e

APP_NAME="minitop"
VERSION="1.1"
ARCH="all"
PKG_DIR="${APP_NAME}_${VERSION}"

# Clean previous build
rm -rf "$PKG_DIR" "${PKG_DIR}.deb"

# Create structure
mkdir -p "$PKG_DIR/DEBIAN"
mkdir -p "$PKG_DIR/usr/local/bin"
mkdir -p "$PKG_DIR/usr/share/man/man1"

# Copy scripts
cp ./minitop "$PKG_DIR/usr/local/bin/minitop"
cp ./minitop-core.sh "$PKG_DIR/usr/local/bin/minitop-core.sh"
chmod 755 "$PKG_DIR/usr/local/bin/"*

# Copy man page (gzip it as required)
gzip -c minitop.1 > "$PKG_DIR/usr/share/man/man1/minitop.1.gz"

# Control file
cat <<EOF > "$PKG_DIR/DEBIAN/control"
Package: $APP_NAME
Version: $VERSION
Section: utils
Priority: optional
Architecture: $ARCH
Depends: bash, coreutils, procps, gawk
Maintainer: Emilio Garcia <contacto@emiliogarcia.com.ar>
Description: A lightweight real-time system monitor in Bash.
 Shows CPU, memory, load, network and disk usage.
EOF

chmod 644 "$PKG_DIR/DEBIAN/control"

# Build it
dpkg-deb --build "$PKG_DIR"
echo "Built ${PKG_DIR}.deb"
echo "Install it with: sudo apt install ./${PKG_DIR}.deb"
echo "Use: man minitop"

