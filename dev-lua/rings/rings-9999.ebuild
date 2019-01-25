# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
IS_MULTILIB=true
GITHUB_A="keplerproject"

inherit lua

DESCRIPTION="Lua Rings Library"
HOMEPAGE="https://github.com/keplerproject/rings"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

each_lua_configure() {
	myeconfargs=(
		PREFIX=/usr
		LIBNAME="${P}".so
		LUA_LIBDIR="$(lua_get_pkgvar INSTALL_CMOD)"
		LUA_DIR="$(lua_get_pkgvar INSTALL_LMOD)"
	)
	lua_default
}
