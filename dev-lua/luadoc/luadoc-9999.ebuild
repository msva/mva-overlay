# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VCS="git"
GITHUB_A="keplerproject"
inherit lua

DESCRIPTION="LuaDoc is a documentation tool for Lua source code"
HOMEPAGE="http://keplerproject.github.io/luadoc/"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc"

DEPEND=""
RDEPEND="
	dev-lua/luafilesystem
"

DOCS=( README.md )
HTML_DOCS=( doc/us/. )

all_lua_prepare() {
	# >=lua-5.1.3
	find . -name '*.lua' | xargs sed -e "s/gfind/gmatch/g" -i || die
	default
}

each_lua_install() {
	dolua "src/${PN}"
}

all_lua_install() {
	newbin "src/${PN}.lua.in" "${PN}"
}
