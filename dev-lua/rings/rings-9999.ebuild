# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="Lua Rings Library"
HOMEPAGE="https://github.com/keplerproject/rings"
EGIT_REPO_URI="https://github.com/keplerproject/rings"

LICENSE="MIT"
SLOT="0"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="${LUA_DEPS}"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	lua_copy_sources
}

each_lua_configure() {
	pushd "${BUILD_DIR}"
	# custom build system
	./configure "${ELUA}"
	popd
}

each_lua_compile() {
	pushd "${BUILD_DIR}"
	myemakeargs=(
		PREFIX=/usr
		LIBNAME="${P}".so
		LUA_LIBDIR="$(lua_get_cmod_dir)"
		LUA_DIR="$(lua_get_lmod_dir)"
	)
	emake ${myemakeargs[@]}
	popd
}

each_lua_install() {
	pushd "${BUILD_DIR}"
	myemakeargs=(
		PREFIX=/usr
		LIBNAME="${P}".so
		LUA_LIBDIR="$(lua_get_cmod_dir)"
		LUA_DIR="$(lua_get_lmod_dir)"
	)
	emake install DESTDIR="${D}" ${myemakeargs[@]}
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
