# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

IS_MULTILIB=true
VCS="git"
GITHUB_A="antirez"

inherit lua

DESCRIPTION="A self contained Lua MessagePack C implementation"
HOMEPAGE="https://github.com/antirez/lua-cmsgpack"

KEYWORDS=""
DOCS=(README.md)

LICENSE="BSD-2"
SLOT="0"
IUSE="doc test"

each_lua_compile() {
	_lua_setFLAGS
	local MY_PN="${PN//-/_}"

	${CC} ${CFLAGS} -c -o ${MY_PN}.o ${MY_PN}.c || die
	${CC} ${LDFLAGS} -o ${PN}.so ${MY_PN}.o || die
}

each_lua_test() {
	${LUA} test.lua || die
}

each_lua_install() {
	dolua "${PN}.so"
}
