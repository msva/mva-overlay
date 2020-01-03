# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

DESCRIPTION="Asterisk's russian sounds. \"Tamara\" pack."
HOMEPAGE="http://asteriskforum.ru/"
SRC_URI="
http://val.bmstu.ru/unix/voip/Russian-Tamara-2.0.2-ulaw.tar.gz
http://nettips.ru/files/asterisk/Russian-Tamara-2.0.2-ulaw.tar.gz
"

KEYWORDS="~amd64 ~x86"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND=">=net-misc/asterisk-1.6.2.0"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack "./Russian-Tamara-2.0.2-ulaw/sounds.tar.gz"
}

src_install() {
	insinto /var/lib/asterisk/sounds
	doins -r sounds/*
}
