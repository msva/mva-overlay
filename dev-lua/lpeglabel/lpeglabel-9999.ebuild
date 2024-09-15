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

lua_prepare() {
	if [[ "${ELUA}" = "luajit" ]]; then
		pushd "${BUILD_DIR}"
		sed \
			-e '/define luaL_newlib/d' \
			-e '/(LUA_VERSION_NUM/a#define LUAI_FUNC	__attribute__((visibility("hidden"))) extern' \
			-i lpltypes.h || die
		popd
	fi
}

src_prepare() {
	default
	lua_copy_sources
	lua_foreach_impl lua_prepare
}

lua_compile() {
	pushd "${BUILD_DIR}"
	local compiler=(
		"$(tc-getCC)"
		"${CFLAGS}"
		"-fPIC"
		"${LDFLAGS}"
		"$(lua_get_CFLAGS)"
		"-shared"
		"${LDFLAGS}"
		"-o ${PN}-${ELUA}.so"
		*.{c,h}
#		{lplvm,lplcap,lpltree,lplcode,lplprint}.c
	)
	einfo "${compiler[@]}"
	${compiler[@]} || die
	popd
}

lua_install() {
	pushd "${BUILD_DIR}"
	exeinto "$(lua_get_cmod_dir)"
	newexe "${PN}-${ELUA}.so" "${PN}.so"
	insinto "$(lua_get_lmod_dir)"
	doins relabel.lua
	popd
}

src_compile() {
	lua_foreach_impl lua_compile
}

src_install() {
	lua_foreach_impl lua_install
}
