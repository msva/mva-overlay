# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NG_MOD_LIST=("ngx_supervisord_module.so")

GITHUB_A="FRiCKLE"
GITHUB_PN="ngx_supervisord"
GITHUB_SHA="2325fd0a898b93c88bd1740b21550c3582507979"

NG_MOD_DEFS=("NGX_HTTP_UPSTREAM_INIT_BUSY_PATCH_VERSION=1")

inherit nginx-module

DESCRIPTION="API to communicate with supervisord and manage (start/stop) backends on-demand"
HOMEPAGE="https://github.com/FRiCKLE/ngx_supervisord"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# ~x64-macos ~x86-macos ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="
	${CDEPEND}
	www-servers/nginx[nginx_modules_http_rdns]
"
RDEPEND="${DEPEND}"

DOCS=( "${NG_MOD_WD}"/README )
