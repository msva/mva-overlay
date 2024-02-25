# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

if [[ "${PV}" =~ "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/dreibh/subnetcalc"
else
	SRC_URI="https://github.com/dreibh/subnetcalc/archive/refs/tags/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${P}"
fi

DESCRIPTION="An IPv4/IPv6 Subnet Calculator"
HOMEPAGE="https://www.nntb.no/~dreibh/subnetcalc/"

LICENSE="GPL-3"
SLOT="0"
IUSE="geoip"

DEPEND="
	geoip? ( dev-libs/geoip )
"
RDEPEND="
	${DEPEND}
"
