# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit cmake lua git-r3

DESCRIPTION="Lua bindings to libzip"
HOMEPAGE="https://github.com/brimworks/lua-zip"
EGIT_REPO_URI="https://github.com/brimworks/lua-zip"

LICENSE="MIT"
SLOT="0"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="
	${LUA_DEPS}
	dev-libs/libzip
"

DEPEND="
	${RDEPEND}
"

each_lua_configure() {
	pushd "${BUILD_DIR}"
	mycmakeargs=(
		-DINSTALL_CMOD="$(lua_get_cmod_dir)"
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

src_prepare() {
	cmake_src_prepare
	lua_copy_sources
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
