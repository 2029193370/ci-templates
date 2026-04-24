# selftest python-app fixture

Minimal Python project consumed by `.github/workflows/selftest.yml` so every
change to `reusable-ci.yml` is dog-fooded against a real Python stack before
it is shipped as part of `v2`.

Zero runtime dependencies on purpose: `pip install -e .` must stay
fast and offline-safe. `pytest`, `flake8` and `coverage` are installed by
`reusable-ci.yml` itself.
