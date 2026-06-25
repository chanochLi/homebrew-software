#!/usr/bin/env bash
set -euo pipefail

CASK_PATH="Casks/j-hen-tai.rb"
REPO="jiangtian616/JHenTai"
API_URL="https://api.github.com/repos/${REPO}/releases/latest"

curl_github() {
  local url="$1"
  local output="$2"
  local attempt http_code

  for attempt in 1 2 3; do
    http_code="$(
      curl -sS -w '%{http_code}' -o "$output" \
        ${GITHUB_TOKEN:+-H "Authorization: Bearer ${GITHUB_TOKEN}"} \
        -H "Accept: application/vnd.github+json" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        "$url"
    )"

    if [[ "$http_code" == "200" ]]; then
      return 0
    fi

    if [[ "$http_code" == "403" || "$http_code" == "429" ]] && [[ "$attempt" -lt 3 ]]; then
      echo "GitHub API returned HTTP ${http_code}, retrying in ${attempt}s..." >&2
      sleep "$attempt"
      continue
    fi

    echo "GitHub API request failed: HTTP ${http_code} for ${url}" >&2
    if [[ -s "$output" ]]; then
      ruby -e 'STDERR.write(File.read(ARGV[0]))' "$output"
    fi
    return 1
  done
}

current_version="$(ruby -e "
  cask = File.read('${CASK_PATH}')
  if cask =~ /version\s+\"([^\"]+)\"/
    print \$1
  else
    abort 'Could not read current version from ${CASK_PATH}'
  end
")"

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

api_response="${tmpdir}/release.json"
curl_github "$API_URL" "$api_response"

release_info="$(
  ruby -rjson -e '
    data = JSON.parse(File.read(ARGV[0]))
    tag = data["tag_name"]
    abort "Missing tag_name in GitHub API response" if tag.nil? || tag.empty?

    version = tag.delete_prefix("v")
    expected_asset_name = "JHenTai-#{version}.dmg"
    asset = data.fetch("assets", []).find { |item| item["name"] == expected_asset_name }
    asset ||= data.fetch("assets", []).find { |item| item["name"].to_s.match?(/\AJHenTai-.+\.dmg\z/) }
    abort "Could not find macOS DMG asset for #{tag}" if asset.nil?

    digest = asset["digest"].to_s
    sha256 = digest.delete_prefix("sha256:") if digest.start_with?("sha256:")

    puts [tag, version, asset.fetch("name"), asset.fetch("browser_download_url"), sha256].join("\t")
  ' "$api_response"
)"

IFS=$'\t' read -r tag version asset_name asset_url sha256 <<<"$release_info"

echo "Latest tag: $tag => version: $version"
echo "macOS asset: $asset_name"

if [[ "$version" == "$current_version" ]]; then
  echo "Already at version ${version}, nothing to do."
  exit 0
fi

if [[ -z "${sha256:-}" ]]; then
  echo "Downloading dmg to calculate sha256..."
  curl -fL \
    ${GITHUB_TOKEN:+-H "Authorization: Bearer ${GITHUB_TOKEN}"} \
    "$asset_url" -o "$tmpdir/jhentai.dmg"
  sha256="$(shasum -a 256 "$tmpdir/jhentai.dmg" | awk '{print $1}')"
fi

echo "sha256: $sha256"

ruby -i -pe "
  gsub(/version\s+\"[^\"]+\"/, 'version \"${version}\"');
  gsub(/sha256\s+\"[0-9a-f]{64}\"/, 'sha256 \"${sha256}\"');
" "$CASK_PATH"

echo "Updated $CASK_PATH to version ${version}"
