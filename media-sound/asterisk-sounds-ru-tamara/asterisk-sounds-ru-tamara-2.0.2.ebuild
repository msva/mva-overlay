# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

DESCRIPTION="Asterisk's russian sounds. \"Tamara\" pack."
HOMEPAGE="https://asteriskforum.ru/"
SRC_URI="
	https://val.bmstu.ru/unix/voip/Russian-Tamara-2.0.2-ulaw.tar.gz
	https://nettips.ru/files/asterisk/Russian-Tamara-2.0.2-ulaw.tar.gz
"

S="${WORKDIR}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=net-misc/asterisk-1.6.2.0"
RDEPEND="${DEPEND}"

src_unpack() {
	default
	unpack "./Russian-Tamara-2.0.2-ulaw/sounds.tar.gz"
}

src_install() {
	insinto /var/lib/asterisk/sounds
	doins -r sounds/*
}
