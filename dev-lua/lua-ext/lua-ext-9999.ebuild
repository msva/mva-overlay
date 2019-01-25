# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
GITHUB_A="thenumbernine"
inherit lua

DESCRIPTION="Some useful extensions to Lua classes"
HOMEPAGE="https://github.com/thenumbernine/lua-ext"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="gcmem"

DEPEND=""
RDEPEND="
	dev-lua/luafilesystem
	gcmem? (
		dev-lua/lua-ffi-bindings
		dev-lang/luajit
	)
"

DOCS=(README.md)

each_lua_install() {
	use gcmem || rm gcmem.lua
	mv ext.lua init.lua
	_dolua_insdir="ext" \
	dolua *.lua
}
