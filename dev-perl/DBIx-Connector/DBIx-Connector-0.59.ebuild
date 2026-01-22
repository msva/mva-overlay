# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

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
