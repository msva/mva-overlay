# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua

DESCRIPTION="Prometheus exporter for NginX metrics"
HOMEPAGE="https://github.com/knyar/nginx-lua-prometheus"

LICENSE="MIT"
SLOT="0"

if [[ "${PV}" = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/knyar/nginx-lua-prometheus"
	inherit git-r3
else
	MY_PV="${PV//_p/.}"
	KEYWORDS="~amd64"
	SRC_URI="https://github.com/knyar/nginx-lua-prometheus/archive/refs/tags/${MY_PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/nginx-lua-prometheus-${MY_PV}"
fi

RDEPEND="
	www-servers/nginx:*[nginx_modules_http_lua]
"

DOCS=(README.md)

each_lua_install() {
	insinto "$(lua_get_lmod_dir)"
	doins *.lua
}

src_install() {
	lua_foreach_impl each_lua_install
	einstalldocs
}
