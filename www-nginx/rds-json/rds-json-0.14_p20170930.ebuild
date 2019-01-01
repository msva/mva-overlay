# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NG_MOD_LIST=("ngx_http_rds_json_filter_module.so")

#FIXME: GITHUB_A="openresty"
GITHUB_A="cryptofuture"
GITHUB_PN="rds-json-nginx-module"
GITHUB_SHA="de7b08d7830328e10ea9088df4bb1930b2e81ec3"

inherit nginx-module

DESCRIPTION="Output filter, converting drizzle/postgres/whatever output to json"
HOMEPAGE="https://openresty.org/"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# ~x64-macos ~x86-macos ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="
	${CDEPEND}
"
RDEPEND="${DEPEND}"

DOCS=( "${NG_MOD_WD}"/{README.md,valgrind.suppress} )
