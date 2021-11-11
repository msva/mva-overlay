# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="Lua MongoDB driver"
HOMEPAGE="https://github.com/Olivine-Labs/resty-mongol"
EGIT_REPO_URI="https://github.com/Olivine-Labs/resty-mongol"

LICENSE="MIT"
SLOT="0"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="
	${LUA_DEPS}
	|| (
		www-servers/nginx:*[${LUA_USEDEP},nginx_modules_http_lua]
		dev-lua/luasocket[${LUA_USEDEP}]
	)
"
DEPEND="${RDEPEND}"

each_lua_install() {
	insinto "$(lua_get_lmod_dir)/${PN//-/\/}"
	doins src/*.lua
}

src_install() {
	lua_foreach_impl each_lua_install
	einstalldocs
}
