# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( luajit )

inherit lua git-r3

DESCRIPTION="LuaJIT FFI Bindings to <pkg>media-libs/libharu</pkg>"
HOMEPAGE="https://github.com/bungle/lua-resty-haru"
EGIT_REPO_URI="https://github.com/bungle/lua-resty-haru"

LICENSE="BSD-2"
SLOT="0"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="
	${LUA_DEPS}
	media-libs/libharu
	dev-lua/penlight[${LUA_USEDEP}]
"
DEPEND="
	${RDEPEND}
"

each_lua_install() {
	insinto "$(lua_get_lmod_dir)"
	doins -r lib/resty
}

src_install() {
	lua_foreach_impl each_lua_install
	einstalldocs
}
