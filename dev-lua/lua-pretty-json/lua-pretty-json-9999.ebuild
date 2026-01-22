# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="Pretty JSON serializer and parser on pure Lua"
HOMEPAGE="https://github.com/xiedacon/lua-pretty-json"
EGIT_REPO_URI="https://github.com/xiedacon/lua-pretty-json"

LICENSE="MIT"
SLOT="0"

each_lua_install() {
	insinto "$(lua_get_lmod_dir)"
	doins -r lib/pretty
}

src_install() {
	lua_foreach_impl each_lua_install
	einstalldocs
}
