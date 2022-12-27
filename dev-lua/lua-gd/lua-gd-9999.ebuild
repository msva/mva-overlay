# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="Lua bindings to Thomas Boutell's gd library"
HOMEPAGE="https://lua-gd.luaforge.net/"
EGIT_REPO_URI="https://github.com/ittner/lua-gd"

LICENSE="MIT"
SLOT="0"
IUSE="examples"

RDEPEND="
	media-libs/gd[png]
"
DEPEND="
	${RDEPEND}
"

HTML_DOCS=(doc/.)

each_lua_configure() {
	pushd "${BUILD_DIR}"
	myeconfargs=(
		LUAPKG="${ELUA}"
		LUABIN="${ELUA}"
	)
	econf "${myeconfargs[@]}"
	popd
}

each_lua_compile() {
	pushd "${BUILD_DIR}"
	emake gd.so
	popd
}

each_lua_install() {
	pushd "${BUILD_DIR}"
	insinto "$(lua_get_cmod_dir)"
	doins gd.so
	popd
}

src_prepare() {
	default
	lua_copy_sources
}

src_compile() {
	lua_foreach_impl each_lua_compile
}

src_install() {
	lua_foreach_impl each_lua_install
	if use examples; then
		mv demos examples
		EXAMPLES=(examples)
		docompress -x "/usr/share/doc/${PF}/examples"
	fi
	einstalldocs
}
