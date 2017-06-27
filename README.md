# rolesync - store secret files for Ansible in a Git repo

Secret files (private keys, local certificates, etc) in Ansible playbooks are ignored by Git rules. However, they still must be shared between authorized users. Rolesync is a script that extracts secret files from specially organized playbooks, and stores them in a non-public Git repository. Authorized users then get the benefit of using well-known tool, versioning artifacts, conflict resolution and much more.

## Role structure

This script assumes roles in your organization are stored as submodules of a single superproject. This way, to ensure all authorized users have exactly the same set of roles, all they need is to clone/update the superproject. In Ansible, `roles_path` setting should point at the superproject, e.g.:

    roles_path    = $HOME/projects/ansible/roles

# Configuration file

The configuration file `rolesync.conf` is looked for in `XDG_CONFIG_HOME` or `.config` in your `HOME`. It's a shell script defining two variables:

* `ROLE_REPO` - path to the role superproject; and

* `SECRET_REPO` - path to the non-public repository for artifacts.

# Script usage

    rolesync.sh pack

Replace the contents of the working directory of the secret repo with the ignored files from the submodules of the superproject. Commit to the secret repo after this.

    rolesync.sh unpack

Export files from secret repository `HEAD` to the submodules of the superproject.
