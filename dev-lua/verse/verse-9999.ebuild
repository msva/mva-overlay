# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="mercurial"
LUA_COMPAT="lua51 luajit2"
CUSTOM_ECONF=true
inherit lua

DESCRIPTION="XMPP client library written in Lua."
HOMEPAGE="http://code.matthewwild.co.uk/"
EHG_REPO_URI="http://code.matthewwild.co.uk/${PN}/"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="examples"

RDEPEND="
	dev-lua/squish
	dev-lua/luasocket
	dev-lua/luaexpat
	dev-lua/luafilesystem
	virtual/lua[bit]
"
DEPEND="
	${RDEPEND}
"

EXAMPLES=(doc/.)

each_lua_prepare() {
	local impl="$(lua_get_lua)"
	sed -r \
		-e "s@^(PREFIX)=.*@\1=/usr@" \
		-e "s@^(LUA_VERSION)=.*@\1=${impl##lua}@" \
		-i configure
	lua_default
}

each_lua_configure() {
	./configure
	lua_default
}

each_lua_install() {
	dolua verse.lua
}
