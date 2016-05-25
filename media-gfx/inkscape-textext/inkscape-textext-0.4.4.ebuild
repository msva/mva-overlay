# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils

MY_PN="${PN##inkscape-}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Scientific typesetting for Inkscape"
HOMEPAGE="http://pav.iki.fi/software/textext/index.html"
SRC_URI="http://pav.iki.fi/software/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="
	media-gfx/pstoedit
	|| (
		media-gfx/pstoedit[plotutils]
		media-gfx/skencil
		media-gfx/pdf2svg
	)
	media-gfx/inkscape
"

src_install() {
	insinto /usr/share/inkscape/extensions
	doins ${MY_PN}.{py,inx}
}
