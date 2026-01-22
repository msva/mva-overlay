# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

LUA_COMPAT=(lua{5-{1..4},jit})

inherit lua git-r3

DESCRIPTION="A Language Server for Lua code, written in Lua"
HOMEPAGE="https://github.com/Alloyed/lua-lsp"
EGIT_REPO_URI="https://github.com/Alloyed/lua-lsp"

LICENSE="MIT"
SLOT="0"
IUSE="+lint +format"

RDEPEND="
	${LUA_DEPS}
	${RDEPEND}
	lint? ( dev-lua/luacheck )
	format? ( dev-lua/luaformatter )
	dev-lua/dkjson
	dev-lua/lpeglabel
	dev-lua/inspect
"

lua_install() {
	insinto "$(lua_get_lmod_dir)"
	doins -r "${PN}"
}

src_install() {
	lua_foreach_impl lua_install
	dobin "bin/${PN}"
}
