# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
IS_MULTILIB=true
GITHUB_A="openresty"
#LUA_COMPAT="lua51 luajit2"
inherit lua

DESCRIPTION="Lua JSON Library, written in C"
HOMEPAGE="http://www.kyne.com.au/~mark/software/lua-cjson.php"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="examples"

EXAMPLES=( tests/. lua/{json2lua,lua2json}.lua )

each_lua_install() {
	dolua lua/cjson cjson.so
}
