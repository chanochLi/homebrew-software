#!/usr/bin/env bash
set -euo pipefail

CASK_PATH="Casks/openwork.rb"
REPO="different-ai/openwork"

tag="$(curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest" | \
  ruby -rjson -e 'print JSON.parse(STDIN.read)["tag_name"]')"

version="${tag#v}"
echo "Latest tag: $tag => version: $version"

arm_url="https://github.com/${REPO}/releases/download/v${version}/openwork-desktop-darwin-aarch64.dmg"
intel_url="https://github.com/${REPO}/releases/download/v${version}/openwork-desktop-darwin-x64.dmg"

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

echo "Downloading arm dmg..."
curl -fL "$arm_url" -o "$tmpdir/arm.dmg"
arm_sha="$(shasum -a 256 "$tmpdir/arm.dmg" | awk '{print $1}')"
echo "arm sha256: $arm_sha"

echo "Downloading intel dmg..."
curl -fL "$intel_url" -o "$tmpdir/intel.dmg"
intel_sha="$(shasum -a 256 "$tmpdir/intel.dmg" | awk '{print $1}')"
echo "intel sha256: $intel_sha"

ruby -i -pe "
  gsub(/version\\s+\"[^\"]+\"/, 'version \"${version}\"');
  gsub(/sha256\\s+arm:\\s+\"[0-9a-f]{64}\"/, 'sha256 arm: \"${arm_sha}\"');
  gsub(/intel:\\s+\"[0-9a-f]{64}\"/, 'intel: \"${intel_sha}\"');
" "$CASK_PATH"

echo "Updated $CASK_PATH"
