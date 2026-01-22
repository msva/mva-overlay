# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

DESCRIPTION="Table support for inkscape"
HOMEPAGE="https://sourceforge.net/projects/inkscape-tables/"
SRC_URI="https://downloads.sourceforge.net/inkscape-tables/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="media-gfx/inkscape"

src_install() {
	cd "${S}/modules" || die "No modules dir"
	insinto /usr/share/inkscape/extensions
	doins *.py *.inx
}
