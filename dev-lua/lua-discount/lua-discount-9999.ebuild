# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
#IS_MULTILIB=true
GITHUB_A="craigbarnes"

inherit lua

DESCRIPTION="Lua binding to app-text/discount"
HOMEPAGE="https://github.com/asb/lua-discount"

LICENSE="ISC"
SLOT="0"
KEYWORDS=""
IUSE="doc"

RDEPEND="
	app-text/discount
"
DEPEND="${RDEPEND}"

DOCS=(README.md)

each_lua_compile() {
	lua_default discount.so
}

each_lua_install() {
	dolua discount.so
}
