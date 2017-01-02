# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="C library with simple interface to read virtual slides"
HOMEPAGE="http://openslide.org/"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.xz"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="LGPL-2.1"
RESTRICT="mirror"

IUSE="doc"
DEPEND="
	media-libs/jpeg:0
	media-libs/openjpeg:2
	media-libs/tiff:0
	virtual/libc
	sys-libs/zlib
	>=x11-libs/cairo-1.2
	>=dev-libs/glib-2.12
"
RDEPEND="${DEPEND}"

#src_configure() {
#	econf
#}
#
#src_compile() {
#	emake || die "Make failed"
#}
#

# TODO: rewrite to default+"fixlafiles"+install_docs
src_install() {
	emake DESTDIR="${D}" install || die
	find "${D}" -name "*.la" -delete
	use doc && dohtml -r "${S}/doc/html/"
}
