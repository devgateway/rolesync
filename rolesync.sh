#!/bin/bash
CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/rolesync.conf"
source "$CONFIG"

# save artifacts to a local archive
backupArtifacts() {
	if [[ -n "$BACKUP_DIR" ]]; then
		listArtifacts | xargs --null --no-run-if-empty tar -caf "$BACKUP_DIR/rolesync.tgz"
	else
		echo "Backup dir not defined, skipping backup" >&2
	fi
}
