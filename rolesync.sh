#!/bin/bash
CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/rolesync.conf"
source "$CONFIG"

# save artifacts to a local archive
backupArtifacts() {
	if [[ ! -d "$BACKUP_DIR" ]]; then
		mkdir -p "$BACKUP_DIR"
	fi

	if [[ -n "$BACKUP_DIR" ]]; then
		listArtifacts | xargs --null --no-run-if-empty tar -caf "$BACKUP_DIR/rolesync.tgz"
	else
		echo "Backup dir not defined, skipping backup" >&2
	fi
}

# list files in submodules, ignored by Git
listArtifacts() {
	git submodule --quiet foreach 'git ls-files --other | sed "s|^|$path/|"' | tr \\n \\0
}

# download artifacts
pullArtifacts() {
}

# upload artifacts
pushArtifacts() {
}

(
	pushd "$ROLE_DIR"

	backupArtifacts

	popd
) >/dev/null
