# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="library and driver script for preprocessing and evaluating Lua code"
HOMEPAGE="https://github.com/stevedonovan/LuaMacro/"
EGIT_REPO_URI="https://github.com/stevedonovan/LuaMacro/"

LICENSE="MIT"
SLOT="0"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="
	${LUA_DEPS}
	|| (
		dev-lua/lpeg[${LUA_USEDEP}]
		dev-lua/lulpeg[${LUA_USEDEP},lpeg-replace]
	)
"

each_lua_install() {
	insinto "$(lua_get_lmod_dir)"
	doins -r macro{,.lua}
}

src_install() {
	lua_foreach_impl each_lua_install
	dobin luam
	einstalldocs
}
