# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="Git repository hosting user"

IUSE="gitea gitolite gitprep"
REQUIRED_USE="^^ ( gitea gitolite gitprep )"

ACCT_USER_ID=196
ACCT_USER_HOME_OWNER=git:git
ACCT_USER_HOME_PERMS=750
ACCT_USER_SHELL=/bin/sh
ACCT_USER_GROUPS=( git )

acct-user_add_deps

pkg_setup() {
	if use gitea; then
		ACCT_USER_HOME=/var/lib/gitea
	elif use gitolite; then
		ACCT_USER_HOME=/var/lib/gitolite
	elif use gitprep; then
		ACCT_USER_HOME=/var/lib/gitprep
	else
		die "Incorrect USE flag combination"
	fi
}
