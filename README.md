# ci-templates

公司通用 CI/CD 工作流模板，支持 Node.js、PHP、Python 项目自动检测。

## 包含检查

| Layer | 内容 | 触发条件 |
|-------|------|----------|
| Layer 1 | 语法 & Lint 检查 | 检测到 `package.json` / `*.php` / `requirements.txt` 自动执行 |
| Layer 2 | Trivy 安全漏洞 & 密钥泄露扫描 | Layer 1 通过后自动执行 |

---

## 新项目接入（2 步）

### 第 1 步：复制 starter 文件

将 [`starter/.github/workflows/ci.yml`](./starter/.github/workflows/ci.yml) 复制到你的新项目，保持相同路径：

```
你的新项目/
└── .github/
    └── workflows/
        └── ci.yml   ← 复制这个文件
```

### 第 2 步：按需修改版本（可选）

```yaml
jobs:
  ci:
    uses: 2029193370/ci-templates/.github/workflows/reusable-ci.yml@main
    with:
      node-version: '22'    # Node.js 项目：修改版本号
      php-version: '8.2'    # PHP 项目：加上这行
      python-version: '3.11' # Python 项目：加上这行
```

**不需要传入的参数直接删掉即可**，工作流会自动根据项目中存在的文件判断执行哪些检查。

---

## 升级维护

只需修改本仓库的 `reusable-ci.yml`，所有接入项目**自动获得更新**，无需逐个修改。

---

## 支持的项目类型

| 项目类型 | 检测文件 | 执行内容 |
|----------|----------|----------|
| Node.js / Next.js / React | `package.json` | `npm ci` + `npm run lint` |
| PHP / Laravel | `composer.json` / `*.php` | `composer install` + `php -l` 语法检查 |
| Python / Django | `requirements.txt` / `Pipfile` / `pyproject.toml` | Flake8 致命错误检查 |
