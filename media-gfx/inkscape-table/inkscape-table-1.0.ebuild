# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils

DESCRIPTION="Table support for inkscape"
HOMEPAGE="http://sourceforge.net/projects/inkscape-tables/"
SRC_URI="mirror://sourceforge/inkscape-tables/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="media-gfx/inkscape"

src_install() {
	cd "${S}/modules" || die "No modules dir"
	insinto /usr/share/inkscape/extensions
	doins *.py *.inx
}
