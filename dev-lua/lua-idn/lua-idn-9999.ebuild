# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
GITHUB_A="haste"

inherit lua

DESCRIPTION="A Lua implementation of IDNA (RFC 3490)"
HOMEPAGE="https://github.com/haste/lua-idn"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="test"

# TODO: Lua 5.2 handling

DEPEND="
	${RDEPEND}
"

each_lua_test() {
	${LUA} tests.lua
}

each_lua_install() {
	dolua idn.lua
}
