# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit cmake lua

DESCRIPTION="lightweight, native, lazy evaluating multithreading library"
HOMEPAGE="https://github.com/LuaLanes/lanes"

if [[ "${PV}" == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/LuaLanes/lanes"
else
	SRC_URI="https://github.com/LuaLanes/lanes/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~mips ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="examples"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="${LUA_DEPS}"
DEPEND="${RDEPEND}"

HTML_DOCS=(docs/.)

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

src_prepare() {
	sed -i -r \
		-e '/^INSTALL..DIRECTORY docs/d' \
		-e '/^INSTALL..DIRECTORY tests/d' \
		-e '/^INSTALL..FILES .* README /d' \
		CMakeLists.txt
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
		mv tests examples
		DOCS+=(examples)
		docompress -x "/usr/share/doc/${PF}/examples"
	fi
	einstalldocs
}
