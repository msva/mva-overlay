# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

DESCRIPTION="Tools for reading and writing Data Matrix barcodes"
HOMEPAGE="http://www.libdmtx.org/"
SRC_URI="mirror://sourceforge/libdmtx/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="
	>=media-gfx/imagemagick-6.2.4
	>=media-libs/libdmtx-0.7.0
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"
