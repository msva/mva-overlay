# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VCS="git"
GITHUB_A="knyar"
GITHUB_PN="nginx-lua-prometheus"

inherit lua

DESCRIPTION="Prometheus exporter for NginX metrics"
HOMEPAGE="https://github.com/knyar/nginx-lua-prometheus"

LICENSE="MIT"
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
	dolua prometheus.lua
}
