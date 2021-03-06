# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VCS="git"
GITHUB_A="cramey"
EGIT_BRANCH="public"

inherit lua

DESCRIPTION="A FastCGI server for Lua, written in C"
HOMEPAGE="https://github.com/cramey/lua-fastcgi"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc examples"

RDEPEND="
	dev-libs/fcgi
"
DEPEND="${RDEPEND}"

DOCS=(README.md TODO)
EXAMPLES=(${PN}.lua)

all_lua_prepare() {
	sed -r \
		-e 's/-Wl,[^ ]*//g' \
		-i Makefile

	sed \
		-e "s#lua5.1/##" \
		-i src/config.c src/lfuncs.c src/lua.c src/lua-fastcgi.c

	lua_default
}

each_lua_install() {
	newbin ${PN} ${PN}-${TARGET}
}
