# selftest go-app fixture

Minimal Go module consumed by `.github/workflows/selftest.yml` so every change
to `reusable-ci.yml` is dog-fooded against a real Go stack before it is
shipped as part of `v2`.

Zero external dependencies on purpose: `go mod download` must stay a no-op
and `go test -race` must finish in seconds.
