# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VCS="git"
GITHUB_A="sqmedeiros"

inherit lua

DESCRIPTION="LPeg extension that supports labeled failures"
HOMEPAGE="https://github.com/sqmedeiros/lpeglabel"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

each_lua_install() {
	dolua "${PN}".so relabel.lua
}
