#!/usr/bin/env bash
# Idempotent upsert of a repository ruleset from a JSON file.
#
# Usage:
#   ./scripts/apply-rulesets.sh .github/rulesets/main.json
#
# Requires:
#   - gh CLI authenticated as a repository admin.
#   - jq available on PATH.
#
# Exits 0 on success, non-zero on any failure. Safe to re-run; a ruleset
# with the same "name" as the file's `.name` is PATCHed in place if it
# already exists, otherwise POSTed.

set -euo pipefail

if [ "$#" -lt 1 ]; then
  echo "usage: $(basename "$0") <ruleset.json>" >&2
  exit 2
fi

payload_path="$1"
if [ ! -f "$payload_path" ]; then
  echo "::error::Ruleset file not found: $payload_path" >&2
  exit 1
fi

for cmd in gh jq; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "::error::Required command '$cmd' is not installed or not on PATH." >&2
    exit 1
  fi
done

repo="${GH_REPO:-$(gh repo view --json nameWithOwner --jq .nameWithOwner)}"
if [ -z "$repo" ]; then
  echo "::error::Could not determine the target repository. Set GH_REPO or run inside a git checkout." >&2
  exit 1
fi

name=$(jq -r '.name // empty' "$payload_path")
if [ -z "$name" ]; then
  echo "::error::$payload_path has no top-level .name field." >&2
  exit 1
fi

echo "Applying ruleset '$name' to $repo from $payload_path"

existing_id=$(gh api "repos/$repo/rulesets" --jq ".[] | select(.name == \"$name\") | .id" | head -n1)

if [ -n "$existing_id" ]; then
  echo "Found existing ruleset id=$existing_id, updating in place"
  gh api --method PUT "repos/$repo/rulesets/$existing_id" --input "$payload_path" > /dev/null
  echo "Updated ruleset $existing_id"
else
  echo "No ruleset named '$name' found, creating"
  gh api --method POST "repos/$repo/rulesets" --input "$payload_path" > /dev/null
  echo "Created ruleset '$name'"
fi

echo "Done."
