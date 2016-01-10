# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

WX_GTK_VER="2.6"
inherit confutils eutils wxwidgets

BASE_URL="http://www.zoiper.com/downloads/free/linux/communicator/karmic/zoiper-communicator-free"
DESCRIPTION="Free proprietary cross-platform VoIP-client with SIP and IAX support."
SRC_URI="
	x86?   ( alsa? ( "${BASE_URL}-alsa_${PV}-1ubuntu16_i386.deb" )
		 oss?  ( "${BASE_URL}-oss_${PV}-1ubuntu16_i386.deb" )
		 "http://rion-overlay.googlecode.com/files/libavutil_x86.tbz2" )
	amd64? ( alsa? ( "${BASE_URL}-alsa_${PV}-1ubuntu12_amd64.deb" )
		 oss?  ( "${BASE_URL}-oss_${PV}-1ubuntu12_amd64.deb" )
		 "http://rion-overlay.googlecode.com/files/libavutil_amd64.tbz2" )"
HOMEPAGE="http://www.zoiper.com/"
KEYWORDS="~amd64 ~x86"
RESTRICT="strip"

LICENSE="EULA"
SLOT="0"
IUSE="alsa oss"

DEPEND="app-arch/deb2targz
	${RDEPEND}"

pkg_setup() {
	confutils_require_one alsa oss
	wxwidgets_pkg_setup
}

src_unpack() {
	default
	unpack "./data.tar.gz"
}

src_install() {
	cd "${WORKDIR}/usr"

	# Precompiled staff going to /opt.
	PKG_HOME="/opt/${PN}"
	exeinto "${PKG_HOME}/bin"
	doexe "bin/${PN}"

	insinto "${PKG_HOME}"
	doins -r "lib"

	# Skin file for this app.
	insinto "/usr/share/${PN}"
	doins "share/${PN}/Zoiper.zss"
	doicon "share/zoiper-communicator/zoiper48.png"
	make_wrapper "${PN}" "${PKG_HOME}/bin/${PN}" "${PKG_HOME}" "${PKG_HOME}/lib"
	make_desktop_entry "${PN}" "${DESCRIPTION}" "zoiper48"
}
