# 项目名称

这个仓库已经接入 `ci-templates` CI 工作流。

## CI

默认工作流位于 `.github/workflows/ci.yml`。它会调用本仓库中的
`.github/workflows/reusable-ci.yml`，并根据仓库中的文件自动运行对应检查。

私有仓库会默认跳过需要额外配置的 GitHub Code Scanning 和 StepSecurity 集成。
启用这些服务后，可以在 `.github/workflows/ci.yml` 中打开对应输入。

## 开始

添加你的业务代码，提交并推送到 `main` 即可。
