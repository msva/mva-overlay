# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( luajit )

inherit lua git-r3

DESCRIPTION="New LuaJIT FFI based API for lua-nginx-module"
HOMEPAGE="https://github.com/openresty/lua-resty-core"
EGIT_REPO_URI="https://github.com/openresty/lua-resty-core"

LICENSE="BSD"
SLOT="0"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="
	${LUA_DEPS}
	www-servers/nginx:*[${LUA_USEDEP},nginx_modules_http_lua]
	dev-lua/resty-lrucache[${LUA_USEDEP}]
"
DEPEND="
	${RDEPEND}
"

DOCS+=(docs/.)

src_prepare() {
	default
	mkdir -p docs
	find . -type f -name '*.md' -exec mv -t docs {} ';'
}

each_lua_install() {
	insinto "$(lua_get_lmod_dir)"
	doins -r lib/resty lib/ngx
}

src_install() {
	einstalldocs
	lua_foreach_impl each_lua_install
}
