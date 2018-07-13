# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="An IPv4/IPv6 Subnet Calculator"
HOMEPAGE="https://www.uni-due.de/~be0001/subnetcalc/"
SRC_URI="https://www.uni-due.de/~be0001/${PN}/download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="colorgcc geoip"

DEPEND="
	colorgcc? ( dev-util/colorgcc )
	geoip? ( dev-libs/geoip )
"
RDEPEND="
	${DEPEND}
"

src_configure() {
	econf \
		$(use_enable colorgcc) \
		$(use_with   geoip)
#		--without-geoip
}
