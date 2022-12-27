# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=(lua{5-{1..4},jit})

inherit lua git-r3

DESCRIPTION="A Language Server for Lua code, written in Lua"
HOMEPAGE="https://github.com/Alloyed/lua-lsp"
EGIT_REPO_URI="https://github.com/Alloyed/lua-lsp"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="+lint +format"

RDEPEND="${RDEPEND}
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
