# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="a Lua module for reading delimited text files"
HOMEPAGE="https://github.com/geoffleyland/lua-csv"
EGIT_REPO_URI="https://github.com/geoffleyland/lua-csv"

LICENSE="MIT"
SLOT="0"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="${LUA_DEPS}"
DEPEND="${DEPEND}"

each_lua_install() {
	insinto "$(lua_get_lmod_dir)"
	doins lua/csv.lua
}

src_install() {
	lua_foreach_impl each_lua_install
	einstalldocs
}
