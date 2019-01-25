# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

IS_MULTILIB=true
VCS="git"
GITHUB_A="dodo"

inherit lua

DESCRIPTION="udev bindings for Lua"
HOMEPAGE="https://github.com/dodo/lua-udev/"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="examples"

EXAMPLES=(test.lua)

RDEPEND=""
DEPEND="
	${RDEPEND}
	virtual/libudev
"

each_lua_compile() {
	_lua_setFLAGS
	${CC} "${PN}.c" ${CFLAGS} ${LUA_CF} ${LDFLAGS} ${LUA_LF} -ludev -o udev.so
}

each_lua_install() {
	dolua udev.so
}
