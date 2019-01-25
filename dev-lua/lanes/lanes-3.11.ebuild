# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils lua

DESCRIPTION="lightweight, native, lazy evaluating multithreading library"
HOMEPAGE="https://github.com/LuaLanes/lanes"
SRC_URI="https://github.com/LuaLanes/lanes/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~x86"
IUSE="doc"

DOCS=(README CHANGES)
HTML_DOCS=(docs/.)

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
