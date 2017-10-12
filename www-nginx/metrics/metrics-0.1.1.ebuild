# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NG_MOD_LIST=("ngx_http_metrics_module.so")

GITHUB_A="zenops"
GITHUB_PN="ngx_metrics"
GITHUB_PV="v${PV}"

inherit nginx-module

DESCRIPTION="Responde code metrics and some more"
HOMEPAGE="https://github.com/zenops/ngx_metrics"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# ~x64-macos ~x86-macos ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="
	${CDEPEND}
	www-servers/nginx:mainline[nginx_modules_http_stub_status]
	dev-libs/yajl
"
RDEPEND="${DEPEND}"

DOCS=( "${NG_MOD_WD}"/{README.md,nginx.conf} )

nginx-module-configure() {
	myconf+=("--with-http_stub_status_module")
}
