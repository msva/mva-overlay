# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="Beautifies Lua code"
HOMEPAGE="https://luarocks.org/modules/luarocks/formatter"
EGIT_REPO_URI="https://github.com/shuxiao9058/luaformatter"

LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS=""
IUSE=""

REQUIRED_USE="${LUA_REQUIRED_USE}"
DEPEND="${LUA_DEPS}"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

lua_install() {
	insinto "$(lua_get_lmod_dir)"
	doins "${PN##lua}".lua
}

src_install() {
	lua_foreach_impl lua_install
	newbin commandline.lua "${PN}"
}
