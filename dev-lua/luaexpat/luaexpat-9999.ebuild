# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua toolchain-funcs mercurial

DESCRIPTION="LuaExpat is a SAX XML parser based on the Expat library"
HOMEPAGE="https://matthewwild.co.uk/projects/luaexpat/ https://code.matthewwild.co.uk/lua-expat"
EHG_REPO_URI="https://code.matthewwild.co.uk/lua-expat/"

LICENSE="MIT"
SLOT="0"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="
	dev-libs/expat
	${LUA_DEPS}
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

HTML_DOCS=( "doc/us/." )

src_prepare() {
	default

	# Respect users CFLAGS
	# Remove '-ansi' to compile with newer lua versions
	sed -e 's/-O2//g' -e 's/-ansi//g' -i Makefile || die

	lua_copy_sources
}

lua_src_compile() {
	pushd "${BUILD_DIR}" || die

	local myemakeargs=(
		"CC=$(tc-getCC)"
		"LUA_INC=$(lua_get_CFLAGS)"
	)

	emake "${myemakeargs[@]}"

	popd
}

src_compile() {
	lua_foreach_impl lua_src_compile
}

lua_src_install() {
	pushd "${BUILD_DIR}" || die

	local myemakeargs=(
		"DESTDIR=${ED}"
		"LUA_CDIR=$(lua_get_cmod_dir)"
		"LUA_INC=$(lua_get_include_dir)"
		"LUA_LDIR=$(lua_get_lmod_dir)"
	)

	emake "${myemakeargs[@]}" install

	popd
}

src_install() {
	lua_foreach_impl lua_src_install

	einstalldocs
}
