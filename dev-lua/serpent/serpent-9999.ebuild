# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
GITHUB_A="pkulchenko"

inherit lua

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
