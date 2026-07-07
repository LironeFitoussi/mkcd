#!/bin/sh
# Build a signed APT repository under ./public from a .deb.
# Requires: apt-ftparchive (apt-utils), gpg with the signing key imported.
#   sh packaging/publish-apt.sh mkcd_0.1.0_all.deb
set -eu

deb=${1:?usage: publish-apt.sh <package.deb>}
out=public

rm -rf "$out"
mkdir -p "$out/pool/main/m/mkcd"
cp "$deb" "$out/pool/main/m/mkcd/"

cd "$out"

# Architecture: all — same Packages index serves every arch dir apt looks in.
for arch in amd64 arm64; do
    mkdir -p "dists/stable/main/binary-$arch"
    apt-ftparchive packages pool > "dists/stable/main/binary-$arch/Packages"
    gzip -k9 "dists/stable/main/binary-$arch/Packages"
done

apt-ftparchive \
    -o APT::FTPArchive::Release::Origin=mkcd \
    -o APT::FTPArchive::Release::Label=mkcd \
    -o APT::FTPArchive::Release::Suite=stable \
    -o APT::FTPArchive::Release::Codename=stable \
    -o APT::FTPArchive::Release::Components=main \
    -o "APT::FTPArchive::Release::Architectures=amd64 arm64" \
    release dists/stable > dists/stable/Release

gpg --batch --yes -abs -o dists/stable/Release.gpg dists/stable/Release
gpg --batch --yes --clearsign -o dists/stable/InRelease dists/stable/Release
gpg --armor --export > gpg.key

# GitHub Pages: don't run Jekyll over the tree.
touch .nojekyll

printf 'apt repo built under %s\n' "$out"
