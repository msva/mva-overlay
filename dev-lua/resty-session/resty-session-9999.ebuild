# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VCS="git"
LUA_COMPAT="luajit2"
GITHUB_A="bungle"
GITHUB_PN="lua-${PN}"

inherit lua-broken

DESCRIPTION="Session library for OpenResty implementing Secure Cookie Protocol"
HOMEPAGE="https://github.com/bungle/lua-resty-session"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	www-servers/nginx:*[nginx_modules_http_lua]
	dev-lua/lua-cjson
	dev-lua/resty-string
"
DEPEND="
	${RDEPEND}
"

DOCS=(README.md)

each_lua_install() {
	dolua_jit lib/resty
}
