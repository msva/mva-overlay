# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="Lua serializer and pretty printer"
HOMEPAGE="https://github.com/pkulchenko/serpent"
EGIT_REPO_URI="https://github.com/pkulchenko/serpent"

LICENSE="MIT"
SLOT="0"
IUSE="examples"

REQUIRED_USE="${LUA_REQUIRED_USE}"

DEPEND="${LUA_DEPS}"

each_lua_install() {
	insinto "$(lua_get_lmod_dir)"
	doins src/"${PN}".lua
}

src_install() {
	lua_foreach_impl each_lua_install
	if use examples; then
		mv t examples
		DOCS+=(examples)
		docompress -x "/usr/share/doc/${PF}/examples"
	fi
	einstalldocs
}
