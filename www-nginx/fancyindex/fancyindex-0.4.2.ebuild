# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NG_MOD_LIST=("ngx_http_fancyindex_module.so")

GITHUB_A="aperezdc"
GITHUB_PN="ngx-fancyindex"
GITHUB_PV="v${PV}"

inherit nginx-module

DESCRIPTION="Fancy indexes module"
HOMEPAGE="https://github.com/aperezdc/ngx-fancyindex"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# ~x64-macos ~x86-macos ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="
	${CDEPEND}
	www-servers/nginx:mainline[nginx_modules_http_addition]
"
RDEPEND="${DEPEND}"

DOCS=( "${NG_MOD_WD}"/README.rst )
