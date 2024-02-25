# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN##lua-}"
LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3 toolchain-funcs flag-o-matic

DESCRIPTION="Lua bindings for dev-libs/xxhash (XXH32 only for now)"
HOMEPAGE="https://github.com/mah0x211/lua-xxhash"
EGIT_REPO_URI="https://github.com/mah0x211/lua-xxhash"

LICENSE="MIT BSD-2"
SLOT="0"

RDEPEND="
	${LUA_DEPS}
	dev-libs/xxhash
"
DEPEND="${RDEPEND}"

each_lua_compile() {
	pushd "${BUILD_DIR}"
	append-cflags "-I./src"
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} -fPIC -shared "src/${MY_PN}.c" "src/${MY_PN}_bind.c" -lxxhash -o "${MY_PN}".so || die
	popd
}

each_lua_install() {
	pushd "${BUILD_DIR}"
	insinto "$(lua_get_cmod_dir)"
	doins "${MY_PN}".so
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
