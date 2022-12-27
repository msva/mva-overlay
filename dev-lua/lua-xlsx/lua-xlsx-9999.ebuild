# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="a Lua module for reading .xlsx files"
HOMEPAGE="https://github.com/jjensen/lua-xlsx"
EGIT_REPO_URI="https://github.com/jjensen/lua-xlsx"

LICENSE="MIT"
SLOT="0"
IUSE="examples"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="${LUA_DEPS}"
DEPEND="${RDEPEND}"

DOCS+=(doc/us/index.md)
HTML_DOCS=(doc/us/{index,license}.html doc/us/doc.css)

each_lua_install() {
	insinto "$(lua_get_lmod_dir)"
	doins xlsx.lua
}
src_install() {
	lua_foreach_impl each_lua_install
	if use examples; then
		cp tests examples
		DOCS+=(examples)
		docompress -x "/usr/share/doc/${PF}/examples"
	fi
	einstalldocs
}
