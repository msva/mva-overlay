# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN##lua-}"
LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3 toolchain-funcs flag-o-matic

DESCRIPTION="A lua library to spawn programs"
HOMEPAGE="https://github.com/daurnimator/lua-spawn"
EGIT_REPO_URI="https://github.com/daurnimator/lua-spawn"

LICENSE="MIT"
SLOT="0"
IUSE="examples"
REQUIRED_USE="${LUA_REQUIRED_USE}"

DEPEND="
	${LUA_DEPS}
	dev-lua/lunix[${LUA_USEDEP}]
"
RDEPEND="
	${RDEPEND}
"

src_prepare() {
	default
	mv "${MY_PN}/posix.c" "${S}" || die
	lua_copy_sources
}

each_lua_compile() {
	pushd "${BUILD_DIR}"
	append-cflags "-I./vendor/compat-5.3/c-api/"
	append-cflags "-I$(lua_get_include_dir)"
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} -fPIC -shared posix.c -o posix.so || die
	popd
}

each_lua_install() {
	pushd "${BUILD_DIR}"
	insinto "$(lua_get_cmod_dir)/${MY_PN}"
	doins posix.so
	insinto "$(lua_get_lmod_dir)/${MY_PN}"
	doins "${MY_PN}"/*.lua
	popd
}

src_compile() {
	lua_foreach_impl each_lua_compile
}

src_install() {
	lua_foreach_impl each_lua_install
	if use examples; then
		mv spec examples
		DOCS+=(examples)
		docompress -x "/usr/share/doc/${PF}/examples"
	fi
	einstalldocs
}
