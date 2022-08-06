# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="An IPv4/IPv6 Subnet Calculator"
HOMEPAGE="https://www.uni-due.de/~be0001/subnetcalc/"
SRC_URI="https://github.com/dreibh/subnetcalc/archive/refs/tags/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="geoip"

DEPEND="
	geoip? ( dev-libs/geoip )
"
RDEPEND="
	${DEPEND}
"

S="${WORKDIR}/${PN}-${P}"
