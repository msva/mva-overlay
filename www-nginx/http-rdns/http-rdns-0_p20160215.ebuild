# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NG_MOD_LIST=("ngx_http_rdns_module.so")

GITHUB_A="dreamcommerce"
GITHUB_PN="nginx-http-rdns"
GITHUB_SHA="a32deecaf1fa4be4bd445c2b770283d20bf61da6"

inherit nginx-module

DESCRIPTION="Nginx HTTP rDNS module"
HOMEPAGE="https://github.com/dreamcommerce/nginx-http-rdns"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# ~x64-macos ~x86-macos ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="
	${CDEPEND}
"
RDEPEND="${DEPEND}"

DOCS=( "${NG_MOD_WD}"/README.md )
