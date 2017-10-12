# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NG_MOD_LIST=("ngx_http_enhanced_memcached_module.so")

GITHUB_A="dreamcommerce"
GITHUB_PN="ngx_http_enhanced_memcached_module"
GITHUB_SHA="nginx_1.11.9"

inherit nginx-module

DESCRIPTION="Enhanced Nginx Memcached Module"
HOMEPAGE="https://github.com/dreamcommerce/ngx_http_enhanced_memcached_module"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# ~x64-macos ~x86-macos ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="
	${CDEPEND}
"
RDEPEND="${DEPEND}"

DOCS=( "${NG_MOD_WD}"/README.markdown )
