# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
GITHUB_A="msva"

inherit lua

DESCRIPTION="Lua bindings to zziplib"
HOMEPAGE="https://github.com/msva/luazip"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc examples"

RDEPEND="
	dev-libs/zziplib
"
DEPEND="
	${RDEPEND}
"

DOCS=(README)
HTML_DOCS=(doc/us/.)
EXAMPLES=(tests/.)

all_lua_prepare() {
	sed -i -e 'd' config
	lua_default
}

each_lua_configure() {
	myeconfargs=()
	myeconfargs+=(
		'LIB_OPTION=$(LDFLAGS)'
		'LIBNAME=zip.so'
	)
	lua_default
}

each_lua_install() {
	dolua src/*.so
}
