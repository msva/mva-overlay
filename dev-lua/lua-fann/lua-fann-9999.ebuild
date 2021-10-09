# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VCS="git"
IS_MULTILIB=true
GITHUB_A="msva"

inherit lua-broken

DESCRIPTION="A set of Lua bindings for the Fast Artificial Neural Network (FANN) library."
HOMEPAGE="https://github.com/msva/lua-fann"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
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
	touch .lua_eclass_config
	use doc && (
		emake docs
	)
}

each_lua_configure() {
	myeconfargs=(
		LUA_IMPL="$(lua_get_lua)"
		LUA_BIN="${LUA}"
	)
	lua_default
}

each_lua_test() {
	emake test
}

each_lua_install() {
	dolua fann.so
}
