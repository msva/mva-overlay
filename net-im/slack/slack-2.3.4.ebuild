# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit unpacker

DESCRIPTION="A messaging app for teams"
HOMEPAGE="https://slack.com"

SRC_URI="https://downloads.slack-edge.com/linux_releases/${PN}-desktop-${PV}-amd64.deb"

LICENSE="UNKNOWN"
# ^ Literally. Copied from LICENSE file.

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

QA_PREBUILT="usr/lib/slack/*"

RDEPEND="
	dev-libs/atk
	dev-libs/expat
	dev-libs/glib:2
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
	x11-libs/gtk+:2
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
	default
}

src_install() {
	insinto /
	doins -r usr
	exeinto /usr/lib/slack
	doexe usr/lib/slack/slack
}
