# `.github/rulesets/`

Authoritative, version-controlled source of truth for repository rulesets.

Each JSON file in this directory matches the body GitHub's
[Repository Rulesets API][api] accepts on `POST /repos/{owner}/{repo}/rulesets`
and `PUT /repos/{owner}/{repo}/rulesets/{id}`. Server-only fields such as
`id`, `source`, `created_at`, `updated_at` and `_links` are intentionally
absent — they belong on the server, not in IaC.

| File | What it protects |
|------|------------------|
| `main.json` | Required checks, forbidden force-push / deletion, mandatory PR flow on `main`. Repository admins may bypass. |

## How to apply

Run the wrapper script from the repository root. It looks up the ruleset by
name, creates it if missing, updates it in place if present, and is safe
to re-run:

```bash
# bash / zsh
./scripts/apply-rulesets.sh .github/rulesets/main.json
```

```powershell
# PowerShell
./scripts/apply-rulesets.ps1 .github/rulesets/main.json
```

Both scripts require the [`gh` CLI][gh] authenticated with an account that
has repository admin rights (`gh auth status` should report `admin:repo`
scope). `GITHUB_TOKEN` from a default GitHub Actions run does **not** have
the required `administration: write` permission — automated sync needs a
PAT or GitHub App token stored as a repository secret.

## How to evolve

1. Edit the JSON file.
2. Open a pull request. CI, yamllint and downstream reviewers will see the
   diff in plain JSON.
3. After merge, a maintainer re-runs the apply script. The script is
   idempotent — drift between file and server is closed on every run.

[api]: https://docs.github.com/en/rest/repos/rules
[gh]: https://cli.github.com/
