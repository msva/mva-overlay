# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VCS="git"
GITHUB_A=kikito
GITHUB_PN="${PN}.lua"

inherit lua

DESCRIPTION="A simple Lua function for printing to the console in color."
HOMEPAGE="https://github.com/kikito/ansicolors.lua"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DOCS=(README.textile)

each_lua_install() {
	dolua ansicolors.lua
}
