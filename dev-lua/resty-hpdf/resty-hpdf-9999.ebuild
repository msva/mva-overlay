# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

LUA_COMPAT="luajit2"
VCS="git"
GITHUB_A="tavikukko"
GITHUB_PN="lua-${PN}"

inherit lua

DESCRIPTION="LuaJIT FFI-based libHaru (PDF) library for OpenResty."
HOMEPAGE="https://github.com/tavikukko/lua-resty-hpdf"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	media-libs/libharu
	dev-lang/luajit:2
"
DEPEND="
	${RDEPEND}
"

DOCS=(README.md)

all_lua_prepare() {
	sed -r \
		-e "/ffi.load/s@(\")/usr.*dylib(\")@libharu_path or \1/usr/$(get_libdir)/libhpdf.so\2@" \
		-i lib/resty/hpdf.lua

	lua_default
}

each_lua_install() {
	dolua_jit lib/resty
}
