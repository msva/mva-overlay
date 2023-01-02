# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="LibYAML binding for Lua."
HOMEPAGE="https://github.com/gvvaughan/lyaml"
EGIT_REPO_URI="https://github.com/gvvaughan/lyaml"

LICENSE="MIT"
SLOT="0"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="
	${LUA_DEPS}
	dev-libs/libyaml
"
DEPEND="
	${RDEPEND}
	dev-lua/lua-stdlib[${LUA_USEDEP}]
	dev-lua/ldoc[${LUA_USEDEP}]
"

DOCS=(README.md NEWS.md)
HTML_DOCS=(html/.)

src_prepare() {
	default
	sed -r \
		-e "s/@package@/${PN}/" \
		-e "s/@version@/${PV}/" \
		-e '/^dir/s@../doc@../html@' \
		-i build-aux/config.ld.in || die

	lua_copy_sources
}

each_lua_compile() {
	pushd "${BUILD_DIR}"
	mylukeargs=(
		package="${PN}"
		version="${PV}"
		PREFIX=/usr
		LUA_INCDIR="$(lua_get_include_dir)"
		LUA="${ELUA}"
	)
	${ELUA} build-aux/luke "${mylukeargs[@]}" || die
	cp -nr html "${S}" || die
	popd
}

each_lua_install() {
	pushd "${BUILD_DIR}"
	mylukeargs=(
		INST_LIBDIR="${D}/$(lua_get_cmod_dir)"
		INST_LUADIR="${D}/$(lua_get_lmod_dir)"
	)
	${ELUA} build-aux/luke "${mylukeargs[@]}" install || die
	popd
}

src_compile() {
	lua_foreach_impl each_lua_compile
}

src_install() {
	lua_foreach_impl each_lua_install
	einstalldocs
}
