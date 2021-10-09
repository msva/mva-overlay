# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VCS="git"
GITHUB_A="openresty"
GITHUB_PN="lua-${PN}"

inherit lua-broken

DESCRIPTION="Lua MySQL client driver for ngx_lua based on the cosocket API"
HOMEPAGE="https://github.com/openresty/lua-resty-mysql"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	virtual/lua[bit]
	www-servers/nginx:*[nginx_modules_http_lua]
"
DEPEND="
	${RDEPEND}
"

DOCS=(README.markdown)

each_lua_install() {
	dolua lib/resty
}
