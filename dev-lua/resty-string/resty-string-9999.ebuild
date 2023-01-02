# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( luajit )

inherit lua git-r3

DESCRIPTION="String utilities and common hash functions for ngx_lua and LuaJIT"
HOMEPAGE="https://github.com/openresty/lua-resty-string"
EGIT_REPO_URI="https://github.com/openresty/lua-resty-string"

LICENSE="BSD"
SLOT="0"
IUSE="naive-random"

REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="
	${LUA_DEPS}
	www-servers/nginx:*[nginx_modules_http_lua,ssl]
	dev-libs/openssl:0
"
DEPEND="
	${RDEPEND}
"
PDEPEND="!naive-random? ( dev-lua/resty-random[${LUA_USEDEP}] )"

src_prepare() {
	default
	use naive-random || rm lib/resty/random.lua
}

each_lua_install() {
	insinto "$(lua_get_lmod_dir)"
	doins -r lib/resty
}

src_install() {
	lua_foreach_impl each_lua_install
	einstalldocs
}
