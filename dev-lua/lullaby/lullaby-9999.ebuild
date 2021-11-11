# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="A stream-based HTML template library for Lua."
HOMEPAGE="https://github.com/hugomg/lullaby"
EGIT_REPO_URI="https://github.com/hugomg/lullaby"

LICENSE="MIT"
SLOT="0"
IUSE="doc"
RDEPEND="
	${LUA_DEPS}
"
DEPEND="
	${RDEPEND}
"

HTML_DOCS=(htmlspec/.)

each_lua_install() {
	insinto "$(lua_get_lmod_dir)"
	doins -r lullaby.lua lullaby
}

src_install() {
	lua_foreach_impl each_lua_install
	einstalldocs
}
