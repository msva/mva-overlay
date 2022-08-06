# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3

DESCRIPTION="An IPv4/IPv6 Subnet Calculator"
HOMEPAGE="https://www.uni-due.de/~be0001/subnetcalc/"
EGIT_REPO_URI="https://github.com/dreibh/subnetcalc"

LICENSE="GPL-3"
SLOT="0"
IUSE="geoip"

DEPEND="
	geoip? ( dev-libs/geoip )
"
RDEPEND="
	${DEPEND}
"
