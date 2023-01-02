# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="Lua GeoIP Library"
HOMEPAGE="https://agladysh.github.io/lua-geoip"
EGIT_REPO_URI="https://github.com/agladysh/lua-geoip"

LICENSE="MIT"
SLOT="0"
IUSE="doc"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="
	${LUA_DEPS}
	dev-libs/geoip
"
DEPEND="
	${RDEPEND}
"

src_prepare() {
	default
	lua_copy_sources
}

each_lua_test() {
	pushd "${BUILD_DIR}"
	"${ELUA}" test/test.lua /usr/share/GeoIP/Geo{IP,LiteCity}.dat
	popd
}

src_test() {
	lua_foreach_impl each_lua_test
}

each_lua_compile() {
	pushd "${BUILD_DIR}"
	default
	popd
}

each_lua_install() {
	pushd "${BUILD_DIR}"
	insinto "$(lua_get_cmod_dir)"
	doins -r geoip{,.so}
	popd
}

src_compile() {
	lua_foreach_impl each_lua_compile
}

src_install() {
	lua_foreach_impl each_lua_install
	einstalldocs
}
