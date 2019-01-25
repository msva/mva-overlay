# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# XXX: broken build FIXME later
EAPI=6
VCS="git"
GITHUB_A="moai"

inherit lua

DESCRIPTION="Lua driver for MongoDB"
HOMEPAGE="https://github.com/mwild1/luamongo/"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc examples"

RDEPEND="
	dev-libs/boost
	dev-libs/mongo-cxx-driver
"
#	dev-db/mongodb[sharedclient]
# NB: Incompatible with current mongo-driver

DEPEND="${RDEPEND}"

DOCS=(README.md)
EXAMPLES=(tests/.)

all_lua_prepare() {
	# Preparing makefile to default_prepare magic fix
	sed -i -r \
		-e '/^MONGOFLAGS/d' \
		-e '/^LUAPKG/d' \
		-e '/^LUAFLAGS/d' \
		-e '/if . -z /d' \
		-e 's#\$\(shell pkg-config --libs \$\(LUAPKG\)\)#-llua#' \
		Makefile
	lua_default
}

each_lua_configure() {
	myeconfargs=(
		LUAPKG="$(lua_get_lua)"
	)
	lua_default
}

each_lua_install() {
	dolua mongo.so
}
