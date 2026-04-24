// Minimal self-contained Go module consumed by .github/workflows/selftest.yml.
// Zero external dependencies on purpose so `go mod download` is a no-op and
// the selftest run stays fast and offline-safe.
module github.com/ci-templates/selftest-go-app

go 1.22
