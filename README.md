# ci-templates

公司通用 CI/CD 工作流模板，支持 Node.js、PHP、Python 项目自动检测。

## 包含检查

| Layer | 内容 | 触发条件 |
|-------|------|----------|
| Layer 1 | 语法 & Lint 检查 | 检测到 `package.json` / `*.php` / `requirements.txt` 自动执行 |
| Layer 2 | Trivy 安全漏洞 & 密钥泄露扫描 | Layer 1 通过后自动执行 |

## 接入新项目（3 步）

在你的项目仓库中创建 `.github/workflows/ci.yml`：

```yaml
name: CI & Security Scan

on:
  push:
    branches: [ "main" ]
  pull_request:
    branches: [ "main" ]

jobs:
  ci:
    uses: 2029193370/ci-templates/.github/workflows/reusable-ci.yml@main
    # 所有参数均为可选，不传则使用默认值
    with:
      node-version: '22'        # 默认 22
      php-version: '8.2'        # 默认 8.2
      python-version: '3.11'    # 默认 3.11
      trivy-severity: 'CRITICAL,HIGH'  # 默认 CRITICAL,HIGH
```

## 升级维护

只需修改本仓库的 `reusable-ci.yml`，所有接入项目**自动获得更新**，无需逐个修改。

## 支持的项目类型

| 项目类型 | 检测文件 | 执行内容 |
|----------|----------|----------|
| Node.js / Next.js / React | `package.json` | `npm ci` + `npm run lint` |
| PHP / Laravel | `composer.json` / `*.php` | `composer install` + `php -l` 语法检查 |
| Python / Django | `requirements.txt` / `Pipfile` / `pyproject.toml` | Flake8 致命错误检查 |
