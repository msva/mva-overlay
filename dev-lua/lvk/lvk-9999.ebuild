# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="Lua wrapper-functions for REST API methods of vk.com"
HOMEPAGE="https://github.com/msva/lvk"
EGIT_REPO_URI="https://github.com/msva/lvk"

LICENSE="MIT"
SLOT="0"
IUSE="examples"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="
	${LUA_DEPS}
	dev-lua/luasec[${LUA_USEDEP}]
	dev-lua/dkjson[${LUA_USEDEP}]
"
DEPEND="
	${RDEPEND}
"

each_lua_install() {
	insinto "$(lua_get_lmod_dir)"
	doins "${PN}".lua
}

src_install() {
	lua_foreach_impl each_lua_install
	if use examples; then
		DOCS+=( test-lvk.lua )
		docompress -x "/usr/share/doc/${PF}/examples"
	fi
	einstalldocs
}
