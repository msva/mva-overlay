# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="Health Checker for Nginx Upstream Servers in Pure Lua"
HOMEPAGE="https://github.com/openresty/lua-resty-upstream-healthcheck"
EGIT_REPO_URI="https://github.com/openresty/lua-resty-upstream-healthcheck"

LICENSE="BSD"
SLOT="0"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="
	${LUA_DEPS}
	www-servers/nginx:*[${LUA_USEDEP},nginx_modules_http_lua,nginx_modules_http_lua_upstream]
"
DEPEND="
	${RDEPEND}
"

each_lua_install() {
	insinto "$(lua_get_lmod_dir)"
	doins -r lib/resty
}

src_install() {
	lua_foreach_impl each_lua_install
	einstalldocs
}
