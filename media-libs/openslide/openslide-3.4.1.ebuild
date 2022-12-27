# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="C library with simple interface to read virtual slides"
HOMEPAGE="http://openslide.org/"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.xz"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="LGPL-2.1"
RESTRICT="mirror"

IUSE="doc"
DEPEND="
	media-libs/libjpeg-turbo
	media-libs/openjpeg:2
	media-libs/tiff:0
	virtual/libc
	sys-libs/zlib
	>=x11-libs/cairo-1.2
	>=dev-libs/glib-2.12
"
RDEPEND="${DEPEND}"

HTML_DOCS=("doc/html/.")

src_install() {
	default
	find "${D}" -name "*.la" -type f -delete
	use doc && einstalldocs
}
