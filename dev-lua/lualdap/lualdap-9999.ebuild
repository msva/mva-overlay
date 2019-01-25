# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
IS_MULTILIB=true
GITHUB_A="mwild1"

inherit lua

DESCRIPTION="Lua driver for LDAP"
HOMEPAGE="https://github.com/mwild1/lualdap/"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc examples"

RDEPEND="
	net-nds/openldap
"
DEPEND="${RDEPEND}"

DOCS=(README)
EXAMPLES=(tests/.)
HTML_DOCS=(doc/us/.)

all_lua_prepare() {
	sed -i -e 'd' config
	lua_default
}

each_lua_configure() {
	local luav="$(lua_get_abi)"
	luav="${luav//./0}"
	myeconfargs=(
		OPENLDAP_LIB="-lldap"
		LUA_VERSION_LUM="${luav}"
		LIBNAME="${PN}.so"
		LIB_OPTION='$(LDFLAGS)'
	)
	lua_default
}

#each_lua_test() {
#	Requires LDAP server
#	${LUA} tests/test.lua <hostname>[:port] <base> [<who> [<password>]]
#}

each_lua_install() {
	dolua src/${PN}.so
}
