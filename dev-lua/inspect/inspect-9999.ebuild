# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="Human-readable representation of lua-tables"
HOMEPAGE="https://github.com/kikito/inspect.lua"
EGIT_REPO_URI="https://github.com/kikito/inspect.lua"

LICENSE="MIT"
SLOT="0"

src_compile() {
	:;
}

lua_install() {
	insinto "$(lua_get_lmod_dir)"
	doins "${PN}".lua
}

src_install() {
	lua_foreach_impl lua_install
}
