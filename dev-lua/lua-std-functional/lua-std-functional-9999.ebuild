# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="Functional Programming with Lua"
HOMEPAGE="https://github.com/lua-stdlib/functional"
EGIT_REPO_URI="https://github.com/lua-stdlib/functional"

LICENSE="MIT"
SLOT="0"
IUSE="doc"

RDEPEND="
	doc? ( dev-lua/ldoc[${LUA_USEDEP}] )
	dev-lua/lua-std-normalize[${LUA_USEDEP}]
"
DEPEND="${RDEPEND}"

each_lua_compile() {
	default
}

each_lua_install() {
	insinto "$(lua_get_lmod_dir)"
	doins -r lib/std
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
