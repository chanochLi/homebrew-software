#!/usr/bin/env bash
set -euo pipefail

CASK_PATH="Casks/next-ai-draw-io.rb"
REPO="DayuanJiang/next-ai-draw-io"

tag="$(curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest" | \
  ruby -rjson -e 'print JSON.parse(STDIN.read)["tag_name"]')"

version="${tag#v}"
echo "Latest tag: $tag => version: $version"

arm_url="https://github.com/${REPO}/releases/download/v${version}/Next-AI-Draw.io-${version}-arm64.dmg"

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

echo "Downloading arm dmg..."
curl -fL "$arm_url" -o "$tmpdir/arm.dmg"
arm_sha="$(shasum -a 256 "$tmpdir/arm.dmg" | awk '{print $1}')"
echo "arm sha256: $arm_sha"

ruby -i -pe "
  gsub(/version\\s+\"[^\"]+\"/, 'version \"${version}\"');

  # 替换 arm sha
  gsub(/sha256\\s+arm:\\s+\"[0-9a-f]{64}\"/, 'sha256 arm: \"${arm_sha}\"');
" "$CASK_PATH"

echo "Updated $CASK_PATH"
