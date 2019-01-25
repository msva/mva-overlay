# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
GITHUB_A="LuaLanes"

inherit cmake-utils lua

DESCRIPTION="lightweight, native, lazy evaluating multithreading library"
HOMEPAGE="https://github.com/LuaLanes/lanes"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc"

DOCS=(README CHANGES)
HTML_DOCS=(docs/.)

all_lua_prepare() {
	sed -r \
		-e '/^#include "tools.h"$/{h;d};/^#include "universe.h"$/G' \
		-i src/deep.c
	lua_default
}

each_lua_configure() {
	mycmakeargs=(
		-DINSTALL_CMOD="$(lua_get_pkgvar INSTALL_CMOD)/${PN}"
		-DINSTALL_LMOD="$(lua_get_pkgvar INSTALL_LMOD)"
	)
	cmake-utils_src_configure
}

all_lua_install() {
	lua_default
	rm "${ED}"/usr/share/lanes -r
}
