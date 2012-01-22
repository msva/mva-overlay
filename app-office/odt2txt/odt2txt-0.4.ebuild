# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit eutils

DESCRIPTION="A simple converter from OpenDocument Text to plain text"
HOMEPAGE="http://stosberg.net/odt2txt/"
SRC_URI="http://stosberg.net/odt2txt/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

src_compile() {
	cd "${S}"
	emake
}

src_install() {
	emake install DESTDIR="${D}" PREFIX=/usr
}
