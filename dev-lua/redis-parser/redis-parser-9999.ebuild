# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
LUA_COMPAT="lua51 luajit2"
IS_MULTILIB=true
GITHUB_A="openresty"
GITHUB_PN="lua-${PN}"

inherit lua

DESCRIPTION="Redis reply parser and request constructor library for Lua"
HOMEPAGE="https://github.com/openresty/lua-redis-parser"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

each_lua_configure() {
	myeconfargs=(
		"PREFIX=/usr"
		"LUA_LIB_DIR=$(lua_get_pkgvar INSTALL_CMOD)"
		"LUA_INCLUDE_DIR=$(lua_get_pkgvar includedir)"
	)
	lua_default
}
