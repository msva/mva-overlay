# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils autotools flag-o-matic ${scm_eclass}

DESCRIPTION="A state machine for DEC VT100-VT520 compatible terminal emulators."
HOMEPAGE="https://www.freedesktop.org/wiki/Software/kmscon"

SRC_URI="https://www.freedesktop.org/software/kmscon/releases/${P}.tar.xz"
KEYWORDS="~amd64 ~x86"

LICENSE="MIT LGPL-2.1 BSD-2"
SLOT="0"
IUSE="debug +optimizations static-libs test"

COMMON_DEPEND="
	dev-libs/glib:2
"
RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# kmscon sets -ffast-math unconditionally
	strip-flags

	# xkbcommon not in portage
	econf \
		$(use_enable static-libs static) \
		$(use_enable debug) \
		$(use_enable optimizations) \
		$(use_enable test)
}

src_install() {
	emake DESTDIR="${D}" install
}
