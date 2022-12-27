# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( luajit )

inherit lua git-r3

DESCRIPTION="LuaJIT FFI-based libHaru (PDF) library for OpenResty."
HOMEPAGE="https://github.com/tavikukko/lua-resty-hpdf"
EGIT_REPO_URI="https://github.com/tavikukko/lua-resty-hpdf"

LICENSE="MIT"
SLOT="0"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="
	${LUA_DEPS}
	media-libs/libharu
"
DEPEND="
	${RDEPEND}
"

each_lua_install() {
	insinto "$(lua_get_lmod_dir)"
	doins -r lib/resty
}

src_prepare() {
	default
	sed -r \
		-e "/ffi.load/s@(\")/usr.*dylib(\")@libharu_path or \1/usr/$(get_libdir)/libhpdf.so\2@" \
		-i lib/resty/hpdf.lua
}

src_install() {
	lua_foreach_impl each_lua_install
	einstalldocs
}
