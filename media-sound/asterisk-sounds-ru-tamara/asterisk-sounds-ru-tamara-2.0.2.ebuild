# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Asterisk's russian sounds. \"Tamara\" pack."
HOMEPAGE="https://asteriskforum.ru/"
SRC_URI="
	https://val.bmstu.ru/unix/voip/Russian-Tamara-2.0.2-ulaw.tar.gz
	https://nettips.ru/files/asterisk/Russian-Tamara-2.0.2-ulaw.tar.gz
"

KEYWORDS="~amd64 ~x86"

LICENSE="GPL-3"
SLOT="0"

DEPEND=">=net-misc/asterisk-1.6.2.0"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_unpack() {
	default
	unpack "./Russian-Tamara-2.0.2-ulaw/sounds.tar.gz"
}

src_install() {
	insinto /var/lib/asterisk/sounds
	doins -r sounds/*
}
