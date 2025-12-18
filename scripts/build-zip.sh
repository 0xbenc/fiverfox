#!/usr/bin/env bash
set -euo pipefail

repo_root="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/.." >/dev/null 2>&1
  pwd
)"

cd "$repo_root"

out_dir="packages"
out_zip="$out_dir/fiversox.zip"

if ! command -v zip >/dev/null 2>&1; then
  echo "Error: 'zip' is not installed or not on PATH." >&2
  exit 1
fi

mkdir -p "$out_dir"
rm -f "$out_zip"
zip -r "$out_zip" icons popup manifest.json
echo "Wrote $out_zip"
