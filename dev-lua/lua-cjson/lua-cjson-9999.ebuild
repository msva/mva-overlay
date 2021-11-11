# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3 cmake

DESCRIPTION="Lua JSON Library, written in C"
HOMEPAGE="https://www.kyne.com.au/~mark/software/lua-cjson.php"
EGIT_REPO_URI="https://github.com/openresty/lua-cjson"

LICENSE="MIT"
SLOT="0"
IUSE="examples"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="
	${LUA_DEPS}
"
DEPEND="
	${RDEPEND}
"

each_lua_configure() {
	pushd "${BUILD_DIR}"
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
#	local n="${PN//lua-}"
#	insinto "$(lua_get_lmod_dir)"
#	doins -r lua/"${n}"
#	insinto "$(lua_get_cmod_dir)"
#	doins cjson.so
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
	if use examples; then
		mkdir examples
		mv lua/{json2lua,lua2json}.lua examples
		DOCS+=( examples )
		docompress -x "/usr/share/doc/${PF}/examples"
	fi
	einstalldocs
}
