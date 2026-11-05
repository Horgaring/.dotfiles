#!/usr/bin/env bash
# Забрать текущие конфиги из системы обратно в репозиторий (обратно install.sh)
set -euo pipefail
cd "$(dirname "$0")"
source ./mappings.sh

for pair in "${MAPPINGS[@]}"; do
	src="${pair%%|*}"
	dest="${pair#*|}"
	[ -e "$dest" ] || { echo "skip: $dest нет"; continue; }
	mkdir -p "$(dirname "$src")"
	if [ -d "$dest" ]; then
		rsync -a --delete "${COLLECT_EXCLUDE[@]}" "$dest/" "$src/"
	else
		cp -p "$dest" "$src"
	fi
done
git status -s
