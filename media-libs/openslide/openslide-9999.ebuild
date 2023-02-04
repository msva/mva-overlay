# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="C library with simple interface to read virtual slides"
HOMEPAGE="http://openslide.org/"
if [[ "${PV}" == *9999* ]]; then
	inherit git-r3 meson
	EGIT_REPO_URI="https://github.com/openslide/openslide"
else
	SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
	HTML_DOCS=("doc/html/.")
fi
SLOT="0"
LICENSE="LGPL-2.1"

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

src_install() {
	meson_install
	find "${D}" -name "*.la" -type f -delete
	einstalldocs
}
