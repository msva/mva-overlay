# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit cmake lua git-r3

DESCRIPTION="MongoDB Driver for Lua"
HOMEPAGE="https://github.com/neoxic/lua-mongo"
EGIT_REPO_URI="https://github.com/neoxic/lua-mongo"

LICENSE="MIT"
SLOT="0"
REQUIRED_USE="${LUA_REQUIRED_USE}"
DEPEND="
	${LUA_DEPS}
	>=dev-libs/mongo-c-driver-1.16
"
RDEPEND="${DEPEND}"

src_prepare() {
	cmake_src_prepare
	lua_copy_sources
}

each_lua_configure() {
	pushd "${BUILD_DIR}"
	local mycmakeargs=(
		-DUSE_LUA_VERSION=${ELUA//lua}
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
