#!/usr/bin/env bash
set -euo pipefail

SRC="../scnet-hpc"
while [ $# -gt 0 ]; do
  case "$1" in
    --src) SRC="${2:-}"; shift 2 ;;
    --src=*) SRC="${1#*=}"; shift ;;
    -h|--help) echo "Usage: $0 [--src PATH]"; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; exit 1 ;;
  esac
done

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DST="$ROOT/plugins/scnet-hpc/skills/scnet-hpc"
SRC="$(cd "$SRC" && pwd)"

[ -f "$SRC/SKILL.md" ] || { echo "Missing SKILL.md in $SRC" >&2; exit 1; }
for dir in clusters references scripts; do
  [ -d "$SRC/$dir" ] || { echo "Missing $dir/ in $SRC" >&2; exit 1; }
done

mkdir -p "$DST"
awk '!/^\| `scripts\/install\.sh` \|/' "$SRC/SKILL.md" > "$DST/SKILL.md"
rm -rf "$DST/clusters" "$DST/references" "$DST/scripts" "$DST/agents"
cp -R "$SRC/clusters" "$DST/clusters"
rm -rf "$DST/clusters/.cache"
cp -R "$SRC/references" "$DST/references"
mkdir -p "$DST/scripts"
for file in _common.sh compute-probe.py new-job.sh probe-cluster.sh refresh-cluster.sh run-compute-probe.sh setup-ssh.sh; do
  cp "$SRC/scripts/$file" "$DST/scripts/$file"
done
chmod +x "$DST/scripts/"*.sh "$DST/scripts/compute-probe.py"
if [ -f "$SRC/agents/openai.yaml" ]; then
  mkdir -p "$DST/agents"
  cp "$SRC/agents/openai.yaml" "$DST/agents/openai.yaml"
fi

echo "Synchronized $SRC -> $DST"
