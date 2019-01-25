# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
IS_MULTILIB=true
GITHUB_A="ittner"

inherit lua

DESCRIPTION="Lua bindings to Thomas Boutell's gd library"
HOMEPAGE="http://lua-gd.luaforge.net/"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc examples"

RDEPEND="
	media-libs/gd[png]
"
DEPEND="
	${RDEPEND}
"

DOCS=(README)
EXAMPLES=(demos/.)
HTML_DOCS=(doc/.)

each_lua_configure() {
	local lua=$(lua_get_lua)
	myeconfargs=(
		LUAPKG="${lua}"
		LUABIN="${lua}"
	)
	lua_default
}

each_lua_compile() {
	lua_default gd.so
}

each_lua_install() {
	dolua gd.so
}
