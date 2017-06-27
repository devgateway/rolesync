#!/bin/bash -e

# Rolesync is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# Rolesync is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with rolesync. If not, see <http://www.gnu.org/licenses/>.

CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/rolesync.conf"
source "$CONFIG"

if [[ -z "$ROLE_REPO" || -z "$SECRET_REPO" ]]; then
		cat >&2 <<-EOF
		Both ROLE_REPO and SECRET_REPO must be defined in $CONFIG
		EOF
		exit 1
fi

case "$1" in
	pack)
		# remove controlled files from working directory
		pushd "$SECRET_REPO" >/dev/null
		git ls-files -z \
			| xargs --null rm -f

		# copy current files from roles
		cd "$ROLE_REPO"
		git submodule --quiet foreach 'git ls-files --other | sed "s|^|$path/|"' \
			| tr '\n' '\0' \
			| rsync --verbose --files-from=- --from0 . "$SECRET_REPO"

		popd >/dev/null
		;;

	unpack)
		pushd "$ROLE_REPO" >/dev/null
		git submodule --quiet foreach 'git clean -d --force'

		cd "$SECRET_REPO"
		git archive HEAD | tar -xvC "$ROLE_REPO"
		popd >/dev/null
		;;

	*)
		cat >&2 <<-EOF
		USAGE: $(basename "$0") pack|unpack
		
		pack - gather artifacts for a new commit
		unpack - export artifacts to roles
		EOF
		exit 2
		;;
esac
