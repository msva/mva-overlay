# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NG_MOD_LIST=("ngx_http_sticky_module.so")

GITHUB_A="bymaximus"
GITHUB_PN="nginx-sticky-module-ng"
GITHUB_SHA="6470649e0e4738ddd5fbc4c45280189a606c8d4c"

inherit nginx-module

DESCRIPTION="A module to always forward same clients to the same upstreams"
HOMEPAGE="https://github.com/bymaximus/nginx-sticky-module-ng"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# ~x64-macos ~x86-macos ~amd64-linux ~x86-linux"
IUSE=""
#upstream-check" # temp. disabled (requires some work on nginx sources)

DEPEND="
	${CDEPEND}
	dev-libs/openssl:0
"
#	upstream-check? (
#		www-nginx/upstream-check[upstream-sticky]
#		www-servers/nginx[upstream-check]
#	)
RDEPEND="${DEPEND}"

DOCS=( "${NG_MOD_WD}"/README.md )

#nginx-module-prepare() {
#	if use upstream-check; then
#		NG_MOD_DEPS+=("upstream-check")
#		NG_MOD_DEFS+=("NGX_UPSTREAM_CHECK_MODULE")
#	fi
#}
