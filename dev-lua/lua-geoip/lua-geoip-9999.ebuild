# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
GITHUB_A="agladysh"

inherit lua

DESCRIPTION="Lua GeoIP Library"
HOMEPAGE="https://agladysh.github.io/lua-geoip"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc"

RDEPEND="
	dev-libs/geoip
"
DEPEND="
	${RDEPEND}
"

DOCS=(README.md HISTORY TODO)

src_test() {
	${LUA} test/test.lua /usr/share/GeoIP/Geo{IP,LiteCity}.dat
}

each_lua_install() {
	dolua geoip{,.so}
}
