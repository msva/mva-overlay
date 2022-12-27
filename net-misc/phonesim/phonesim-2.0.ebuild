# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Phone Simulator for modem testing (oFono)"
HOMEPAGE="http://ofono.org/"

if [[ "${PF}" = *_p* ]]; then
	MY_SHA="" # FILL-ME
	SRC_URI="https://git.kernel.org/pub/scm/network/ofono/${PN}.git/snapshot/${PN}-${MY_SHA}.tar.gz"
	S="${WORKDIR}/${PN}-${MY_SHA}"
else
	SRC_URI="https://www.kernel.org/pub/linux/network/ofono/${P}.tar.xz"
fi

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND="net-misc/ofono"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	eautoreconf
}
