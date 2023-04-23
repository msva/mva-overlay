# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="Redis reply parser and request constructor library for Lua"
HOMEPAGE="https://github.com/openresty/lua-redis-parser"
EGIT_REPO_URI="https://github.com/openresty/lua-redis-parser"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="${LUA_DEPS}"
DEPEND="${RDEPEND}"

LICENSE="BSD"
SLOT="0"

each_lua_compile() {
	pushd "${BUILD_DIR}"
	LUA_INCLUDE_DIR=$(lua_get_include_dir) default
	popd
}

each_lua_install() {
	pushd "${BUILD_DIR}"
	insinto "$(lua_get_cmod_dir)/redis"
	doins "${PN//redis-}".so
	popd
}

src_configure() {
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
