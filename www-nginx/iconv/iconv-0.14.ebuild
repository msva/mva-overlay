# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NG_MOD_LIST=("ngx_http_iconv_module.so")

GITHUB_A="calio"
GITHUB_PN="iconv-nginx-module"
GITHUB_PV="v${PV}"

NDK=1

inherit nginx-module

DESCRIPTION="Character conversion nginx module using libiconv"
HOMEPAGE="https://openresty.org/"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# ~x64-macos ~x86-macos ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="
	${CDEPEND}
	virtual/libiconv
"
RDEPEND="${DEPEND}"

DOCS=( "${NG_MOD_WD}"/{README.markdown,valgrind.suppress} )
