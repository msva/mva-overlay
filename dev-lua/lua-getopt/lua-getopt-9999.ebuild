# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
GITHUB_A="jjensen"

inherit lua

DESCRIPTION="Lua getopt module (simplified)"
HOMEPAGE="https://github.com/jjensen/lua-getopt"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

each_lua_install() {
	dolua src/getopt.lua
}
