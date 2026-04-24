# selftest java-app fixture

Minimal Maven project consumed by `.github/workflows/selftest.yml` so every
change to `reusable-ci.yml` is dog-fooded against a real Java + Maven stack
before it is shipped as part of `v2`.

All plugin and test-scope dependency versions are pinned explicitly. The
production dependency tree is deliberately empty so `mvn -B -ntp verify`
only downloads a handful of well-known artefacts from Maven Central.
