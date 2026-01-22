# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

inherit acct-user

DESCRIPTION="User for net-im/sydent"
ACCT_USER_ID=-1
ACCT_USER_HOME="/var/lib/sydent"
ACCT_USER_GROUPS=( sydent )

acct-user_add_deps
