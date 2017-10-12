# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NG_MOD_LIST=("ngx_http_rds_csv_filter_module.so")

GITHUB_A="openresty"
GITHUB_PN="rds-csv-nginx-module"
GITHUB_PV="v${PV}"

inherit nginx-module

DESCRIPTION="Output filter, converting drizzle/postgres/whatever output to csv"
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
