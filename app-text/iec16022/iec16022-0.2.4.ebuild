# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Tool & library to produce 2D barcodes often also referenced as DataMatrix."
HOMEPAGE="http://datenfreihafen.org/projects/iec16022.html"
SRC_URI="http://datenfreihafen.org/~stefan/iec16022/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="static-libs"

DEPEND="
	dev-libs/popt
	sys-libs/zlib
"
RDEPEND="${DEPEND}"

src_configure() {
	econf \
		$(use_enable static-libs static)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README TODO

	use static-libs || rm "${D}"/usr/lib*/*.la
}
