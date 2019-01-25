# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
GITHUB_A="spc476"
GITHUB_PN="${PN^^}"
inherit lua

DESCRIPTION="The most comprehensive CBOR module in the Lua universe"
HOMEPAGE="https://github.com/spc476/CBOR"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc +examples"

RDEPEND="
	|| (
		dev-lua/lpeg
		dev-lua/lulpeg[lpeg_replace]
	)
"
DEPEND="
	${RDEPEND}
"

EXAMPLES=( test.lua test_s.lua )
DOCS=(README)

all_lua_prepare() {
	sed -r \
		-e 's@^(prefix).*@\1=/usr@' \
		-e 's@(.*LUA_DIR.*/lua/.*shell )lua( -e "print.*)@\1${LUA_IMPL}\2@' \
		-i Makefile

	lua_default
}
