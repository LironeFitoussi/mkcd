#!/bin/sh
# Build mkcd .deb with dpkg-deb. Run from repo root on a system with dpkg.
#   sh packaging/build-deb.sh
set -eu

version=$(grep -m1 '^Version:' packaging/debian/control | cut -d' ' -f2)
staging=$(mktemp -d)
trap 'rm -rf "$staging"' EXIT

install -d "$staging/DEBIAN" "$staging/usr/share/mkcd" "$staging/usr/share/doc/mkcd"
install -m 0644 packaging/debian/control "$staging/DEBIAN/control"
install -m 0644 mkcd.sh "$staging/usr/share/mkcd/mkcd.sh"
install -m 0644 README.md "$staging/usr/share/doc/mkcd/README.md"
install -m 0644 LICENSE "$staging/usr/share/doc/mkcd/copyright"

dpkg-deb --build --root-owner-group "$staging" "mkcd_${version}_all.deb"
printf 'built mkcd_%s_all.deb\n' "$version"
