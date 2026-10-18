# SCNet HPC for Codex

[English](./README.md) | 简体中文

当前版本：**0.6.13**

<!-- scnet-release:start -->
## 0.6.13 更新

- Windows 凭据条目编码损坏时给出清晰、隐藏秘密的恢复指引。
- 配置结束后提供可从任意目录运行的绝对路径命令，正确处理空格和 shell 特殊字符。
- 将首次使用准备清单同步到两个分发仓库的中英文 README，明确 Windows 原生 OpenAPI
  支持，并为两种目录布局增加文档生成回归检查。
<!-- scnet-release:end -->

这是一个仅包含 Skill 的 Codex Plugin，用于分发源仓库 [`scnet-hpc`](https://github.com/lql341/scnet-hpc) Agent Skill，帮助 Codex 通过 SSH 和 OpenAPI 操作超算互联网（SCNet）。

本仓库只负责 Codex 分发包装。Skill 指令、集群 profile、参考资料和运行脚本均在 canonical 仓库维护，并同步到 `plugins/scnet-hpc/skills/scnet-hpc/`。

<!-- scnet-onboarding:start -->
## 第一次使用，需要准备什么？

建议先用 **OpenAPI** 完成查询和作业管理；需要远程编译、安装环境或执行 shell 时再配置 SSH。

| 连接方式 | 需要填写 | 从哪里获取 |
| --- | --- | --- |
| OpenAPI（默认） | 平台用户名、AK、SK | 登录 SCNet → 个人中心 → 访问控制 → 生成并下载授权码；AK/SK 分别取文件的 `Accesskey` / `Secretkey` 列 |
| SSH（按需） | 目标集群、集群/Linux 用户名、私钥文件路径 | 控制台选择目标区域 → 命令行 E-Shell → 左上角 SSH 连接 → 下载私钥并核对域名、端口；用户名可用网页 E-Shell 的 `whoami` 核对 |

账号需已开通目标区域资源。两种凭据独立，按当前任务准备即可；阅读说明、离线准备无需凭据。
**AK/SK 只在本机终端的隐藏输入框填写；SSH 填下载文件路径，不要将密钥或私钥正文发到聊天。**

向 Agent 说“帮我首次配置 scnet-hpc”即可；Skill 会先说明所需字段及获取位置，再给当前系统、
实际安装目录对应的本机命令。详见[首次使用清单](plugins/scnet-hpc/skills/scnet-hpc/references/first-use.md)。
<!-- scnet-onboarding:end -->

## 环境要求

- 支持 Plugin Marketplace 的 Codex
- Linux 或 macOS 可原生运行脚本
- Windows 原生支持 Python OpenAPI 和系统凭据管理器；SSH 自动安装及 Bash 工作流通过 WSL2 使用
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

canonical Skill 内容更新后，会通过自动 workflow 创建同步 PR。目标仓库校验同步状态、Shell/Python 语法、Plugin 元数据和仓库卫生；校验通过后自动合并，并发布对应的 Git tag 与 GitHub Release。

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
