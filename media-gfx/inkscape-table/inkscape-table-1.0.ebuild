# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Table support for inkscape"
HOMEPAGE="https://sourceforge.net/projects/inkscape-tables/"
SRC_URI="mirror://sourceforge/inkscape-tables/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="media-gfx/inkscape"

src_install() {
	cd "${S}/modules" || die "No modules dir"
	insinto /usr/share/inkscape/extensions
	doins *.py *.inx
}
