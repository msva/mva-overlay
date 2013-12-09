# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

if [[ $PV = *9999* ]]; then
	scm_eclass=git-2
	EGIT_REPO_URI="
				git://people.freedesktop.org/~dvdhrm/${PN}
				git://github.com/dvdhrm/${PN}.git"
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="http://www.freedesktop.org/software/${PN}/releases/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
fi

inherit eutils autotools flag-o-matic ${scm_eclass}

DESCRIPTION="A state machine for DEC VT100-VT520 compatible terminal emulators."
HOMEPAGE="http://www.freedesktop.org/wiki/Software/kmscon"

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
