# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

LUA_COMPAT="luajit2"
VCS="git"
GITHUB_A="jdesgats"
GITHUB_PN="ILuaJIT"

inherit lua

DESCRIPTION="Readline powered shell for LuaJIT"
HOMEPAGE="https://github.com/jdesgats/ILuaJIT"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc +completion"

RDEPEND="
	doc? ( dev-lua/luadoc )
	dev-lua/penlight
	sys-libs/readline:0
	completion? ( dev-lua/luafilesystem )
"
DEPEND="${RDEPEND}"

DOCS=(README.md)
HTML_DOCS=(html/.)

all_lua_prepare() {
	use doc && luadoc . -d html
	lua_default
}

each_lua_install() {
	dolua_jit *.lua
}

all_lua_install() {
	dobin "${FILESDIR}/${PN}"
}
