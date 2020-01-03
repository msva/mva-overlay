# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NG_MOD_LIST=("ngx_http_push_stream_module.so")

GITHUB_A="wandenberg"
GITHUB_PN="nginx-${PN}-module"

inherit nginx-module

DESCRIPTION="A pure stream http push technology for your Nginx setup"
HOMEPAGE="https://github.com/wandenberg/nginx-push-stream-module"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# ~x64-macos ~x86-macos ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="${CDEPEND}"
RDEPEND="${DEPEND}"

DOCS=( "${NG_MOD_WD}"/README.textile )
