# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
GITHUB_A="geoffleyland"
inherit lua

DESCRIPTION="a Lua module for reading delimited text files"
HOMEPAGE="https://github.com/geoffleyland/lua-csv"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DOCS=(README.md)

each_lua_install() {
	dolua lua/csv.lua
}
