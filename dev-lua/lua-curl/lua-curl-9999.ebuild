# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
GITHUB_A="Lua-cURL"
GITHUB_PN="Lua-cURLv3"
inherit lua

DESCRIPTION="Lua cURL Library"
HOMEPAGE="https://github.com/Lua-cURL/Lua-cURLv3"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc +examples"

RDEPEND="
	net-misc/curl
"
DEPEND="
	doc? ( dev-lua/luadoc )
	${RDEPEND}
"

EXAMPLES=( examples/. )
HTML_DOCS=( html/. )
DOCS=(README.md)

each_lua_compile() {
	lua_default LUA_IMPL="${lua_impl}"
}

all_lua_compile() {
	use doc && (
		cd doc
		ldoc . -d ../html
	)
}

each_lua_install() {
	lua_default LUA_IMPL="${lua_impl}"
}
