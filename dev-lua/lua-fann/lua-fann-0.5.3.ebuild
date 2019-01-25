# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

IS_MULTILIB=true
GITHUB_A="msva"

inherit lua

DESCRIPTION="A set of Lua bindings for the Fast Artificial Neural Network (FANN) library."
HOMEPAGE="https://github.com/msva/lua-fann"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
# not available on fann: ~arm{,64} and ~mips
IUSE="doc examples"

RDEPEND="
	sci-mathematics/fann
"
DEPEND="
	${RDEPEND}
"

DOCS=(README.md)
HTML_DOCS=(doc/luafann.html)
EXAMPLES=(test/.)

all_lua_compile() {
	use doc && (
		emake docs
	)
}

each_lua_compile() {
	lua_default \
		LUA_IMPL="$(lua_get_lua)" \
		LUA_BIN="${LUA}" \
		LUA_INC="."
}

each_lua_test() {
	emake test
}

each_lua_install() {
	dolua fann.so
}
