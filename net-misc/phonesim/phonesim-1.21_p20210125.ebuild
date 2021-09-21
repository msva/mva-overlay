# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools multilib

DESCRIPTION="Phone Simulator for modem testing (oFono)"
HOMEPAGE="http://ofono.org/"

if [[ "${PF}" = *_p* ]]; then
	MY_SHA="a7c844d45b047b2dae5b0877816c346fce4c47b9"
	SRC_URI="https://git.kernel.org/pub/scm/network/ofono/${PN}.git/snapshot/${PN}-${MY_SHA}.tar.gz"
	S="${WORKDIR}/${PN}-${MY_SHA}"
else
	SRC_URI="https://www.kernel.org/pub/linux/network/ofono/${P}.tar.xz"
fi

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

RDEPEND="net-misc/ofono"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
#	sed -r -i \
#		-e '/PKG_CHECK_MODULES\(QT/{s@Qt([A-Z])@Qt5\1@g}' \
#		-e 's@(MOC=).*@\1moc@' \
#		-e 's@(UIC=).*@\1uic@' \
#		configure.ac || die
	default
	eautoreconf
}
