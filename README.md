# SCNet HPC for Codex

A skills-only Codex Plugin that distributes the canonical [`scnet-hpc`](https://github.com/lql341/scnet-hpc) Agent Skill.

This repository is only the Codex distribution wrapper. Skill instructions, cluster profiles, references, and runtime scripts are maintained in the canonical repository and synchronized into `plugins/scnet-hpc/skills/scnet-hpc/`.

## Install

```sh
codex plugin marketplace add lql341/codex-scnet-hpc
codex plugin add scnet-hpc@scnet-hpc
```

Then start a new Codex session and invoke the skill explicitly with `$scnet-hpc`, or ask Codex to work with SCNet, Slurm, or Hygon DCU workflows.

## Scope

- Profile-aware SCNet SSH and Slurm workflows
- CPU/DCU job generation and diagnosis
- Cluster profile discovery and refresh
- Compute-node capability probes
- Hygon DCU/DTK compatibility guidance

Linux and macOS are supported natively. On Windows, use WSL2.

## Synchronize the canonical skill

```sh
./sync.sh --src ../scnet-hpc
```

The wrapper intentionally excludes the canonical repository installer, tests, CI configuration, and local probe cache.

## License

[MIT](LICENSE)
