# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
LUA_COMPAT="luajit2"
GITHUB_A="thibaultcha"

inherit lua

DESCRIPTION="LuaJIT FFI binding for the Argon2 password hashing function"
HOMEPAGE="https://github.com/thibaultcha/lua-argon2"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc"

RDEPEND="
	app-crypt/argon2
"
DEPEND="
	${RDEPEND}
"

DOCS=({README,CHANGELOG}.md)

each_lua_test() {
	emake
}

src_compile() { :; }

each_lua_install() {
	dolua_jit "src/argon2.lua"
}
