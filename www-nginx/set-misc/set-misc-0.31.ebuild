# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NG_MOD_LIST=("ngx_http_set_misc_module.so")

GITHUB_A="openresty"
GITHUB_PN="${PN}-nginx-module"
GITHUB_PV="v${PV}"
NDK=1

inherit nginx-module

DESCRIPTION="Various set_xxx directives for NgX rewrite module"
HOMEPAGE="https://github.com/openresty/set-misc-nginx-module"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# ~x64-macos ~x86-macos ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="
	${CDEPEND}
"
RDEPEND="${DEPEND}"

DOCS=( "${NG_MOD_WD}"/{README.markdown,valgrind.suppress} )
