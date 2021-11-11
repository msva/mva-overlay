# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-1,jit} )

inherit lua git-r3 toolchain-funcs

DESCRIPTION="A Lua5.2+ bit manipulation library"
HOMEPAGE="https://github.com/keplerproject/lua-compat-5.2"
EGIT_REPO_URI="https://github.com/keplerproject/lua-compat-5.2"

LICENSE="MIT"
SLOT="0"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="
	${LUA_DEPS}
"
DEPEND="
	${RDEPEND}
"

each_lua_compile() {
	pushd "${BUILD_DIR}"
	local MY_PN="lbitlib"
	$(tc-getCC) ${CFLAGS} -Ic-api -fPIC -shared ${MY_PN}.c ${LDFLAGS} -o ${PN}.so || die
	popd
}

each_lua_install() {
	pushd "${BUILD_DIR}"
	insinto "$(lua_get_cmod_dir)"
	doins "${PN}.so"
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
	einstalldocs
}
