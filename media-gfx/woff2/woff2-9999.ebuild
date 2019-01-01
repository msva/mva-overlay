# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="font compression reference code"
HOMEPAGE="https://github.com/google/woff2"
SRC_URI=""
EGIT_REPO_URI="https://github.com/google/${PN}"

IUSE=""

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""

DEPENDS=""

src_install() {
	dobin ${PN}_*
}
