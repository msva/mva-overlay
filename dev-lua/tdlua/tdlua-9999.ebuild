# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

LUA_COMPAT="lua52 lua53 luajit2"

VCS="git"
GITHUB_A="giuseppeM99"

inherit cmake-utils lua

DESCRIPTION="A basic interface between tdlib and lua"
HOMEPAGE="https://github.com/giuseppeM99/tdlua"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="doc examples"

DOCS=(README.md)
EXAMPLES=(examples/.)

RDEPEND="
	dev-libs/openssl:0
	media-libs/opus:0
	net-libs/tdlib:0
"

each_lua_configure() {
	mycmakeargs=(
		-DLUA_INCLUDE_DIR=$(lua_get_incdir)
	)
	cmake-utils_src_configure
}

each_lua_install() {
	dolua "${PN}".so
}
