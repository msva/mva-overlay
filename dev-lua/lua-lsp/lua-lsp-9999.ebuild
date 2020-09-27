# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VCS="git"
GITHUB_A="Alloyed"

inherit lua

DESCRIPTION="A Language Server for Lua code, written in Lua"
HOMEPAGE="https://github.com/Alloyed/lua-lsp"

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

each_lua_install() {
	dolua "${PN}"
}

all_lua_install() {
	dobin "bin/${PN}"
}
