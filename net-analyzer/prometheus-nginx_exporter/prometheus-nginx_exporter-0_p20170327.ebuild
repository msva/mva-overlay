# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

GITHUB_A="knyar"
GITHUB_PN="nginx-lua-prometheus"
GITHUB_PV="24ab338427bcfd121ac6c9a264a93d482e115e14"

inherit lua

DESCRIPTION="Prometheus exporter for NginX metrics"
HOMEPAGE="https://github.com/knyar/nginx-lua-prometheus"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
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
