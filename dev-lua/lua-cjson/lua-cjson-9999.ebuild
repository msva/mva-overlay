# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3 toolchain-funcs
#cmake
# CMake finds random lua version, not the TARGET one (and also not compatible with luajit)

DESCRIPTION="Lua JSON Library, written in C"
HOMEPAGE="https://www.kyne.com.au/~mark/software/lua-cjson.php"
EGIT_REPO_URI="https://github.com/openresty/lua-cjson"

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
	local myemakeargs=(
		"CC=$(tc-getCC)"
		"CFLAGS=${CFLAGS}"
		"LDFLAGS=${LDFLAGS}"
		"LUA_INCLUDE_DIR=$(lua_get_include_dir)"
	)

	emake "${myemakeargs[@]}"
	popd
}

each_lua_install() {
	pushd "${BUILD_DIR}"
	local myemakeargs=(
		"DESTDIR=${D}"
		"LUA_CMODULE_DIR=$(lua_get_cmod_dir)"
		"LUA_MODULE_DIR=$(lua_get_lmod_dir)"
		"PREFIX=${EPREFIX}/usr"
	)

	emake "${myemakeargs[@]}" install install-extra
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
