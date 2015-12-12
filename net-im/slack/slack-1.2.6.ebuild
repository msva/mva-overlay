# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit unpacker

DESCRIPTION="A messaging app for teams"
HOMEPAGE="https://slack.com"

BASE_URI="https://slack-ssb-updates.global.ssl.fastly.net/linux_releases/${PN}-desktop-${PV}-_arch_placeholder_.deb"

SRC_URI="
	x86? ( ${BASE_URI/_arch_placeholder_/i386} )
	amd64? ( ${BASE_URI/_arch_placeholder_/amd64} )
"

LICENSE="UNKNOWN"
# ^ Literally. Copied from LICENSE file.

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

QA_PREBUILT="usr/share/slack/*"

RDEPEND="
	dev-libs/atk
	dev-libs/expat
	dev-libs/glib
	dev-libs/nspr
	dev-libs/nss
	gnome-base/gconf
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/freetype
	net-print/cups
	sys-apps/dbus
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+
	x11-libs/libnotify
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/pango
	virtual/libc
"
DEPEND="${RDEPEND}"

S=${WORKDIR}

src_unpack() { unpack_deb ${A}; }

src_prepare() {
	rm -r etc usr/share/lintian
	mv usr/share/doc/${PN} usr/share/doc/${P}
}

src_install() {
	insinto /
	doins -r usr
	exeinto /usr/share/slack
	doexe usr/share/slack/slack
}
