# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VCS="git"
GITHUB_A="Tieske"

inherit lua-broken

DESCRIPTION="Generates uuids in pure Lua"
HOMEPAGE="https://github.com/Tieske/uuid"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE="doc"

RDEPEND="
"
DEPEND="
	${RDEPEND}
"

DOCS=(README.md)
HTML_DOCS=(doc/.)

each_lua_install() {
	dolua "src/${PN}.lua"
}
