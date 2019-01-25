# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
GITHUB_A="wahern"
IS_MULTILIB=true

inherit lua

DESCRIPTION="Most comprehensive OpenSSL module in the Lua universe."
HOMEPAGE="https://github.com/wahern/luaossl/"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc examples"

DEPEND="
	dev-libs/openssl:*
"
RDEPEND="${DEPEND}"

DOCS=(doc/.)
EXAMPLES=(examples/.)

all_lua_prepare() {
	sed  -r \
		-e "s@(^prefix ).*@\1=/usr@" \
		-i GNUmakefile
	lua_default
}

each_lua_compile() {
	_lua_setFLAGS
	lua_default "openssl$(lua_get_abi)"
}

each_lua_install() {
	_lua_setFLAGS
	emake DESTDIR="${D}" "install$(lua_get_abi)"
}
