# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NG_MOD_LIST=("ngx_http_rrd_graph_module.so")

GITHUB_A="evanmiller"
GITHUB_PN="mod_rrd_graph"
GITHUB_SHA="9b749a2d4b8ae47c313054b5a23b982e9a285c54"

inherit nginx-module

DESCRIPTION="Link RRDtool's graphing facilities directly into nginx"
HOMEPAGE="https://github.com/evanmiller/mod_rrd_graph https://www.nginx.com/resources/wiki/modules/rrd_graph/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# ~x64-macos ~x86-macos ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="
	${CDEPEND}
	>=net-analyzer/rrdtool-1.3.8[graph]
"
RDEPEND="${DEPEND}"

DOCS=( "${NG_MOD_WD}"/README )
