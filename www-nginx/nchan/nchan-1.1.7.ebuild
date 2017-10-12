# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NG_MOD_LIST=("ngx_nchan_module.so")

GITHUB_A="slact"
GITHUB_PV="v${PV}"

inherit nginx-module

DESCRIPTION="Fast multiprocess pub/sub queuing server and proxy for NginX"
HOMEPAGE="https://nchan.io/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# ~x64-macos ~x86-macos ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="
	${CDEPEND}
	dev-libs/hiredis
"
RDEPEND="${DEPEND}"

DOCS=( "${NG_MOD_WD}"/README.md )
