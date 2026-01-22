# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

DIST_AUTHOR=TOKUHIROM
inherit perl-module

DESCRIPTION="Binding library for hoedown"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	${RDEPEND}
	dev-perl/File-pushd
	dev-perl/Module-Build
"
