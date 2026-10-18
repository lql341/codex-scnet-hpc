# SCNet HPC for Codex

[简体中文](./README_CN.md)

Current release: **0.6.13**

<!-- scnet-release:start -->
## 0.6.13 highlights

- Recover malformed Windows credential entries with actionable, redacted guidance.
- Print absolute follow-up commands that work from any directory, with shell-appropriate quoting.
- Synchronize first-use preparation checklists into both distribution READMEs and clarify
  native Windows OpenAPI support, with regression coverage for both layouts.
<!-- scnet-release:end -->

A skills-only Codex Plugin that distributes the source [`scnet-hpc`](https://github.com/lql341/scnet-hpc) Agent Skill for operating Supercomputing Network (SCNet) through SSH and OpenAPI.

This repository is the Codex distribution wrapper. Skill instructions, cluster profiles, references, and runtime scripts are maintained in the canonical repository and synchronized into `plugins/scnet-hpc/skills/scnet-hpc/`.

<!-- scnet-onboarding:start -->
## What to prepare for first use

Start with **OpenAPI** for queries and standard job management. Add SSH when you need remote
compilation, environment installation, or shell commands.

| Connection | Required inputs | Where to obtain them |
| --- | --- | --- |
| OpenAPI (default) | Platform username, AK, SK | Sign in to SCNet > Personal Center / 个人中心 > Access Control / 访问控制 > generate and download the authorization file. Use its `Accesskey` and `Secretkey` columns. |
| SSH (as needed) | Target cluster, cluster/Linux username, private-key file path | Select the region in the console > Command Line E-Shell / 命令行 E-Shell > SSH Connection / SSH 连接 at top left. Download the key and check host/port; verify the username with `whoami` in that region's web E-Shell. |

Your account needs access to the target region. Prepare credentials for the chosen connection;
explanations and offline preparation require none. **Enter AK/SK only in your own terminal's hidden
prompts. For SSH, supply a local file path. Keep keys and private-key contents out of chat.**

Ask your agent to help configure scnet-hpc for the first time. The Skill explains the inputs and
their sources before providing a local command for your OS and actual installation directory.
See the [first-use checklist](plugins/scnet-hpc/skills/scnet-hpc/references/first-use.md).
<!-- scnet-onboarding:end -->

## Requirements

- Codex with Plugin Marketplace support
- Linux or macOS for native shell execution
- Native Windows supports Python OpenAPI and Windows Credential Manager; use WSL2 for automatic SSH installation and Bash workflows
- An SCNet account and cluster credentials for remote operations

## Install

```sh
codex plugin marketplace add lql341/codex-scnet-hpc
codex plugin add scnet-hpc@scnet-hpc
```

Start a new Codex session after installation. Invoke the skill explicitly with `$scnet-hpc`, or ask Codex to work with SCNet, Slurm, or Hygon DCU workflows.

## Included capabilities

- Repeatable SCNet configuration and SSH key rotation
- OpenAPI region, scheduler, queue, and file discovery
- Profile-aware SCNet SSH and Slurm workflows
- OpenAPI job and file operations with dry-run support
- Notebook region, resource, image, instance, and lifecycle operations
- CPU-only and Hygon DCU-aware job generation and diagnosis
- Cluster profile discovery and refresh
- Compute-node capability probes
- Hygon DCU/DTK development and compatibility guidance
- Explicit authorization boundaries for SSH changes, remote probes, and scheduler resource consumption

## Repository structure

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

## Source synchronization

The packaged Skill is generated from the canonical repository:

```sh
./sync.sh --src ../scnet-hpc
```

The wrapper intentionally excludes the canonical installer, tests, repository CI configuration, and local probe cache. Do not maintain the generated Skill copy independently.

Updates to canonical Skill content are synchronized through an automated pull request. After the target validation passes, the workflow merges the PR and publishes the matching Git tag and GitHub Release automatically.

The Plugin version follows the source Skill `VERSION`. Report issues with both the Plugin version
and `python3 plugins/scnet-hpc/skills/scnet-hpc/scripts/scnet.py --version`.

## Validation

```sh
python3 /path/to/plugin-creator/scripts/validate_plugin.py plugins/scnet-hpc
bash -n sync.sh plugins/scnet-hpc/skills/scnet-hpc/scripts/*.sh
python3 -m py_compile \
  plugins/scnet-hpc/skills/scnet-hpc/scripts/*.py \
  plugins/scnet-hpc/skills/scnet-hpc/scripts/scnet_backends/*.py \
  plugins/scnet-hpc/skills/scnet-hpc/scripts/scnet_sdk/*.py
```

## Security boundaries

- The repository must not contain private keys, tokens, usernames, private endpoints, or local probe caches.
- SSH configuration, remote probes, and Slurm submission require an explicit target and user authorization.
- Notebook create/start/stop/release operations require explicit confirmation; release is irreversible.
- Passwords and credential-bearing Notebook URLs are redacted by default.
- A compute-node probe consumes scheduler resources and is never implied by read-only inspection.
- Accelerator compatibility claims require evidence from the target compute node.

## License

This distribution wrapper and the included `scnet-hpc` Skill are released under the [MIT License](LICENSE). Subject to the license terms, the software may be used, copied, modified, merged, published, sublicensed, and distributed, including for commercial purposes.

Redistributions must retain the copyright notice and MIT license notice. The software is provided “as is,” without warranties of any kind. Users are responsible for evaluating the suitability and operational risks of the Plugin, Skill instructions, cluster profiles, scripts, and generated outputs in their own environment.
