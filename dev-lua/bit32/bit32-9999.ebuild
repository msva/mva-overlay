# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# building fine, but not needed for Lua5.2 and Lua5.3
LUA_COMPAT="lua51 luajit2"
IS_MULTILIB=true
VCS="git"
GITHUB_A="keplerproject"
GITHUB_PN="lua-compat-5.2"

inherit lua

DESCRIPTION="A Lua5.2+ bit manipulation library"
HOMEPAGE="https://github.com/keplerproject/lua-compat-5.2"

KEYWORDS=""

LICENSE="MIT"
SLOT="0"
IUSE=""

DOCS=(README.md)

each_lua_compile() {
	_lua_setFLAGS
	local MY_PN="lbitlib"

	${CC} ${CFLAGS} -Ic-api -c -o ${MY_PN}.o ${MY_PN}.c || die
	${CC} ${LDFLAGS} -o ${PN}.so ${MY_PN}.o || die
}

each_lua_install() {
	dolua "${PN}.so"
}
