# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VCS="git"
GITHUB_A="openresty"
GITHUB_PN="lua-${PN}"

inherit lua-broken

DESCRIPTION="Lua WebSocket implementation for the NginX lua module"
HOMEPAGE="https://github.com/openresty/lua-resty-websocket"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	www-servers/nginx:*[nginx_modules_http_lua]
"
DEPEND="
	${RDEPEND}
"

DOCS=(README.markdown)

each_lua_install() {
	dolua lib/resty
}
