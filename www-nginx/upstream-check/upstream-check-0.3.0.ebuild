# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NG_MOD_LIST=("ngx_http_upstream_check_module.so")

GITHUB_A="yaoweibin"
GITHUB_PN="nginx_upstream_check_module"
GITHUB_PV="v${PV}"

inherit nginx-module

DESCRIPTION="Upstream health check and status report"
HOMEPAGE="https://github.com/yaoweibin/nginx_upstream_check_module"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# ~x64-macos ~x86-macos ~amd64-linux ~x86-linux"
NG_UPSTREAMS=(
	fair
	dyups
#	sticky
#	roundrobin
)

IUSE="${NG_UPSTREAMS[@]/#/upstream-}"

REQUIRED_USE="|| ( ${IUSE} )"

DEPEND="
	${CDEPEND}
	upstream-dyups?      ( www-nginx/upstream-dyups )
"
#	upstream-roundrobin? ( www-servers/nginx[upstream-check] )
RDEPEND="${DEPEND}"

PDEPEND="
	upstream-fair?   ( www-nginx/upstream-fair[upstream-check] )
"
#	upstream-sticky? ( www-nginx/upstream-sticky[upstream-check] )

DOCS=( "${NG_MOD_WD}"/README )

nginx-module-prepare() {
	rm config || die "can't remove old config"
	cp "${FILESDIR}/config" config || die "can't replace config"
	if use upstream-dyups; then
		NG_MOD_DEPS+=("upstream-dyups")
		NG_MOD_DEFS+=("NGX_DYUPS")
	fi
}

nginx-module-install() {
	ng_dohdr ngx_http_upstream_check_module.h
}
