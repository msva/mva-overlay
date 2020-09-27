# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VCS="git"
GITHUB_A="lua-stdlib"
GITHUB_PN="_${PN#lua-std-}"

inherit lua

DESCRIPTION="Debug Hints Library"
HOMEPAGE="https://github.com/lua-stdlib/_debug"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc"

DEPEND="${DEPEND}
	doc? ( dev-lua/ldoc )
"

HTML_DOCS=(doc/.)
DOCS=(README.md NEWS.md)

all_lua_prepare() {
	lua_default
}

each_lua_compile() {
	if [[ "${PV}" == "9999" ]]; then
		ver="git:$(git rev-parse --short @):${LUA_IMPL}"
	fi
	lua_default
}

each_lua_install() {
	dolua lib/std
}
