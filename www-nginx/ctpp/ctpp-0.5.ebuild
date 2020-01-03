# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NG_MOD_LIST=("ngx_http_ctpp2_module.so")
NG_MOD_NAME="ngx_ctpp2"
inherit nginx-module

SRC_URI="http://dl.vbart.ru/ngx-ctpp/ngx_ctpp2-${PV}.tar.gz -> nginx.${P}.tar.gz"

DESCRIPTION="CT++ templater integration Module"
HOMEPAGE="http://ngx-ctpp.vbart.ru/"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# ~x64-macos ~x86-macos ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="
	${CDEPEND}
	www-apps/ctpp2
	virtual/libstdc++
"
RDEPEND="${DEPEND}"

DOCS=( "${NG_MOD_WD}"/README )
