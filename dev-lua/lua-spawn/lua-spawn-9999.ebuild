# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
GITHUB_A="daurnimator"
IS_MULTILIB=true

inherit lua

DESCRIPTION="A lua library to spawn programs"
HOMEPAGE="https://github.com/daurnimator/lua-spawn"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="examples"

EXAMPLES=(spec/.)

DEPEND="
	dev-lua/lunix
"
RDEPEND="
	${RDEPEND}
"
MY_PN="${PN##lua-}"

all_lua_prepare() {
	mv "${MY_PN}/posix.c" "${S}"
	lua_default
}

each_lua_compile() {
	_lua_setFLAGS
	${CC} ${CFLAGS} ${LDFLAGS} -I./vendor/compat-5.3/c-api/ "-I$(lua_get_incdir)" posix.c -o "${MY_PN}"/posix.so
}

each_lua_install() {
	dolua "${MY_PN}"/
}
