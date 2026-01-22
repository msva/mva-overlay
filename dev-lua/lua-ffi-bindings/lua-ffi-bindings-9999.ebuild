# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

LUA_COMPAT=( luajit )

inherit lua git-r3

DESCRIPTION="Some common headers ported over to LuaJIT FFI"
HOMEPAGE="https://github.com/thenumbernine/lua-ffi-bindings"
EGIT_REPO_URI="https://github.com/thenumbernine/lua-ffi-bindings"

LICENSE="MIT"
SLOT="0"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="
	${LUA_DEPS}
	dev-lua/lua-ffi-bindings[${LUA_USEDEP}]
"
DEPEND="${RDEPEND}"

each_lua_install() {
	insinto "$(lua_get_lmod_dir)"
	doins -r *.lua android/ c/ cpp/
}

src_install() {
	lua_foreach_impl each_lua_install
	einstalldocs
}
