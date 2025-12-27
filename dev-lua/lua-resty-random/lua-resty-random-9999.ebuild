# Copyright 2026 mva
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( luajit )

inherit lua git-r3

DESCRIPTION="LuaJIT FFI-based Random Library for OpenResty"
HOMEPAGE="https://github.com/bungle/lua-resty-random"
EGIT_REPO_URI="https://github.com/bungle/lua-resty-random"

LICENSE="BSD"
SLOT="0"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="
	${LUA_DEPS}
	|| (
		>=www-servers/nginx-1.28.0-r10[nginx_modules_http_ssl(-)]
		>=www-servers/nginx-1.28.0-r10[nginx_modules_stream_ssli(-)]
		www-servers/nginx[ssl(-)]
	)
	|| (
		www-servers/nginx:*[nginx_modules_http_lua(-)]
		www-nginx/ngx-lua-module[lua_single_target_luajit]
	)
	dev-libs/openssl:*
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
