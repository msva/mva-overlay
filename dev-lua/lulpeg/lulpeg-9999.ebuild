# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
GITHUB_A="pygy"

inherit lua

DESCRIPTION="A pure Lua port of dev-lua/lpeg"
HOMEPAGE="https://github.com/pygy/LuLPeg"

LICENSE="WTFPL-2 MIT"
# ^ author claims that it's WTFPL-3, actually, but even wiki doesn't know about it

SLOT="0"
KEYWORDS=""
IUSE="doc lpeg_replace"

RDEPEND="lpeg_replace? ( !dev-lua/lpeg )"
DEPEND="${RDEPEND}"

DOCS=(README.md TODO.md ABOUT)

each_lua_compile() {
	pushd src &>/dev/null
		"${LUA}" ../scripts/pack.lua > ../"${PN}.lua"
	popd
}

each_lua_install() {
	dolua "${PN}".lua
	use lpeg_replace && newlua "${PN}.lua" lpeg.lua
}
