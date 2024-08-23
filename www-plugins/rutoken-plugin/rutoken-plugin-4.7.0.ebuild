# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker patches

DESCRIPTION="Browser plugin to work with USB smartcards made under RuToken brand"
HOMEPAGE="https://www.rutoken.ru/support/download/rutoken-plugin/"

BASE_NAME="libnpRutokenPlugin_${PV}-1"
SRC_URI="
	amd64? ( ${BASE_NAME}_amd64.deb )
	x86? ( ${BASE_NAME}_i386.deb )
	arm? ( ${BASE_NAME}_armhf.deb )
	arm64? ( ${BASE_NAME}_arm64.deb )
"

S="${WORKDIR}"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
RESTRICT="fetch mirror strip"

RDEPEND="
	sys-apps/pcsc-lite
"
DEPEND="${RDEPEND}"

QA_PREBUILT="*"
QA_SONAME_NO_SYMLINK="usr/lib32/.* usr/lib64/.* usr/lib/.* opt/aktivco/.*"

pkg_nofetch() {
	eerror "Please, open ${HOMEPAGE} in your browser,"
	eerror "download '${A}' package there (or place an issue on github for me to bump the version),"
	eerror "and place it to ${PORTAGE_ACTUAL_DISTDIR}"
}

src_unpack() {
	unpack_deb ${A}
}

src_prepare() {
	mv usr/share/doc/rutokenplugin usr/share/doc/"${PF}"
	default
}

src_install() {
	insinto /
	doins -r usr etc opt
	exeinto /opt/aktivco/rutokenplugin
	doexe opt/aktivco/rutokenplugin/{librtpkcs11ecp,libnpRutokenPlugin}.so
	doexe opt/aktivco/rutokenplugin/FireWyrmNativeMessageHost
}
