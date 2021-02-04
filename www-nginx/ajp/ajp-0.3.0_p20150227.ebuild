# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

NG_MOD_LIST=("ngx_ajp_module.so")

GITHUB_A="yaoweibin"
GITHUB_PN="nginx_ajp_module"
GITHUB_SHA="bf6cd93f2098b59260de8d494f0f4b1f11a84627"

inherit nginx-module

DESCRIPTION="Support for direct proxying AJP protocol"
HOMEPAGE="https://github.com/yaoweibin/nginx_ajp_module"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# ~x64-macos ~x86-macos ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="
	${CDEPEND}
"
RDEPEND="${DEPEND}"

DOCS=( "${NG_MOD_WD}"/README{.{markdown,wiki},} )
