# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker patches

DESCRIPTION="System diagnostic browser plugin for SKB Kontur services"

HOMEPAGE="https://help.kontur.ru/"
SRC_URI="
	amd64? ( https://api.kontur.ru/drive/v1/public/diag/files/diag.plugin_amd64.${PV}.deb -> ${P}.deb )
"
# x64-macos? ( https://help.kontur.ru/files/diag.plugin-3.1.0.209.000837.pkg )
# amd64? ( https://help.kontur.ru/files/diag.plugin_amd64.${PV}.deb -> ${P}.deb )
# https://help.kontur.ru/files/diag.plugin-3.1.0.210-1.x86_64.000865.rpm

S="${WORKDIR}"

LICENSE="EULA"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror strip"
# x64-macos"

RDEPEND="
	app-accessibility/at-spi2-core
	dev-libs/glib
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3
	x11-libs/pango
"
DEPEND="${RDEPEND}"

QA_PREBUILT="*"
QA_SONAME_NO_SYMLINK="usr/lib64/.*"

src_unpack() {
	unpack_deb ${A}
}

src_install() {
	insinto /
	doins -r usr etc opt
	exeinto /opt/diag.plugin
	doexe opt/diag.plugin/{Diag.Plugin.nc,nchost-askpass}
}
