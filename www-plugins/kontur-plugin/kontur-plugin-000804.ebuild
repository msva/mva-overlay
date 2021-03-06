# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils unpacker patches

DESCRIPTION="Cryptographic browser plugin for SKB Kontur services"

SRC_URI="
	amd64? ( https://help.kontur.ru/files/kontur.plugin_amd64.${PV}.deb -> ${P}.deb )
"
HOMEPAGE="https://help.kontur.ru/"
LICENSE="EULA"
RESTRICT="mirror"
SLOT="0"
KEYWORDS="~amd64"
# x64-macos"
IUSE=""

RDEPEND="
	dev-libs/atk
	dev-libs/glib
	media-libs/fontconfig
	sys-apps/pcsc-lite
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXft
	x11-libs/libXinerama
	x11-libs/libXrender
	x11-libs/pango
"
DEPEND="${RDEPEND}"

QA_PREBUILT="*"
QA_SONAME_NO_SYMLINK="usr/lib64/.*"

S="${WORKDIR}"

src_unpack() {
	unpack_deb ${A}
}

src_install() {
	insinto /
	doins -r usr etc opt
	exeinto /opt/kontur.plugin
	doexe opt/kontur.plugin/{kontur.plugin.chrome,pkcs11/{jcverify,*.so}}
}
