# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGIT_COMMIT="5b18e475f38fcf28429b1cc4b17baee3b9793a62"
LUA_COMPAT=( lua5-{1..4} luajit )
MY_P="${PN}-${EGIT_COMMIT}"

inherit lua toolchain-funcs git-r3

DESCRIPTION="Networking support library for the Lua language"
HOMEPAGE="
	http://www.tecgraf.puc-rio.br/~diego/professional/luasocket/
	https://github.com/diegonehab/luasocket
"
EGIT_REPO_URI="https://github.com/diegonehab/luasocket"

LICENSE="MIT"
SLOT="0"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RESTRICT="test"
RDEPEND="${LUA_DEPS}"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

HTML_DOCS="doc/."

src_prepare() {
	default
	lua_copy_sources
}

lua_src_compile() {
	pushd "${BUILD_DIR}" || die

	local myemakeargs=(
		"CC=$(tc-getCC)"
		"LD=$(tc-getCC)"
		"LUAINC_linux=$(lua_get_include_dir)"
		"LUAV=${ELUA}"
		"MIME_V=1.0.3-${ELUA}"
		"MYCFLAGS=${CFLAGS}"
		"MYLDFLAGS=${LDFLAGS}"
		"SOCKET_V=${PV}-${ELUA}"
	)

	emake "${myemakeargs[@]}" all

	popd
}

src_compile() {
	lua_foreach_impl lua_src_compile
}

lua_src_install() {
	pushd "${BUILD_DIR}" || die

	local myemakeargs=(
		"CDIR=$(lua_get_cmod_dir)"
		"DESTDIR=${ED}"
		"LDIR=$(lua_get_lmod_dir)"
		"LUAPREFIX_linux="
		"MIME_V=1.0.3-${ELUA}"
		"SOCKET_V=${PV}-${ELUA}"
	)

	emake "${myemakeargs[@]}" install
	emake "${myemakeargs[@]}" install-unix

	insinto "$(lua_get_include_dir)"/luasocket
	doins src/*.h

	popd
}

src_install() {
	lua_foreach_impl lua_src_install

	einstalldocs
}
