# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for net-im/sydent"
ACCT_USER_ID=-1
ACCT_USER_HOME="/var/lib/sydent"
ACCT_USER_GROUPS=( sydent )

acct-user_add_deps
