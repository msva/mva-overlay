# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="Parse HTML text into a tree of elements with selectors"
HOMEPAGE="https://github.com/msva/lua-htmlparser"
EGIT_REPO_URI="https://github.com/msva/lua-htmlparser"

LICENSE="MIT"
SLOT="0"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="
	${LUA_DEPS}
"
DEPEND="
	${RDEPEND}
"

each_lua_install() {
	insinto "$(lua_get_lmod_dir)"
	doins -r src/*
}

src_install() {
	lua_foreach_impl each_lua_install
	einstalldocs
}
