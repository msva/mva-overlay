# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VCS="git"
GITHUB_A="stevedonovan"

inherit lua-broken

DESCRIPTION="library and driver script for preprocessing and evaluating Lua code"
HOMEPAGE="https://github.com/stevedonovan/LuaMacro/"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	|| (
		dev-lua/lpeg
		dev-lua/lulpeg[lpeg_replace]
	)
"

each_lua_install() {
	dolua macro{,.lua}
}

all_lua_install() {
	dobin luam
}
