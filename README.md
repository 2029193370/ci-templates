# ci-templates

[![CI - YAML Lint](https://github.com/2029193370/ci-templates/actions/workflows/ci-lint.yml/badge.svg)](https://github.com/2029193370/ci-templates/actions/workflows/ci-lint.yml)
[![CodeQL](https://github.com/2029193370/ci-templates/actions/workflows/codeql.yml/badge.svg)](https://github.com/2029193370/ci-templates/actions/workflows/codeql.yml)
[![Scorecard](https://github.com/2029193370/ci-templates/actions/workflows/scorecard.yml/badge.svg)](https://github.com/2029193370/ci-templates/actions/workflows/scorecard.yml)
[![OpenSSF Scorecard](https://api.scorecard.dev/projects/github.com/2029193370/ci-templates/badge)](https://scorecard.dev/viewer/?uri=github.com/2029193370/ci-templates)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](./LICENSE)

**企业级** 通用可复用 CI/CD 工作流模板。业务仓库只需接入一个约 10 行的 `ci.yml`，即可自动获得：
仓库卫生 → 7 语言 Lint+Build+Test+Coverage → 供应链安全（Trivy / Checkov / REUSE）→ 可选覆盖率上报。

> 核心理念：**一次配置，全组织共享**。修改本仓库一个文件，所有接入仓库下次 CI 自动获得更新。

---

## 为什么说这是"企业级"

- **供应链零信任** — 每个第三方 Action 均 pin 到 commit SHA，tag 作注释；Dependabot 自动跟进
- **Runtime 网络管控** — 每个 job 都先加载 `step-security/harden-runner`，只允许白名单出站
- **多层安全分析** — CodeQL (actions) · zizmor (Actions SAST) · gitleaks (git 历史密钥) · Trivy (漏洞+密钥) · Checkov (IaC) · OpenSSF Scorecard (行业安全评分)
- **自动化发版** — `release-please` 读 Conventional Commits，自动 bump 版本、生成 CHANGELOG、发 Release、并滑动 `v1` / `v2` 主版本 tag
- **全语言测试覆盖** — Layer 1 不仅 lint+build，还自动跑 test 并上传 coverage artifact，配合 Codecov
- **最小权限** — 每个 workflow 顶层 `contents: read`，必要时 job 级细粒度赋权
- **完整治理文件** — SECURITY.md · CODEOWNERS · PR/Issue 模板 · CONTRIBUTING.md · commitlint
- **跨平台决定性** — `.gitattributes` 强制 LF，彻底杜绝 Windows 贡献者 CRLF 问题

---

## 支持的技术栈

| 栈 | 检测 | Lint / Build | Test | Coverage |
|---|---|---|---|---|
| Node.js / TypeScript / Next.js | `package.json` | `npm ci` → `npm run lint` → `npm run build` | `npm test` | `coverage/` → Codecov |
| Java Maven | `pom.xml` | `mvn verify` | 同上 | JaCoCo `target/site/jacoco/` |
| Java Gradle | `build.gradle*` | `gradle check assemble` | 同上 | JaCoCo `build/reports/jacoco/` |
| PHP / Laravel | `composer.json` / `*.php` | `composer install` → `php -l` 全量 | `composer test` / `phpunit` | (自定义) |
| Python / Django / FastAPI | `requirements.txt` / `pyproject.toml` / `setup.py` / `Pipfile` | Flake8 E9/F63/F7/F82 | `pytest --cov` | `coverage.xml` |
| Go | `go.mod` | `go vet` → `go build` | `go test -race` | `coverage.out` |
| .NET / C# / F# | `*.csproj` / `*.sln` / `*.fsproj` | `dotnet restore` → `dotnet build -c Release` | `dotnet test` | Cobertura XML |
| Docker | `Dockerfile` / `Dockerfile.*` | Hadolint | — | — |

多版本 Matrix：通过 `node-versions: '["20","22"]'` / `python-versions: '["3.11","3.12"]'` 开启。

---

## 流水线结构

```text
Layer 0  Hygiene         ──┐
                           │
Layer 1  [node × matrix]   ├─► parallel
         [java]            │
         [php]             │
         [python × matrix] │
         [go]              │
         [dotnet]          │
         [docker]          │
                           ▼
         layer1-aggregate ──┐
                            │
Layer 2  Trivy              ├─► parallel
         Checkov (IaC)      │
         REUSE (license)    │
                            ▼
Layer 3  Coverage → Codecov
```

---

## 新项目接入（2 步）

### 第 1 步

将 [`starter/.github/workflows/ci.yml`](./starter/.github/workflows/ci.yml) 原样复制到新仓库相同路径下。

### 第 2 步

按需打开注释即可。未传的参数都有合理默认值，不存在的语言 job 会自动跳过。

```yaml
jobs:
  ci:
    uses: 2029193370/ci-templates/.github/workflows/reusable-ci.yml@v2
    with:
      node-versions: '["20","22"]'   # 多版本 matrix
      python-versions: '["3.11","3.12"]'
      enable-checkov: true           # Terraform/K8s/Dockerfile 扫描
      enable-license-scan: false     # REUSE SPDX
      harden-runner-policy: 'audit'  # 首次使用，稳定后改 'block'
    secrets:
      CODECOV_TOKEN: ${{ secrets.CODECOV_TOKEN }}
```

---

## 版本策略 / 升级

| 你的 `uses` 引用 | 行为 |
|---|---|
| `@v2` | 滑动主版本 — 自动获得 `v2.x.y` 的 minor/patch，不会跳到 v3 |
| `@v2.1.0` | 完全 pin — 任何情况下都复现 |
| `@main` | 跟随主分支 — 仅用于本仓库自身开发测试，生产不推荐 |

新版本由 `release-please` 根据 Conventional Commits 自动发布：

- `feat(...)` → minor bump
- `fix(...)` → patch bump
- `feat!:` 或 `BREAKING CHANGE:` → major bump

---

## 本仓库工作流总览

| 文件 | 作用 | 频率 |
|---|---|---|
| `workflows/reusable-ci.yml` | 对外暴露的可复用工作流 | on `workflow_call` |
| `workflows/ci-lint.yml` | 本仓库 YAML 语法校验 | push / PR |
| `workflows/codeql.yml` | CodeQL (actions 语言) | push / PR / 每周 |
| `workflows/zizmor.yml` | GH Actions SAST | push / PR / 每周 |
| `workflows/gitleaks.yml` | git 历史密钥扫描 | push / PR / 每周 |
| `workflows/scorecard.yml` | OpenSSF Scorecard | push / 每周 |
| `workflows/commitlint.yml` | PR 标题 Conventional Commits 校验 | PR |
| `workflows/release-please.yml` | 自动发版 + 滑动 `vN` tag | push main |
| `dependabot.yml` | 全生态依赖更新（含 Actions SHA） | 每周 |

---

## 故障排查 FAQ

### Q1. `harden-runner` 导致我的 CI 失败，日志里全是 blocked hosts
默认策略是 `audit` 仅审计、不阻断。如果你显式设了 `'block'`：到 job 页面 `Summary` 里点 `View insights` 查看真实出站域名清单，将合法的域名加到 `allowed-endpoints`（可在 harden-runner 的 `with:` 里覆盖），或改回 `audit` 模式。

### Q2. Dependabot 给 Actions SHA 开的 PR 冲突
因为 SHA 和注释 tag 都会变，手动 rebase 时要两处一起改。也可以直接 close 让 Dependabot 重新开。

### Q3. 我没有测试 / 不想跑测试
Layer 1 的 test 步骤只在 `npm test` / pytest 发现 / `dotnet test` 等实际存在时才跑，否则自动跳过，无需配置。

### Q4. 我的 monorepo 有多个 `package.json`
目前按 **根目录** package.json 为入口。Monorepo 需要在业务仓库里加自己的细粒度 workflow 调度各 workspace。

### Q5. `REUSE` 为什么默认关
REUSE 要求每个源文件都有 SPDX 头部注释，多数项目无法立刻合规。先用 `enable-license-scan: false`，等业务需要时再打开。

### Q6. `release-please` 不触发
它只响应 **Conventional Commits 消息**。如果你 squash merge 时写的是 "Merge pull request #42"，release-please 不会识别。在 PR 合并时把默认 squash message 改成 PR 标题（已通过 commitlint 保证规范）。

---

## License

[MIT](./LICENSE)
