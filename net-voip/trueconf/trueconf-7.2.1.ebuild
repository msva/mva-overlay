# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils unpacker

DESCRIPTION="Centralized proprietary VoIP service (supporting custom installations)"
HOMEPAGE="https://trueconf.ru/"
SRC_URI="https://trueconf.ru/download/trueconf-client-amd64.deb -> ${P}.deb"
SLOT=0
KEYWORDS="~amd64"
LICENSE="EULA"

IUSE="gtk"

QA_PRESTRIPPED="opt/*"

RDEPEND="
	app-crypt/mit-krb5:0
	dev-db/sqlite:3
	dev-libs/glib:2
	gtk? (
		dev-libs/atk:0
		dev-libs/libappindicator:2
		dev-libs/libdbusmenu:0
		dev-libs/libindicator:0
		x11-libs/cairo:0
		x11-libs/gdk-pixbuf:2
		x11-libs/gtk+:2
	)
	dev-libs/libxml2:2
	dev-libs/libxslt:0
	dev-libs/nspr:0
	dev-libs/nss:0
	dev-libs/openssl:0
	media-libs/alsa-lib:0
	media-libs/fontconfig:1.0
	media-libs/freetype:2
	media-libs/libjpeg-turbo:0
	media-libs/libpng:1.2
	media-libs/libpng:0/16
	media-libs/libv4l:0/0
	media-libs/mesa:0
	media-libs/speex:0
	media-libs/speexdsp:0
	media-sound/pulseaudio
	net-dns/libidn:0
	net-libs/libssh2:0
	net-misc/curl:0
	net-nds/openldap:0
	sys-apps/dbus:0
	sys-libs/e2fsprogs-libs:0
	sys-libs/libudev-compat:0
	sys-libs/zlib:0
	x11-libs/libICE:0
	x11-libs/libSM:0
	x11-libs/libX11:0
	x11-libs/libxcb:0/1.12
	x11-libs/libXcomposite:0
	x11-libs/libXext:0
	x11-libs/libXi:0
	x11-libs/libXrender:0
	x11-libs/pango:0
"
#	=media-sound/pulseaudio-10*
#	dev-libs/boost
#	dev-qt/qtcore:5
#	dev-qt/qtdbus:5
#	dev-qt/qtdeclarative:5
#	dev-qt/qtgui:5
#	dev-qt/qtmultimedia:5
#	dev-qt/qtnetwork:5
#	dev-qt/qtopengl:5
#	dev-qt/qtpositioning:5
#	dev-qt/qtprintsupport:5
#	dev-qt/qtsensors:5
#	dev-qt/qtsql:5
#	dev-qt/qtwebchannel:5
#	dev-qt/qtwebkit:5
#	dev-qt/qtwidgets:5
DEPEND="
	${RDEPEND}
	dev-util/patchelf
"

S="${WORKDIR}"

src_unpack() {
	unpack_deb ${A}
}

src_prepare() {
	local basedir="opt/${PN}"
	rm "${basedir}"/lib/lib{{ssl,crypto}.so.10,curl.so,jpeg.so.62,png12*}
	dosym ../../../usr/lib/libcrypto.so "${basedir}"/lib/libcrypto.so.10
	dosym ../../../usr/lib/libssl.so "${basedir}"/lib/libssl.so.10

	rm "${basedir}"/plugins/gui/libUnityTray.so
	use gtk || {
		rm "${basedir}"/lib/lib{{app,}indicator*}
		rm "${basedir}"/plugins/{gui/libGnomeTray.so,platformthemes/libqgtk2.so}
	}

	find opt/trueconf/ -type f | while read f; do
		if file "${f}" | grep -q ELF; then
			if patchelf --print-needed "${f}" | grep -qE 'lib(ssl|crypto).so.10'; then
				patchelf --replace-needed libssl.so.10 libssl.so.1.0.0 "${f}"
				patchelf --replace-needed libcrypto.so.10 libcrypto.so.1.0.0 "${f}"
			fi
		fi
	done

	patchelf --set-rpath "${EPREFIX}/opt/${PN}/lib" "opt/${PN}/${PN}-bin"

	default
}

src_install() {
	insinto /
	doins -r opt usr
	exeinto "/opt/${PN}"
	doexe "opt/${PN}/${PN}-bin"
	make_wrapper "${PN}" "${EPREFIX}/opt/${PN}/${PN}-bin" "" "${EPREFIX}/opt/${PN}/lib"
}
