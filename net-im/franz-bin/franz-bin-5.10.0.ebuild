# Copyright 2025 mva
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN/-bin/}"
MY_PV="${PV/_beta/-beta.}"
MY_P="${MY_PN}_${MY_PV}"

inherit desktop multilib-build unpacker xdg-utils

DESCRIPTION="Free messaging app for services like WhatsApp, Slack, Messenger and many more"
HOMEPAGE="https://meetfranz.com/"
SRC_URI="https://github.com/meetfranz/${MY_PN}/releases/download/v${MY_PV}/${MY_P}_amd64.deb"

S="${WORKDIR}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="gnome-keyring"

RDEPEND="
	dev-libs/expat:0[${MULTILIB_USEDEP}]
	dev-libs/glib:2[${MULTILIB_USEDEP}]
	dev-libs/nspr:0[${MULTILIB_USEDEP}]
	dev-libs/nss:0[${MULTILIB_USEDEP}]
	media-libs/alsa-lib:0[${MULTILIB_USEDEP}]
	media-libs/fontconfig:1.0[${MULTILIB_USEDEP}]
	media-libs/freetype:2[${MULTILIB_USEDEP}]
	net-misc/curl:0[${MULTILIB_USEDEP}]
	net-print/cups:0[${MULTILIB_USEDEP}]
	sys-apps/dbus:0[${MULTILIB_USEDEP}]
	x11-libs/cairo:0[${MULTILIB_USEDEP}]
	x11-libs/gdk-pixbuf:2[${MULTILIB_USEDEP}]
	x11-libs/gtk+:3[${MULTILIB_USEDEP}]
	x11-libs/libX11:0[${MULTILIB_USEDEP}]
	x11-libs/libxcb:0/1.12[${MULTILIB_USEDEP}]
	x11-libs/libXcomposite:0[${MULTILIB_USEDEP}]
	x11-libs/libXcursor:0[${MULTILIB_USEDEP}]
	x11-libs/libXdamage:0[${MULTILIB_USEDEP}]
	x11-libs/libXext:0[${MULTILIB_USEDEP}]
	x11-libs/libXfixes:0[${MULTILIB_USEDEP}]
	x11-libs/libXi:0[${MULTILIB_USEDEP}]
	x11-libs/libxkbfile:0[${MULTILIB_USEDEP}]
	x11-libs/libXrandr:0[${MULTILIB_USEDEP}]
	x11-libs/libXrender:0[${MULTILIB_USEDEP}]
	x11-libs/libXScrnSaver:0[${MULTILIB_USEDEP}]
	x11-libs/libXtst:0[${MULTILIB_USEDEP}]
	x11-libs/pango:0[${MULTILIB_USEDEP}]
	gnome-keyring? (
		app-crypt/libsecret:0[${MULTILIB_USEDEP}]
	)
"
#	TODO:
#	dev-libs/atk:0[${MULTILIB_USEDEP}]
#	gnome-base/gconf:2[${MULTILIB_USEDEP}]

# QA_PREBUILT="
# 	opt/Franz/franz
# 	opt/Franz/libffmpeg.so
# "
# TODO: maybe remove libffmpeg and replace with ffmpeg-chromium?
# same for libvulkan, libEGL

src_install() {
	insinto /opt
	doins -r opt/.

	# TODO: maybe doexe?
	fperms +x /opt/Franz/franz
	# TODO: maybe make_wrapper?
	dosym ../../opt/Franz/franz usr/bin/franz

	domenu usr/share/applications/franz.desktop

	insinto /usr/share/icons
	doins -r usr/share/icons/.
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
}
