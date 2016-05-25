# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils

DESCRIPTION="Asterisk's russian sounds. \"Tamara\" pack."
HOMEPAGE="http://asteriskforum.ru/"
SRC_URI="ftp://ftp.dvgu.ru/pub/Network/VoIP/SIP/Asterisk/Russian-Tamara-2.0.2-ulaw.tar.gz"

KEYWORDS="~x86 ~amd64"

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
