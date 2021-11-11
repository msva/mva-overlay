# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit cmake lua git-r3

DESCRIPTION="A minimal set of XML processing funcs & simple XML<->Tables mapping"
HOMEPAGE="https://github.com/msva/luaxml"
EGIT_REPO_URI="https://github.com/msva/luaxml"

LICENSE="MIT"
SLOT="0"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="
	${LUA_DEPS}
"
DEPEND="
	${RDEPEND}
"

src_prepare() {
	cmake_src_prepare
	lua_copy_sources
}

each_lua_configure() {
	pushd "${BUILD_DIR}"
	mycmakeargs=(
		-DINSTALL_CMOD="$(lua_get_cmod_dir)"
		-DINSTALL_LMOD="$(lua_get_lmod_dir)"
	)
	cmake_src_configure
	popd
}

each_lua_compile() {
	pushd "${BUILD_DIR}"
	cmake_src_compile
	popd
}

each_lua_install() {
	pushd "${BUILD_DIR}"
	cmake_src_install
	popd
}

src_configure() {
	lua_foreach_impl each_lua_configure
}

src_compile() {
	lua_foreach_impl each_lua_compile
}

src_install() {
	lua_foreach_impl each_lua_install
	einstalldocs
}
