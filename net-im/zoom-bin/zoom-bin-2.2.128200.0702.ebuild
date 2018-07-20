# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit unpacker

MY_PN=zoom

DESCRIPTION="Video conferencing and web conferencing service"
HOMEPAGE="https://zoom.us"
SRC_URI="
	amd64? ( ${HOMEPAGE}/client/${PV}/${MY_PN}_x86_64.tar.xz -> ${P}_x86_64.tar.xz )
	x86? ( ${HOMEPAGE}/client/${PV}/${MY_PN}_i686.tar.xz -> ${P}_i686.tar.xz )
"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RESTRICT="mirror"

IUSE="pulseaudio gstreamer"

DEPEND=""
RDEPEND="${DEPEND}
	pulseaudio? ( media-sound/pulseaudio )
	gstreamer? ( media-libs/gst-plugins-base )
	dev-db/sqlite
	dev-db/unixODBC
	dev-libs/glib
	dev-libs/nss
	dev-libs/libxslt
	dev-libs/quazip
	dev-qt/qtmultimedia
	dev-qt/qtwebengine
	dev-qt/qtsvg
	media-libs/fontconfig
	media-libs/gstreamer:0.10
	media-libs/gst-plugins-base:0.10
	media-libs/mesa
	x11-libs/libxcb
	x11-libs/libXcomposite
	x11-libs/libXi
	x11-libs/libXrender
"

S="${WORKDIR}/${MY_PN}"

src_prepare() {
	default
	rm -r libQt5* libicu* libfaac* libquazip* libturbojpeg* audio egldeviceintegrations generic iconengines imageformats platforminputcontexts platforms platformthemes Qt QtQml QtQuick QtQuick.2 QtWebChannel QtWebEngine xcbglintegrations
}

src_install() {
	insinto /opt/"${MY_PN}"
	doins -r *
}
