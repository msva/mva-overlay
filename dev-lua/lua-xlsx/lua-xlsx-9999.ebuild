# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
GITHUB_A="jjensen"
inherit lua

DESCRIPTION="a Lua module for reading .xlsx files"
HOMEPAGE="https://github.com/jjensen/lua-xlsx"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc examples"

DOCS=(readme.md doc/us/index.md)
HTML_DOCS=(doc/us/{index,license}.html doc/us/doc.css)
EXAMPLES=(tests/.)

each_lua_install() {
	dolua xlsx.lua
}
