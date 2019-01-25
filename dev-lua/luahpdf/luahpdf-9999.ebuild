# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
IS_MULTILIB=true
GITHUB_A="msva"

inherit lua

DESCRIPTION="Lua binding to media-libs/libharu (PDF generator)"
HOMEPAGE="https://github.com/jung-kurt/luahpdf"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc examples"

RDEPEND="
	media-libs/libharu
"
DEPEND="${RDEPEND}"

DOCS=(README.md doc/.)
EXAMPLES=(demo/.)

all_lua_prepare() {
	sed -i -r \
		-e 's#(_COMPILE=)cc#\1$(CC)#' \
		-e 's#(_LINK=)cc#\1$(CC)#' \
		-e 's#(_REPORT=).*#\1#' \
		Makefile

	lua_default
}

each_lua_install() {
	dolua hpdf.so
}
