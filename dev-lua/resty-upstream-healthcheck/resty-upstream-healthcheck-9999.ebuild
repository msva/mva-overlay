# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VCS="git"
GITHUB_A="openresty"
GITHUB_PN="lua-${PN}"

inherit lua

DESCRIPTION="Health Checker for Nginx Upstream Servers in Pure Lua"
HOMEPAGE="https://github.com/openresty/lua-resty-upstream-healthcheck"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	www-servers/nginx:*[nginx_modules_http_lua,nginx_modules_http_lua_upstream]
"
DEPEND="
	${RDEPEND}
"

DOCS=(README.markdown)

each_lua_install() {
	dolua lib/resty
}
