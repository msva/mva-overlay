# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VCS="git"
GITHUB_A="geoffleyland"
inherit lua-broken

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
