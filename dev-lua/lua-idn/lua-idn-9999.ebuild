# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="A Lua implementation of IDNA (RFC 3490)"
HOMEPAGE="https://github.com/haste/lua-idn"
EGIT_REPO_URI="https://github.com/haste/lua-idn"

LICENSE="MIT"
SLOT="0"
IUSE="test"

REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="
	${LUA_DEPS}
"

DEPEND="
	${RDEPEND}
"

each_lua_test() {
	${ELUA} tests.lua
}

each_lua_install() {
	insinto "$(lua_get_lmod_dir)"
	doins idn.lua
}

src_test() {
	lua_foreach_impl each_lua_test
}

src_install() {
	lua_foreach_impl each_lua_install
	einstalldocs
}
