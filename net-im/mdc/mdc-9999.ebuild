# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/qutecom/qutecom-2.2_p20110210.ebuild,v 1.9 2012/06/17 01:05:11 chithanh Exp $

EAPI="4"

inherit qt4-r2 subversion eutils

DESCRIPTION="Multi-protocol instant messenger"
HOMEPAGE="http://mdc.ru/"
SRC_URI=""
ESVN_REPO_URI="svn://svn.mdc.ru/client/trunk/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-*" #broken!
IUSE="debug test notify"

RDEPEND="
	>=dev-libs/boost-1.36
	x11-libs/qt-gui
	x11-libs/qt-core
	notify? ( dev-cpp/gtkmm:2.4 x11-libs/libnotify )
"
DEPEND="${RDEPEND}
	test? ( dev-util/cppunit )"

#pkg_setup() {
#	append-ldflags $(no-as-needed)
#}

src_prepare() {
	epatch "${FILESDIR}/${P}-disablenotify.patch"
}

src_configure() {
	eqmake4 -recursive || die
}

src_compile() {
	emake release || die
}

#src_install() {
#	cmake-utils_src_install
#	domenu ${PN}/res/${PN}.desktop || die "domenu failed"
#	doicon ${PN}/res/${PN}_64x64.png || die "doicon failed"
#	ln -fs qutecom/libmediastreamer2.so /usr/$(get_libdir)/libmediastreamer2.so
#}
