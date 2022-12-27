# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ARISTOTLE
inherit perl-module

DESCRIPTION="Fast, safe DBI connection and transaction management"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	${RDEPEND}
	dev-perl/Module-Build
"
