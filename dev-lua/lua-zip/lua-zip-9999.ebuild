# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VCS="git"
#GITHUB_A="brimworks"
#GITHUB_A="markuman"

inherit cmake-utils lua-broken

DESCRIPTION="Lua bindings to libzip"
HOMEPAGE="https://git.osuv.de/m/lua-zip"
EGIT_REPO_URI="https://git.osuv.de/m/lua-zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	dev-libs/libzip
"

DEPEND="
	${RDEPEND}
"

DOCS=(README.md)

each_lua_configure() {
	mycmakeargs=(
		-DINSTALL_CMOD="$(lua_get_pkgvar INSTALL_CMOD)"
	)
	cmake-utils_src_configure
}
