# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

LUA_COMPAT=( luajit )

inherit lua git-r3

DESCRIPTION="LuaJIT FFI bindings to app-text/hoedown"
HOMEPAGE="https://github.com/bungle/lua-resty-hoedown"
EGIT_REPO_URI="https://github.com/bungle/lua-resty-hoedown"

REQUIRED_USE="${LUA_REQUIRED_USE}"

LICENSE="BSD"
SLOT="0"

RDEPEND="
	${LUA_DEPS}
	|| (
		www-servers/nginx:*[nginx_modules_http_lua(-)]
		www-nginx/ngx-lua-module[lua_single_target_luajit]
	)
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
