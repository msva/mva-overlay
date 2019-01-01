# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NG_MOD_LIST=("ngx_tcp_module.so")

GITHUB_A="dreamcommerce"
GITHUB_PN="nginx_tcp_proxy_module"
GITHUB_SHA="nginx_1.11.9"

NG_MOD_DEFS="NGX_TCP_SSL"

inherit nginx-module

DESCRIPTION="TCP proxy module (with health check and status monitor)"
HOMEPAGE="https://github.com/dreamcommerce/nginx_tcp_proxy_module"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# ~x64-macos ~x86-macos ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="
	${CDEPEND}
	www-servers/nginx:mainline[ssl]
"
RDEPEND="${DEPEND}"

DOCS=( "${NG_MOD_WD}"/README )
