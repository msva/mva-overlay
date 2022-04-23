# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for net-im/synapse"

ACCT_USER_ID=-1
ACCT_USER_HOME="/var/lib/synapse"
ACCT_USER_GROUPS=( synapse )

acct-user_add_deps
