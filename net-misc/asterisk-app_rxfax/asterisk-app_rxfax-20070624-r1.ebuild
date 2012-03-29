# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Asterisk applications for sending and receiving faxes"
HOMEPAGE="http://www.soft-switch.org/"
MyPN="${PN/asterisk-/}"
SRC_URI="http://www.soft-switch.org/downloads/snapshots/spandsp/test-apps-asterisk-1.4/${MyPN}.c"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

DEPEND=">=media-libs/spandsp-0.0.4_pre9
	>=net-misc/asterisk-1.4
"

S="${WORKDIR}"

src_unpack() {
	cp "${DISTDIR}/${A}" "$S" || die copy
}

src_compile() {
	gcc $CFLAGS -shared -fPIC -lspandsp -ltiff -o "${MyPN}".{so,c} || die compile
}

src_install() {
	exeinto "/usr/lib/asterisk/modules"
	doexe "${MyPN}.so" || die install
}
