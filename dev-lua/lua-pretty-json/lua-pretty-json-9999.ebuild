# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VCS="git"
GITHUB_A="xiedacon"
inherit lua-broken

DESCRIPTION="Pretty JSON serializer and parser on pure Lua"
HOMEPAGE="http://www.kyne.com.au/~mark/software/lua-cjson.php"

LICENSE="MIT"
SLOT="0"

each_lua_install() {
	dolua lib/pretty
}
