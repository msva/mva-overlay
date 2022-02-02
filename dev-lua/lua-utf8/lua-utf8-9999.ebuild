# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3 toolchain-funcs

DESCRIPTION="lightweight, native, lazy evaluating multithreading library"
HOMEPAGE="https://github.com/starwing/luautf8"
EGIT_REPO_URI="https://github.com/starwing/luautf8"

LICENSE="MIT"
SLOT="0"
IUSE="test"

DOCS=(README.md)

REQUIRED_USE="${LUA_REQUIRED_USE}"
RESTRICT="!test? ( test )"

RDEPEND="${LUA_DEPS}"
DEPEND="${RDEPEND}"
BDEPEND="
	${LUA_DEPS}
	>=app-i18n/unicode-data-14.0.0-r1
	virtual/pkgconfig
"

src_prepare() {
	local ucd="/usr/share/unicode"

	sed -i \
		-e "s@UCD/@${ucd}/@" \
		parseucd.lua

	default
}

lua_src_compile() {
	einfo "Performing regeneration unicode data header against app-i18n/unicode-data with ${ELUA}"
	"${ELUA}" parseucd.lua

	local compiler=(
		"$(tc-getCC)"
		"${CFLAGS}"
		"-fPIC"
		"${LDFLAGS}"
		"$(lua_get_CFLAGS)"
		"-c lutf8lib.c"
		"-o lutf8lib-${ELUA}.o"
	)
	einfo "${compiler[@]}"
	${compiler[@]} || die

	local linker=(
		"$(tc-getCC)"
		"-shared"
		"${LDFLAGS}"
		"-o lutf8lib-${ELUA}.so"
		"lutf8lib-${ELUA}.o"
	)
	einfo "${linker[@]}"
	${linker[@]} || die
}

src_compile() {
	lua_foreach_impl lua_src_compile
}

lua_src_test() {
	local mytests=(
		"test.lua"
		"test_compat.lua"
		"test_pm.lua"
	)

	for mytest in ${mytests[@]}; do
		LUA_CPATH="${S}/lutf8lib-${ELUA}.so" ${ELUA} ${mytest} || die
	done
}

src_test() {
	lua_foreach_impl lua_src_test
}

lua_src_install() {
	exeinto "$(lua_get_cmod_dir)"
	newexe "lutf8lib-${ELUA}.so" "lua-utf8.so"
}

src_install() {
	lua_foreach_impl lua_src_install

	einstalldocs
}