# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

LUA_COMPAT="luajit2"

VCS="git"
GITHUB_A="Wiladams"

inherit lua

DESCRIPTION="LuaJIT binding to libdbus"
HOMEPAGE="https://github.com/Wiladams/LJIT2dbus"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc examples"

DOCS=(README.md)
EXAMPLES=(testy/.)

RDEPEND="
	sys-apps/dbus
"

each_lua_install() {
	dolua_jit src/*.lua
}
