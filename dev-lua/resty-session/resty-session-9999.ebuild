# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="Session library for OpenResty implementing Secure Cookie Protocol"
HOMEPAGE="https://github.com/bungle/lua-resty-session"
EGIT_REPO_URI="https://github.com/bungle/lua-resty-session"

LICENSE="BSD"
SLOT="0"

REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="
	${LUA_DEPS}
	www-servers/nginx:*[nginx_modules_http_lua]
	dev-lua/lua-cjson[${LUA_USEDEP}]
	dev-lua/resty-string[${LUA_USEDEP}]
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
}
