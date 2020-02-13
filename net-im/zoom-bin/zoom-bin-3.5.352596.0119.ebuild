# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop eutils

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

RESTRICT="mirror strip"

IUSE="pulseaudio gstreamer"

DEPEND=""
RDEPEND="${DEPEND}
	pulseaudio? ( media-sound/pulseaudio )
	gstreamer? ( media-libs/gst-plugins-base )
	dev-libs/glib:2
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtpositioning:5
	dev-qt/qtprintsupport:5
	dev-qt/qtscript:5
	dev-qt/qtwebchannel:5
	dev-qt/qtwebengine:5
	dev-qt/qtwidgets:5
	media-libs/mesa:0
	sys-apps/dbus:0
	sys-apps/util-linux:0
	x11-libs/libX11:0
	x11-libs/libxcb:0
	x11-libs/libXext:0
	x11-libs/libXfixes:0
	x11-libs/libXtst:0
	x11-libs/xcb-util-image:0
	x11-libs/xcb-util-keysyms:0
"

S="${WORKDIR}/${MY_PN}"

QA_PREBUILT="opt/zoom/*"

src_prepare() {
	default
	rm -r libQt5* libicu* libfaac* libquazip* libturbojpeg* audio \
	egldeviceintegrations generic iconengines imageformats \
	platforminputcontexts platforms platformthemes Qt QtQml QtQuick \
	QtQuick.2 QtWebChannel QtWebEngine xcbglintegrations QtWebEngineProcess \
	qtdiag
}

src_install() {
	insinto /opt/"${MY_PN}"
	exeinto /opt/"${MY_PN}"
	doins -r *
	doexe "${MY_PN}"{,.sh,linux} zopen ZoomLauncher
	make_wrapper "${MY_PN}" ./"${MY_PN}" /opt/"${MY_PN}"
	make_desktop_entry "${MY_PN}" "${MY_PN}" headset
}
