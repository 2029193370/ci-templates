# ci-templates

[![CI - YAML Lint](https://github.com/2029193370/ci-templates/actions/workflows/ci-lint.yml/badge.svg)](https://github.com/2029193370/ci-templates/actions/workflows/ci-lint.yml)
[![CodeQL](https://github.com/2029193370/ci-templates/actions/workflows/codeql.yml/badge.svg)](https://github.com/2029193370/ci-templates/actions/workflows/codeql.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](./LICENSE)

企业级通用 **可复用 CI 工作流模板**。业务仓库只需接入一个约 10 行的 `ci.yml`，即可自动获得：
仓库卫生 → 多语言 Lint/Build → 安全漏洞与密钥泄露扫描 → 可选的覆盖率上报。

模板会根据仓库内存在的文件 **自动分派语言流水线**，不需要为每种技术栈维护独立配置。

---

## 支持的技术栈

| 技术栈 | 检测文件 | 执行内容 |
|---|---|---|
| Node.js / TypeScript / Next.js / React | `package.json` | `npm ci` → `npm run lint` → `npm run build` |
| Java (Maven) | `pom.xml` | `mvn -B -ntp compile`（自动识别 Maven Wrapper） |
| Java (Gradle) | `build.gradle` / `build.gradle.kts` | `gradle assemble`（自动识别 Gradle Wrapper） |
| PHP / Laravel | `composer.json` 或任意 `*.php` | `composer install` → `php -l` 全量语法检查 |
| Python / Django / FastAPI | `requirements.txt` / `Pipfile` / `pyproject.toml` / `setup.py` | Flake8 致命错误检查 (E9/F63/F7/F82) |
| Go | `go.mod` | `go vet` → `go build` |
| .NET / C# / F# | `*.csproj` / `*.sln` / `*.fsproj` | `dotnet restore` → `dotnet build -c Release` |
| Docker | `Dockerfile` / `Dockerfile.*` | Hadolint 最佳实践与安全检查 |

---

## 流水线结构

| Layer | 内容 | 说明 |
|---|---|---|
| **Layer 0** | 仓库卫生检查 | 编译产物、合并冲突标记、敏感文件（`.env` / 私钥）、大文件（>5MB）检测 |
| **Layer 1** | Lint & Build | 按仓库内文件自动分派，多语言 **并行** 执行 |
| **Layer 2** | Trivy 漏洞 + 密钥扫描 | 文件系统级依赖漏洞扫描 + 硬编码密钥扫描 |
| **Layer 3** *(可选)* | 覆盖率上报 | 设置 `CODECOV_TOKEN` secret 后自动启用 |

**执行策略**：每一层的所有检查项全量执行后再汇总，不会因某项失败而跳过同层其他检查。
开发者一次 CI 运行就能看到全部问题，避免「修复 → 推送 → 再发现」的循环。

---

## 新项目接入（2 步）

### 第 1 步：复制 starter 文件

将 [`starter/.github/workflows/ci.yml`](./starter/.github/workflows/ci.yml) 原样复制到新仓库相同路径下：

```text
你的新项目/
└── .github/
    └── workflows/
        └── ci.yml   ← 复制这一个文件即可
```

### 第 2 步：按需自定义语言版本（可选）

打开 `ci.yml`，取消对应注释：

```yaml
jobs:
  ci:
    uses: 2029193370/ci-templates/.github/workflows/reusable-ci.yml@main
    with:
      node-version: '22'       # Node.js / TypeScript / Next.js
      java-version: '21'       # Java LTS
      php-version: '8.3'       # PHP / Laravel
      python-version: '3.12'   # Python / Django / FastAPI
      go-version: '1.23'       # Go
      dotnet-version: '8.0'    # .NET / C#
      trivy-severity: 'CRITICAL,HIGH'
      trivy-exit-code: '1'     # 1 = 漏洞则失败 ; 0 = 仅报告
    secrets:
      CODECOV_TOKEN: ${{ secrets.CODECOV_TOKEN }}   # 可选
```

未传入的参数自动使用默认值；仓库中不存在的语言文件对应的 job 会自动跳过。

---

## 升级维护

所有接入仓库共享此模板。本仓库一次修改 `reusable-ci.yml` 即对全部接入仓库生效，无需逐个改。

生产建议将 `@main` 替换为具体 tag（如 `@v1.0.0`）以获得可复现性，再按需手动升级。

---

## 企业级安全与性能特性

- **最小权限原则** — Workflow 默认只声明 `contents: read`
- **并发控制** — 同分支重复推送自动取消旧流水线，节省 Actions 分钟数
- **全量执行不中断** — 所有检查项并行跑完再汇总，避免反复修复-推送
- **超时保护** — Layer 0: 5min · Layer 1: 20min · Layer 2: 15min，防止挂起拖延
- **依赖缓存** — npm / Maven / Gradle / Composer / pip / Go modules 均启用
- **供应链防御**
  - Trivy 固定在无漏洞版本 `0.35.0`（规避 2026-03 供应链攻击）
  - CodeQL Action 使用最新 `v4`（v2 已退休，v3 将于 2026-12 弃用）
  - artifact Actions 使用 `v4`（v3 已于 2025-01-30 下线）
- **敏感信息检测** — 拦截 `.env` / `*.pem` / `*.key` 等文件进入仓库
- **大文件拦截** — 提示 >5MB 文件改用 Git LFS
- **Dependabot 全语言** — Actions / npm / composer / pip / maven / gradle / gomod / nuget / docker
- **定时 CodeQL 扫描** — 每周一 03:00 UTC 全量安全分析
- **跨平台一致性** — `.gitattributes` 强制 YAML/Shell 使用 LF，杜绝 Windows/Linux 换行符差异造成的 CI 失败

---

## 本仓库内工作流

| 文件 | 作用 |
|---|---|
| `.github/workflows/reusable-ci.yml` | 对外暴露的可复用工作流（业务仓库调用此文件） |
| `.github/workflows/ci-lint.yml` | 本仓库自身的 Yamllint 检查，保证模板语法正确 |
| `.github/workflows/codeql.yml` | 本仓库自身的 CodeQL 静态安全分析 |
| `.github/dependabot.yml` | 本仓库的自动化依赖更新 |
| `starter/.github/workflows/ci.yml` | 业务仓库需要复制的启动模板 |

---

## 徽章

接入后在项目 README 顶部添加：

```markdown
![CI](https://github.com/<你的用户名>/<你的仓库>/actions/workflows/ci.yml/badge.svg)
```

---

## License

[MIT](./LICENSE)
