# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3
DESCRIPTION="Lua bindings to zziplib"
HOMEPAGE="https://github.com/msva/luazip"
EGIT_REPO_URI="https://github.com/msva/luazip"

LICENSE="MIT"
SLOT="0"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="
	${LUA_DEPS}
	dev-libs/zziplib
"
DEPEND="
	${RDEPEND}
"

HTML_DOCS=(doc/us/.)

src_prepare() {
	default
	lua_copy_sources
}

each_lua_compile() {
	local myemakeargs=(
		'CFLAGS:=$(CFLAGS) -I'"$(lua_get_include_dir)"
		'LIB_OPTION=$(LDFLAGS) -shared'
		'LIBNAME=zip.so'
	)
	pushd "${BUILD_DIR}"
	emake "${myemakeargs[@]}"
	popd
}

each_lua_install() {
	pushd "${BUILD_DIR}"
	insinto "$(lua_get_cmod_dir)"
	doins src/*.so
	popd
}

src_compile() {
	lua_foreach_impl each_lua_compile
}

src_install() {
	lua_foreach_impl each_lua_install
	einstalldocs
}
