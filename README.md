# SCNet HPC for Codex

[简体中文](./README_CN.md)

Current release: **0.6.3**

A skills-only Codex Plugin that distributes the source [`scnet-hpc`](https://github.com/lql341/scnet-hpc) Agent Skill for operating Supercomputing Network (SCNet) through SSH and OpenAPI.

This repository is the Codex distribution wrapper. Skill instructions, cluster profiles, references, and runtime scripts are maintained in the canonical repository and synchronized into `plugins/scnet-hpc/skills/scnet-hpc/`.

## What's new in 0.6.2

- Completed jobs now resolve through the filtered history-list endpoint instead of timing out.
- Historical `workdir` and timing aliases are normalized for follow-up log workflows.
- OpenAPI operations tolerate read-only cache directories by continuing without persistent cache.

## 0.6.1 highlights

- Synchronized resilient active/history job lookup and complete normalized job states.
- Added compact job-listing guidance and the safe OpenAPI upload contract.
- OpenAPI uploads target a remote directory; the local filename is preserved separately.

## 0.6.0 highlights

- Synchronized the canonical `scnet-hpc` Skill release and runtime version to `0.6.0`.
- Includes the current SSH/OpenAPI job, file, Notebook, profile, and Hygon DCU/DTK guidance.
- Keeps the Plugin metadata, packaged Skill `VERSION`, and release README aligned.

## Requirements

- Codex with Plugin Marketplace support
- Linux or macOS for native shell execution
- Windows through WSL2; native Windows execution is not supported by the bundled Bash scripts
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

Updates to canonical Skill content are synchronized through an automated pull request. The target repository validates synchronization, shell and Python syntax, Plugin metadata, and repository hygiene before merge.

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
