# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( luajit )

inherit lua git-r3

DESCRIPTION="LuaJIT FFI binding for the Argon2 password hashing function"
HOMEPAGE="https://github.com/thibaultcha/lua-argon2-ffi"
EGIT_REPO_URI="https://github.com/thibaultcha/lua-argon2-ffi"

LICENSE="MIT"
SLOT="0"
IUSE="doc"

REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="
	${LUA_DEPS}
	app-crypt/argon2
"
DEPEND="
	${RDEPEND}
"

each_lua_test() {
	emake
}

each_lua_install() {
	insinto "$(lua_get_lmod_dir)"
	doins "src/argon2.lua"
}

src_test() {
	lua_foreach_impl each_lua_test
}

src_compile() { :; }

src_install() {
	lua_foreach_impl each_lua_install
	einstalldocs
}
