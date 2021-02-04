# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VCS="git"
GITHUB_A="bungle"
GITHUB_PN="lua-${PN}"
LUA_COMPAT="luajit2"

inherit lua

DESCRIPTION="LuaJIT FFI Bindings to <pkg>media-libs/libharu</pkg>"
HOMEPAGE="https://github.com/bungle/lua-resty-haru"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	media-libs/libharu
	dev-lua/penlight
"

DOCS=(README.md)

each_lua_install() {
	dolua_jit lib/resty
}
