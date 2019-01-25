# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit lua

DESCRIPTION="LuaDoc is a documentation tool for Lua source code"
HOMEPAGE="http://keplerproject.github.io/luadoc/"
SRC_URI="http://luaforge.net/frs/download.php/3185/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~x86"
IUSE="doc"

DEPEND=""
RDEPEND="
	dev-lua/luafilesystem
"

DOCS=(README)
HTML_DOCS=(doc/us/.)

all_lua_prepare() {
	# >=lua-5.1.3
	find . -name '*.lua' | xargs sed -e "s/gfind/gmatch/g" -i || die
	default
}

each_lua_install() {
	dolua "src/${PN}"
}

all_lua_install() {
	newbin "src/${PN}.lua.in" "${PN}"
}
