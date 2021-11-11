# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( luajit )

inherit lua git-r3

DESCRIPTION="A simple LRU cache for OpenResty and the ngx_lua module (based on LuaJIT FFI)"
HOMEPAGE="https://github.com/openresty/lua-resty-lrucache"
EGIT_REPO_URI="https://github.com/openresty/lua-resty-lrucache"

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
