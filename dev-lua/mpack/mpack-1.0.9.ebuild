# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua toolchain-funcs

DESCRIPTION="Lua bindings for libmpack"
HOMEPAGE="https://github.com/libmpack/libmpack"
SRC_URI="https://github.com/libmpack/libmpack-lua/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
#EGIT_REPO_URI="https://github.com/tarruda/libmpack/"
S="${WORKDIR}/libmpack-lua-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~x86"
IUSE="test"
RESTRICT="!test? ( test )"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="
	${LUA_DEPS}
	dev-libs/libmpack
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	test? ( dev-lua/busted[${LUA_USEDEP}] )
"

src_prepare() {
	default
#	sed \
#		-e 's@$(MPACK_SRC)@@' \
#		Makefile
	lua_copy_sources
}

each_lua_compile() {
	pushd "${BUILD_DIR}"
	local myemakeargs=(
		USE_SYSTEM_LUA=yes
		USE_SYSTEM_MPACK=yes
		MPACK_LUA_VERSION="$(lua_get_version)"
		LUA_IMPL=${ELUA}
		PKG_CONFIG=$(tc-getPKG_CONFIG)
	)
	emake ${myemakeargs[@]}
}

each_lua_test() {
	"${ELUA}" "${EROOT}"/usr/bin/busted -o gtest test.lua || die
}

each_lua_install() {
	local myemakeargs=(
		USE_SYSTEM_LUA=yes
		USE_SYSTEM_MPACK=yes
		MPACK_LUA_VERSION="$(lua_get_version)"
		LUA_IMPL=${ELUA}
		PKG_CONFIG=$(tc-getPKG_CONFIG)
		DESTDIR="${D}"
	)
	pushd "${BUILD_DIR}"
	emake ${myemakeargs[@]} install
	popd
}

src_test() {
	lua_foreach_impl each_lua_test
}

src_compile() {
	lua_foreach_impl each_lua_compile
}

src_install() {
	lua_foreach_impl each_lua_install
	einstalldocs
}
