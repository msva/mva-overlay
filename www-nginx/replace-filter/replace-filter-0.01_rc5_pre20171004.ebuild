# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

NG_MOD_LIST=("ngx_http_replace_filter_module.so")

GITHUB_A="openresty"
GITHUB_PN="replace-filter-nginx-module"
GITHUB_SHA="8f9d11940c32ca273607ecf895426d5081374150"

inherit nginx-module

DESCRIPTION="Streaming regular expression replacement in response bodies"
HOMEPAGE="https://openresty.org/"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# ~x64-macos ~x86-macos ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="
	${CDEPEND}
	dev-libs/sregex
"
RDEPEND="${DEPEND}"

DOCS=( "${NG_MOD_WD}"/{README.markdown,valgrind.suppress} )
