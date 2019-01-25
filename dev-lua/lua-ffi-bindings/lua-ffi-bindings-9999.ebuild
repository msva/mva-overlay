# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

LUA_COMPAT="luajit2"
VCS="git"
GITHUB_A="thenumbernine"
inherit lua

DESCRIPTION="Some common headers ported over to LuaJIT FFI"
HOMEPAGE="https://github.com/thenumbernine/lua-ffi-bindings"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="
	dev-lua/lua-ffi-bindings
"

DOCS=(README)

each_lua_install() {
	_dolua_jit_insdir="ffi" \
	dolua_jit *.lua c/ vec/
}
