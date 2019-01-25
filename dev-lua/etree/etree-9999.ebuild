# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
GITHUB_A="msva"
inherit lua

DESCRIPTION="Library for XML documents manipulations as simple Lua data structures"
HOMEPAGE="https://github.com/msva/etree"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc"

RDEPEND="
	dev-lua/luaexpat
"
DEPEND="
	${RDEPEND}
"

DOCS=(README doc/manual.txt)
HTML_DOCS=(doc/manual.html doc/style.css)

src_compile() { :; }

each_lua_install() {
	dolua src/${PN}.lua
}
