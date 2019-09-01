# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NG_MOD_LIST=("ngx_http_upstream_fair_module.so")

GITHUB_A="cryptofuture"
GITHUB_PN="nginx-${PN}"
GITHUB_SHA="b5be36f5056e7148a1744629e1626aeb414307b7"

inherit nginx-module

DESCRIPTION="The fair load balancer module"
HOMEPAGE="https://github.com/cryptofuture/nginx-upstream-fair"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# ~x64-macos ~x86-macos ~amd64-linux ~x86-linux"
IUSE="upstream-check"

DEPEND="
	${CDEPEND}
	upstream-check? ( www-nginx/upstream-check[upstream-fair] )
"
RDEPEND="${DEPEND}"

DOCS=( "${NG_MOD_WD}"/README )

nginx-module-prepare() {
	use upstream-check && {
		NG_MOD_DEPS+=("upstream-check")
		NG_MOD_DEFS+=("NGX_HTTP_UPSTREAM_CHECK")
	}
}
