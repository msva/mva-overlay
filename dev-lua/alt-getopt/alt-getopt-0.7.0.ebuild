# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit lua

DESCRIPTION="Lua bindings to getopt_long"
HOMEPAGE="http://luaforge.net/projects/alt-getopt"
MY_P="lua-${P}"
SRC_URI="mirror://luaforge/${PN}/${PN}/${P}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~x86"
IUSE=""

DOCS=(README)

S="${WORKDIR}/all/${MY_P}"
LUA_S="${MY_P}"

each_lua_compile() { :; }

each_lua_install() {
	dolua alt_getopt.lua
}

all_lua_install() {
	dobin alt_getopt
}
