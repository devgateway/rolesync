#!/bin/bash -e
source "${XDG_CONFIG_HOME:-$HOME/.config}/rolesync.conf"

case "$1" in
	pack)
		# remove controlled files from working directory
		pushd "$SECRET_DIR" >/dev/null
		git ls-files -z \
			| xargs --null rm -f

		# copy current files from roles
		cd "$ROLE_DIR"
		git submodule --quiet foreach 'git ls-files --other | sed "s|^|$path/|"' \
			| tr '\n' '\0' \
			| rsync --verbose --files-from=- --from0 . "$SECRET_DIR"

		popd >/dev/null
		;;

	unpack)
		pushd "$SECRET_DIR" >/dev/null
		git archive HEAD | tar -xvC "$ROLE_DIR"
		popd >/dev/null
		;;

	*)
		cat >&2 <<-EOF
		USAGE: $0 pack|unpack
		
		pack - gather artifacts for a new commit
		unpack - export artifacts to roles
		EOF
		exit 1
		;;
esac
