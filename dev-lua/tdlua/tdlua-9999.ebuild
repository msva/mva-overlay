# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit cmake lua git-r3

DESCRIPTION="A basic interface between tdlib and lua"
HOMEPAGE="https://github.com/giuseppeM99/tdlua"
EGIT_REPO_URI="https://github.com/giuseppeM99/tdlua"

LICENSE="GPL-3"
SLOT="0"
IUSE="examples"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="
	${LUA_DEPS}
	dev-libs/openssl:0=
	media-libs/opus:0=
	net-libs/tdlib:0=
"
DEPEND="${RDEPEND}"

# TODO: unbubdle libtgvoip!

src_prepare() {
	cmake_src_prepare
	lua_copy_sources
}

each_lua_configure() {
	pushd "${BUILD_DIR}"
	mycmakeargs=(
		-DLUA_INCLUDE_DIR=$(lua_get_include_dir)
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
	insinto "$(lua_get_cmod_dir)"
	doins "${PN}".so
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
	if use examples; then
		DOCS+=(examples)
		docompress -x "/usr/share/doc/${PF}/examples"
	fi
	einstalldocs
}
