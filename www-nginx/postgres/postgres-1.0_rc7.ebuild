# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

NG_MOD_LIST=("ngx_postgres_module.so")

GITHUB_A="FRiCKLE"
GITHUB_PN="ngx_postgres"
GITHUB_SHA="${PV//_}"

inherit nginx-module

DESCRIPTION="Upstream module for direct commincation with PostgreSQL database"
HOMEPAGE="https://github.com/FRiCKLE/ngx_postgres"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# ~x64-macos ~x86-macos ~amd64-linux ~x86-linux"
IUSE="+threads"

DEPEND="
	${CDEPEND}
	www-servers/nginx:mainline[nginx_modules_http_rewrite,threads=]
	>=dev-db/postgresql-9:*[threads=]
"
RDEPEND="${DEPEND}"

DOCS=( "${NG_MOD_WD}"/{README.md,valgrind.suppress} )
