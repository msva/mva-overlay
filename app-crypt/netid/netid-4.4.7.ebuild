# Copyright 2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Net iD PKI client software from SecMaker"
HOMEPAGE="http://www.secmaker.com/menu.do?menuid=85002"
SRC_URI="https://cve.trust.telia.com/TeliaEleg/iidsetup.tar.gz"

LICENSE="netid"
SLOT="0"
KEYWORDS="-alpha -amd64 -hppa -ia64 -ppc -ppc64 -sparc ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"
S="${WORKDIR}/iidsetup"

src_install() {
	SOLIBS="iid iidp11 iidgui"
	for so in ${SOLIBS}; do
		dolib.so "lib${so}.so.${PV}"
		dosym "lib${so}.so.${PV}" "/usr/$(get_libdir)/lib${so}.so"
	done

	exeinto /usr/bin
	newexe "iid.${PV}" iid

	insinto /etc/iid
	doins iid.conf iid.ico
	doins iidxcard.bmp iidxpos.bmp iidxsith.bmp iidxtel.bmp

	exeinto /usr/$(get_libdir)/nsbrowser/plugins
	insinto /usr/$(get_libdir)/nsbrowser/plugins
	doexe "libiidplg.so.${PV}"
	doins npiidplg.xpt

	dodoc license.txt
	dohtml pkcs11.html
}
