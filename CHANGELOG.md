# Changelog

All notable changes to this project will be documented in this file.
This file is automatically maintained by [release-please](https://github.com/googleapis/release-please).

## [2.2.0](https://github.com/2029193370/ci-templates/compare/v2.1.0...v2.2.0) (2026-04-24)


### Features

* **ci:** extend selftest dog-food to python, go and java ([9bb4959](https://github.com/2029193370/ci-templates/commit/9bb4959024873a62b7f82947c6124674bb855d64))
* **release:** sign release artefacts with sigstore and ship SPDX SBOM ([dc076f1](https://github.com/2029193370/ci-templates/commit/dc076f1eafac90cc62a05eb7780cf80970cf4455))

## [2.1.0](https://github.com/2029193370/ci-templates/compare/v2.0.0...v2.1.0) (2026-04-24)


### Features

* **ci:** dog-food reusable-ci.yml via selftest workflow and node fixture ([c9d1457](https://github.com/2029193370/ci-templates/commit/c9d14573e2880d1169cded59e8690fb0e51b5989))
* **installer:** add one-line installer and template-repo entry ([ef50d09](https://github.com/2029193370/ci-templates/commit/ef50d092eab993fc5f1111d7a2ac50b4739d5041))
* **starter:** add silent-by-default dependabot.yml template for consumers ([168deef](https://github.com/2029193370/ci-templates/commit/168deef9ef03df26e229a76b4f6e4f23bffd9246))


### Bug Fixes

* **ci:** align workflow detection and release metadata ([d779fa6](https://github.com/2029193370/ci-templates/commit/d779fa64e3891fda9c4caf11ada2811a9a659d55))
* **ci:** harden production defaults and workflow support ([4bef681](https://github.com/2029193370/ci-templates/commit/4bef681b61bb0e8edba6f7ae3fa1afcf3a0667c9))
* **security:** eliminate code-injection and token-permission findings ([845784b](https://github.com/2029193370/ci-templates/commit/845784becfee078ad4e94f70288bfae9a83f2a71))

## [2.0.0] - 2026-04-22

Initial tagged release. Establishes the reusable CI template.

### Features
- Layer 0 repo hygiene check
- Layer 1 code quality for Node.js / Java (Maven + Gradle) / PHP / Python / Go / .NET / Docker
- Layer 2 Trivy vulnerability and secret scan
- Layer 3 optional Codecov upload
- CodeQL, Yamllint and Dependabot for this repository

[2.0.0]: https://github.com/2029193370/ci-templates/releases/tag/v2.0.0
