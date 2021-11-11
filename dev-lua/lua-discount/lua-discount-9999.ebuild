# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="Lua binding to app-text/discount"
HOMEPAGE="https://github.com/craigbarnes/lua-discount"
EGIT_REPO_URI="https://github.com/craigbarnes/lua-discount"

LICENSE="ISC"
SLOT="0"

RDEPEND="
	app-text/discount
"
DEPEND="${RDEPEND}"

each_lua_compile() {
	pushd "${BUILD_DIR}"
	emake discount.so
	popd
}

each_lua_install() {
	pushd "${BUILD_DIR}"
	insinto "$(lua_get_cmod_dir)"
	doins discount.so
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
