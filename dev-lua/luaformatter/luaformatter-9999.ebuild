# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
GITHUB_A="shuxiao9058"

inherit lua

DESCRIPTION="Beautifies Lua code"
HOMEPAGE="https://luarocks.org/modules/luarocks/formatter"

LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS=""
IUSE=""

each_lua_install() {
	dolua "${PN##lua}".lua
}
all_lua_install() {
	newbin commandline.lua "${PN}"
}
