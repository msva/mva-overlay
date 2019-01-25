# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
GITHUB_A="cloudflare"
GITHUB_PN="lua-${PN}"

inherit lua

DESCRIPTION="Library for parsing HTTP Cookie header for Nginx"
HOMEPAGE="https://github.com/cloudflare/lua-resty-cookie"

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

DOCS=(README.md)

each_lua_install() {
	dolua lib/resty
}
