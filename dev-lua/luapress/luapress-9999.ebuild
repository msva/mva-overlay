# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
GITHUB_A="Fizzadar"
GITHUB_PN="${PN^}"

inherit lua

DESCRIPTION="Static sites generator (from markdown files)"
HOMEPAGE="http://luapress.org"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="examples"

DOCS=(README.md)
EXAMPLES=(tests/.)

RDEPEND="
	dev-lua/luafilesystem
	dev-lua/lustache
	dev-lua/ansicolors
"

all_lua_prepare() {
	mv "${PN}/${PN}.lua" "${PN}/init.lua"

	sed -r \
		-e '/local base/s@(")("\))$@\1/share/'"${P}"'\2@' \
		-i "${PN}/init.lua"

	lua_default
}

each_lua_install() {
	dolua "${PN}"
}

all_lua_install() {
	insinto "/usr/share/${P}"
	doins -r template plugins
	dobin "bin/${PN}"
}
