# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
IS_MULTILIB=true
GITHUB_A="msva"

inherit cmake-utils lua

DESCRIPTION="A minimal set of XML processing funcs & simple XML<->Tables mapping"
HOMEPAGE="http://viremo.eludi.net/LuaXML/"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

each_lua_configure() {
	mycmakeargs=(
		-DINSTALL_CMOD="$(lua_get_pkgvar INSTALL_CMOD)"
		-DINSTALL_LMOD="$(lua_get_pkgvar INSTALL_LMOD)"
	)

	cmake-utils_src_configure
}
