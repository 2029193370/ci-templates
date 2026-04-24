#!/usr/bin/env pwsh
<#
.SYNOPSIS
  Idempotent upsert of a repository ruleset from a JSON file.

.DESCRIPTION
  Looks up the ruleset by its `.name` field, updates it in place if it
  already exists, otherwise creates it. Safe to re-run.

.PARAMETER PayloadPath
  Path to the ruleset JSON file, e.g. `.github/rulesets/main.json`.

.PARAMETER Repo
  Optional `owner/name` override. Defaults to the current gh repo context.

.EXAMPLE
  ./scripts/apply-rulesets.ps1 .github/rulesets/main.json

.NOTES
  Requires the `gh` CLI authenticated as a repository admin. `GITHUB_TOKEN`
  from a default GitHub Actions run does not have the `administration: write`
  permission needed to manage rulesets.
#>

[CmdletBinding()]
param(
  [Parameter(Mandatory = $true, Position = 0)]
  [string]$PayloadPath,

  [Parameter(Mandatory = $false)]
  [string]$Repo
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path -LiteralPath $PayloadPath)) {
  Write-Error "Ruleset file not found: $PayloadPath"
  exit 1
}

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
  Write-Error "Required command 'gh' is not installed or not on PATH."
  exit 1
}

if (-not $Repo) {
  $Repo = (gh repo view --json nameWithOwner --jq .nameWithOwner).Trim()
  if (-not $Repo) {
    Write-Error "Could not determine target repository. Pass -Repo owner/name or run inside a git checkout."
    exit 1
  }
}

$payload = Get-Content -LiteralPath $PayloadPath -Raw | ConvertFrom-Json
if (-not $payload.name) {
  Write-Error "$PayloadPath has no top-level .name field."
  exit 1
}

$name = $payload.name
Write-Host "Applying ruleset '$name' to $Repo from $PayloadPath"

$existing = gh api "repos/$Repo/rulesets" | ConvertFrom-Json `
  | Where-Object { $_.name -eq $name } `
  | Select-Object -First 1

if ($existing) {
  Write-Host "Found existing ruleset id=$($existing.id), updating in place"
  gh api --method PUT "repos/$Repo/rulesets/$($existing.id)" --input $PayloadPath | Out-Null
  Write-Host "Updated ruleset $($existing.id)"
}
else {
  Write-Host "No ruleset named '$name' found, creating"
  gh api --method POST "repos/$Repo/rulesets" --input $PayloadPath | Out-Null
  Write-Host "Created ruleset '$name'"
}

Write-Host "Done."
