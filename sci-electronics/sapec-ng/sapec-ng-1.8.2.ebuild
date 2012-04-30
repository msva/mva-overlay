# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from mva overlay $

DESCRIPTION="Sapec-NG is a symbolic analysis program for linear analog circuits"
HOMEPAGE="http://cirlab.det.unifi.it/sapec_ng/"
SRC_URI="http://cirlab.det.unifi.it/sapec_ng/${P}.tar.gz
doc? ( http://cirlab.det.unifi.it/sapec_ng/${P}-doc.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="debug doc"

DEPEND="sys-devel/bison
sys-devel/flex"

RDEPEND=""

src_compile() {
	econf || die "econf failed."
	emake || die "make failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"

	if use doc; then
		dohtml -r "${WORKDIR}"/doc/html/*
	fi
}