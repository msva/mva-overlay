# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="Debug Hints Library"
HOMEPAGE="https://github.com/lua-stdlib/_debug"
EGIT_REPO_URI="https://github.com/lua-stdlib/_debug"

LICENSE="MIT"
SLOT="0"
IUSE="doc"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="${LUA_DEPS}"
DEPEND="
	${RDEPEND}
	doc? ( dev-lua/ldoc[${LUA_USEDEP}] )
"

src_prepare() {
	default
}

each_lua_compile() {
	if use doc; then
		emake doc
	fi
	default
}

src_compile() {
	lua_foreach_impl each_lua_compile
}

each_lua_install() {
	insinto "$(lua_get_lmod_dir)"
	doins -r lib/std
}

src_install() {
	lua_foreach_impl each_lua_install
	if use doc; then
		HTML_DOCS=(doc/.)
	fi
	einstalldocs
}
