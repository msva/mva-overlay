# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VCS="git"
GITHUB_A="jjensen"

inherit lua-broken

DESCRIPTION="Lua getopt module (simplified)"
HOMEPAGE="https://github.com/jjensen/lua-getopt"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

each_lua_install() {
	dolua src/getopt.lua
}
