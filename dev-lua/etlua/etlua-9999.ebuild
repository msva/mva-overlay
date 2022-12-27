# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="Embedded Lua templates"
HOMEPAGE="https://github.com/leafo/etlua"
EGIT_REPO_URI="https://github.com/leafo/etlua"

LICENSE="MIT"
SLOT="0"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="${LUA_DEPS}"
DEPEND="${RDEPEND}"

src_compile() { :; }

each_lua_install() {
	insinto "$(lua_get_lmod_dir)"
	doins "${PN}".{lua,moon}
}

src_install() {
	lua_foreach_impl each_lua_install
	einstalldocs
}
