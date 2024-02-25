# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3 toolchain-funcs

DESCRIPTION="LPeg extension that supports labeled failures"
HOMEPAGE="https://github.com/sqmedeiros/lpeglabel"
EGIT_REPO_URI="https://github.com/sqmedeiros/lpeglabel"

LICENSE="MIT"
SLOT="0"

src_prepare() {
	use lua_targets_luajit && sed -i \
		-e '/define luaL_newlib/d' \
		-e '/(LUA_VERSION_NUM/a#define LUAI_FUNC	__attribute__((visibility("hidden"))) extern' \
		lpltypes.h || die
	default
}

lua_compile() {
	local compiler=(
		"$(tc-getCC)"
		"${CFLAGS}"
		"-fPIC"
		"${LDFLAGS}"
		"$(lua_get_CFLAGS)"
		"-shared"
		"${LDFLAGS}"
		"-o ${PN}-${ELUA}.so"
		{lplvm,lplcap,lpltree,lplcode,lplprint}.c
	)
	einfo "${compiler[@]}"
	${compiler[@]} || die
}

lua_install() {
	exeinto "$(lua_get_cmod_dir)"
	newexe "${PN}-${ELUA}.so" "${PN}.so"
	insinto "$(lua_get_lmod_dir)"
	doins relabel.lua
}

src_compile() {
	lua_foreach_impl lua_compile
}

src_install() {
	lua_foreach_impl lua_install
}
