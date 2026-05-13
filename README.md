# Project Name

This repository is ready to use with the `ci-templates` CI workflow.

## CI

The default workflow lives at `.github/workflows/ci.yml`. It calls the local
reusable workflow at `.github/workflows/reusable-ci.yml` and runs the checks
that match the files in this repository.

Private repositories skip optional integrations that need extra GitHub or
StepSecurity setup. After enabling those services, turn on the matching inputs
in `.github/workflows/ci.yml`.

## Start

Add your application code, commit, and push to `main`.
