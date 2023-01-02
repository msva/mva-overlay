# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="Check for use of undeclared variables"
HOMEPAGE="https://github.com/lua-stdlib/strict"
EGIT_REPO_URI="https://github.com/lua-stdlib/strict"

LICENSE="MIT"
SLOT="0"
IUSE="doc"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="${LUA_DEPS}"
DEPEND="
	${RDEPEND}
	doc? ( dev-lua/ldoc[${LUA_USEDEP}] )
"

each_lua_compile() {
	pushd "${BUILD_DIR}"
	default
	popd
}

each_lua_install() {
	pushd "${BUILD_DIR}"
	insinto "$(lua_get_lmod_dir)"
	doins -r lib/std
	popd
}

src_prepare() {
	default
	lua_copy_sources
}

src_compile() {
	lua_foreach_impl each_lua_compile
	if use doc; then
		emake doc
	fi
}

src_install() {
	lua_foreach_impl each_lua_install
	if use doc; then
		HTML_DOCS=(doc/.)
	fi
	einstalldocs
}
