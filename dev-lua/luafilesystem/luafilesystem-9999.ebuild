# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
IS_MULTILIB="true"
GITHUB_A="keplerproject"

inherit lua

DESCRIPTION="File System Library for the Lua Programming Language"
HOMEPAGE="https://keplerproject.github.io/luafilesystem/"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc"

HTML_DOCS=(doc/us/.)
DOCS=(README.md)

all_lua_prepare() {
	sed -e 'd' config
	lua_default
}

each_lua_configure() {
	myeconfargs=(
		LIB_OPTION='$(LDFLAGS)'
	)
	lua_default
}

each_lua_install() {
	dolua src/lfs.so
}
