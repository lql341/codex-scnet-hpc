# SCNet HPC for Codex

[English](./README.md) | 简体中文

当前版本：**0.5.0**

这是一个仅包含 Skill 的 Codex Plugin，用于分发源仓库 [`scnet-hpc`](https://github.com/lql341/scnet-hpc) Agent Skill，帮助 Codex 通过 SSH 和 OpenAPI 操作超算互联网（SCNet）。

本仓库只负责 Codex 分发包装。Skill 指令、集群 profile、参考资料和运行脚本均在 canonical 仓库维护，并同步到 `plugins/scnet-hpc/skills/scnet-hpc/`。

## 环境要求

- 支持 Plugin Marketplace 的 Codex
- Linux 或 macOS 可原生运行脚本
- Windows 通过 WSL2 使用；内置 Bash 脚本不支持 Windows 原生环境
- 远程操作需要 SCNet 账号和对应集群凭据

## 安装

```sh
codex plugin marketplace add lql341/codex-scnet-hpc
codex plugin add scnet-hpc@scnet-hpc
```

安装后请启动新的 Codex 会话。可以显式调用 `$scnet-hpc`，也可以直接要求 Codex 处理 SCNet、Slurm 或海光 DCU 工作流。

## 主要能力

- 可重复运行的配置维护和 SSH 密钥轮换
- OpenAPI 区域、调度器、队列和文件发现
- 基于 profile 的 SCNet SSH 和 Slurm 工作流
- 带 dry-run 的 OpenAPI 作业与文件操作
- Notebook 区域、资源、镜像、实例和安全生命周期操作
- CPU-only 与海光 DCU 作业生成和诊断
- 集群 profile 探测与刷新
- 计算节点能力探针
- 海光 DCU/DTK 开发与兼容性指导
- 对 SSH 修改、远程探测和调度资源消耗设置明确授权边界

## 仓库结构

```text
.
├── .agents/plugins/marketplace.json
├── plugins/scnet-hpc/
│   ├── .codex-plugin/plugin.json
│   └── skills/scnet-hpc/
│       ├── SKILL.md
│       ├── agents/openai.yaml
│       ├── clusters/
│       ├── references/
│       └── scripts/
│           ├── scnet_backends/
│           └── scnet_sdk/
├── sync.sh
└── .github/workflows/
```

## 内容同步

内置 Skill 从 canonical 仓库生成：

```sh
./sync.sh --src ../scnet-hpc
```

包装仓库会排除 canonical 仓库中的安装脚本、测试、仓库 CI 配置和本地探针缓存。不要独立维护生成后的 Skill 副本。

canonical Skill 内容更新后，会通过自动 workflow 创建同步 PR。合并前由目标仓库检查同步状态、Shell/Python 语法、Plugin 元数据和仓库卫生。

Plugin 版本与源 Skill 的 `VERSION` 保持一致。反馈问题时请同时提供 Plugin 版本和
`python3 plugins/scnet-hpc/skills/scnet-hpc/scripts/scnet.py --version` 输出。

## 本地校验

```sh
python3 /path/to/plugin-creator/scripts/validate_plugin.py plugins/scnet-hpc
bash -n sync.sh plugins/scnet-hpc/skills/scnet-hpc/scripts/*.sh
python3 -m py_compile \
  plugins/scnet-hpc/skills/scnet-hpc/scripts/*.py \
  plugins/scnet-hpc/skills/scnet-hpc/scripts/scnet_backends/*.py \
  plugins/scnet-hpc/skills/scnet-hpc/scripts/scnet_sdk/*.py
```

## 安全边界

- 仓库不得包含私钥、token、用户名、私有端点或本地探针缓存。
- 修改 SSH 配置、运行远程探针或提交 Slurm 作业前，必须明确目标和用户授权。
- Notebook 创建、启动、停止和释放必须明确确认；释放不可恢复。
- Notebook 密码和带凭据的 URL 默认脱敏。
- 计算节点探针会消耗调度资源，不能由只读检查隐含授权。
- 加速器兼容性结论必须来自目标计算节点证据。

## 许可证

本分发包装和内置 `scnet-hpc` Skill 均采用 [MIT License](LICENSE)。在遵守许可证条款的前提下，可以使用、复制、修改、合并、发布、再许可和分发本项目，包括商业用途。

再发布时必须保留版权声明和 MIT 许可声明。本项目按“现状”提供，不附带任何形式的保证。使用者应自行评估 Plugin、Skill 指令、集群 profile、脚本和生成结果在其环境中的适用性及运行风险。
