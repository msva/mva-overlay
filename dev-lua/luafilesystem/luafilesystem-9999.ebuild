# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3 toolchain-funcs

DESCRIPTION="File System Library for the Lua Programming Language"
HOMEPAGE="https://keplerproject.github.io/luafilesystem/"

EGIT_REPO_URI="https://github.com/keplerproject/${PN}"

LICENSE="MIT"
SLOT="0"
IUSE="doc"

HTML_DOCS=(doc/us/.)
DOCS=(README.md)

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
		src/lfs.c
	)
	einfo "${compiler[@]}"
	${compiler[@]} || die
}

lua_install() {
	exeinto "$(lua_get_cmod_dir)"
	newexe "${PN}-${ELUA}.so" lfs.so
}

src_compile() {
	lua_foreach_impl lua_compile
}

src_install() {
	lua_foreach_impl lua_install
	einstalldocs
}

