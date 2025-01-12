# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker patches

DESCRIPTION="Cryptographic browser plugin for SKB Kontur services"
HOMEPAGE="https://help.kontur.ru/plugin/"

MAGIC="002245"
# 4.7.1.1274 = 002245
# TODO: watch for it, guess pattern
# (migrate to using magic as PV on fail)

SRC_URI="
	amd64? ( https://api.kontur.ru/drive/v1/public/diag/files/kontur.plugin.${MAGIC}.deb )
"
# current, but no version:
# 	amd64? ( https://help.kontur.ru/plugin/dist/kontur.plugin_amd64.deb -> ${P}.deb )
# old:
# 	amd64? ( https://help.kontur.ru/files/kontur.plugin_amd64.${PV}.deb -> ${P}.deb )

S="${WORKDIR}"

LICENSE="EULA"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror"

RDEPEND="
	app-accessibility/at-spi2-core
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

src_unpack() {
	unpack_deb ${A}
}

src_prepare() {
	rm -r opt/kontur.plugin/pkcs11
	# 👆 makes plugin host application segfault.
	# Started somewhere about 4.2
	# Still happens on 4.7.1.1274

	mv usr/share/doc/kontur.plugin usr/share/doc/"${PF}"
	gzip -d usr/share/doc/"${PF}"/changelog.gz
	default
}

src_install() {
	insinto /
	doins -r usr etc opt
	exeinto /opt/kontur.plugin
	doexe opt/kontur.plugin/kontur.plugin.host
	# exeinto /opt/kontur.plugin/pkcs11
	# doexe opt/kontur.plugin/pkcs11/{jcverify,*.so}
}
