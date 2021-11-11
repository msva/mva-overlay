# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="Lua MySQL client driver for ngx_lua based on the cosocket API"
HOMEPAGE="https://github.com/openresty/lua-resty-mysql"
EGIT_REPO_URI="https://github.com/openresty/lua-resty-mysql"

LICENSE="BSD"
SLOT="0"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="
	${LUA_DEPS}
	www-servers/nginx:*[${LUA_USEDEP},nginx_modules_http_lua]
"
DEPEND="
	${RDEPEND}
"

each_lua_install() {
	insinto "$(lua_get_lmod_dir)"
	doins -r lib/resty
}

src_compile() { :; }

src_install() {
	lua_foreach_impl each_lua_install
	einstalldocs
}
