# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

inherit acct-user

ACCT_USER_ID="966"
ACCT_USER_GROUPS=( "uhub" )
ACCT_USER_HOME="/var/lib/run/uhub"

acct-user_add_deps
