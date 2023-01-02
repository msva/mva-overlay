# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="A basic XML serializer for Lua"
HOMEPAGE="https://github.com/Phrogz/slaxml"
EGIT_REPO_URI="https://github.com/Phrogz/slaxml"

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
	doins *.lua
}

src_install() {
	lua_foreach_impl each_lua_install
	einstalldocs
}
