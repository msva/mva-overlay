# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
GITHUB_A="Alloyed"

inherit lua

DESCRIPTION="A Language Server for Lua code, written in Lua"
HOMEPAGE="https://github.com/Alloyed/lua-lsp"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="+lint +format"

lua_add_rdepend "lint? ( dev-lua/luacheck )"
lua_add_rdepend "format? ( dev-lua/luaformatter )"
lua_add_rdepend "dev-lua/dkjson"
lua_add_rdepend "dev-lua/lpeglabel"
lua_add_rdepend "dev-lua/inspect"


each_lua_install() {
	dolua "${PN}"
}

all_lua_install() {
	dobin "bin/${PN}"
}
