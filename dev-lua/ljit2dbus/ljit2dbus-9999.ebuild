# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( luajit )

inherit lua git-r3

DESCRIPTION="LuaJIT binding to libdbus"
HOMEPAGE="https://github.com/Wiladams/LJIT2dbus"
EGIT_REPO_URI="https://github.com/Wiladams/LJIT2dbus"

LICENSE="MIT"
SLOT="0"
IUSE="doc examples"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="
	${LUA_DEPS}
	sys-apps/dbus
"
DEPEND="
	${RDEPEND}
"

each_lua_install() {
	insinto "$(lua_get_lmod_dir)"
	doins src/*.lua
}

src_install() {
	lua_foreach_impl each_lua_install
	einstalldocs
}
