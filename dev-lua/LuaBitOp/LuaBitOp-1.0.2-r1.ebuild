# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

IS_MULTILIB=true
LUA_COMPAT="lua51 lua52 lua53"

inherit lua

DESCRIPTION="Bit Operations Library for the Lua Programming Language"
HOMEPAGE="http://bitop.luajit.org"
SRC_URI="http://bitop.luajit.org/download/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~x86"
IUSE="doc"

DOCS=(README)
HTML_DOCS=(doc/.)

each_lua_configure() {
	# Lua5.3 compilation hack
	myeconfargs=( 'CFLAGS+=-DLUA_NUMBER_DOUBLE' )
	lua_default
}

each_lua_test() {
	emake LUA=${LUA} test
}

each_lua_install() {
	dolua bit.so
}
