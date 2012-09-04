# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils toolchain-funcs

DESCRIPTION="barcode generator"
HOMEPAGE="http://www.gnu.org/software/barcode/"
SRC_URI="mirror://gnu/barcode/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE=""

DEPEND="app-text/libpaper"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch \
		"${FILESDIR}/${PV}-info.patch" \
		"${FILESDIR}/${PV}-build-shared.patch"

	sed -i \
		-e 's:/info:/share/info:' \
		-e 's:/man/:/share/man/:' \
		Makefile.in || die "sed failed"
}

src_configure() {
	tc-export CC
	default
}

src_install() {
	emake install prefix="${D}/usr" LIBDIR="\$(prefix)/$(get_libdir)" || die "emake install failed"
	dodoc ChangeLog README TODO doc/barcode.{pdf,ps}
}
