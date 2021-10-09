# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VCS="git"
GITHUB_A="agladysh"

inherit lua-broken

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
