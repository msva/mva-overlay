# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
LUA_COMPAT="lua51 lua52 lua53"
GITHUB_A="thibaultcha"

inherit lua

DESCRIPTION="Lua C binding for the Argon2 password hashing function"
HOMEPAGE="https://github.com/thibaultcha/lua-argon2"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc luajit"

RDEPEND="
	app-crypt/argon2
	luajit? ( ${CATEGORY}/${PN}-ffi )
"
DEPEND="
	${RDEPEND}
"

DOCS=({README,CHANGELOG}.md)

each_lua_compile() {
	_lua_setFLAGS

	${CC} ${CFLAGS} -c -o "${PN}.o" "src/${PN#lua-}.c" || die
	${CC} ${LDFLAGS} -largon2 -o "${PN#lua-}.so" "${PN}.o" || die
}

each_lua_install() {
	dolua "argon2.so"
}
