# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NG_MOD_LIST=("ngx_http_modsecurity_module.so")

GITHUB_A="SpiderLabs"
GITHUB_PN="ModSecurity-nginx"
GITHUB_SHA="a2a5858d249222938c2f5e48087a922c63d7f9d8"

inherit nginx-module

DESCRIPTION="ModSecurity v3 Nginx Connector"
HOMEPAGE="https://modsecurity.org/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# ~x64-macos ~x86-macos ~amd64-linux ~x86-linux"
IUSE="systemtap"

DEPEND="
	${CDEPEND}
	>=www-apps/modsecurity-3
"
RDEPEND="${DEPEND}"

DOCS=( "${NG_MOD_WD}"/README.md )

nginx-module-install() {
	use systemtap && (
		insinto /usr/share/systemtap/tapset
		doins ngx-modsec.stp
	)
}
