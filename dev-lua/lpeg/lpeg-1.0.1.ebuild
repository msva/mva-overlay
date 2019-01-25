# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

IS_MULTILIB=true

inherit lua

DESCRIPTION="Parsing Expression Grammars for Lua"
HOMEPAGE="http://www.inf.puc-rio.br/~roberto/lpeg/"
SRC_URI="http://www.inf.puc-rio.br/~roberto/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~x86"
IUSE="debug doc luajit"

REQUIRED_USE="luajit? ( lua_targets_luajit2 )"

PATCHES=("${FILESDIR}/${P}-makefile.patch")
DOCS=(HISTORY)
HTML_DOCS=({lpeg,re}.html)

all_lua_prepare() {
	use debug && append-cflags -DLPEG_DEBUG
	lua_default
}

each_lua_compile() {
	lua_default DLLFLAGS="${CFLAGS} ${LDFLAGS}" lpeg.so
}

each_lua_test() {
	${LUA} test.lua
}

each_lua_install() {
	dolua lpeg.so re.lua
}
