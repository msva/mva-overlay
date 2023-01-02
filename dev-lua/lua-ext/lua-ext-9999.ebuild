# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="Some useful extensions to Lua classes"
HOMEPAGE="https://github.com/thenumbernine/lua-ext"
EGIT_REPO_URI="https://github.com/thenumbernine/lua-ext"

LICENSE="MIT"
SLOT="0"
IUSE="+gcmem"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="
	${LUA_DEPS}
	dev-lua/luafilesystem[${LUA_USEDEP}]
	gcmem? (
		!lua_targets_luajit? (
			dev-lua/lua-ffi-bindings[${LUA_USEDEP}]
		)
	)
"
DEPEND="
	${RDEPEND}
"

each_lua_install() {
	insinto "$(lua_get_lmod_dir)"
	doins -r ext
}

src_install() {
	lua_foreach_impl each_lua_install
	einstalldocs
}

src_prepare() {
	default
	use gcmem || rm gcmem.lua
	mkdir -p ext
	mv ext.lua ext/init.lua || die
	mv *.lua ext || die
}
