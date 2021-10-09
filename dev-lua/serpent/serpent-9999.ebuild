# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VCS="git"
GITHUB_A="pkulchenko"

inherit lua-broken

DESCRIPTION="Lua serializer and pretty printer"
HOMEPAGE="https://github.com/pkulchenko/serpent"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="examples"

DOCS=(README.md)
EXAMPLES=(t/)

each_lua_install() {
	dolua src/"${PN}".lua
}
