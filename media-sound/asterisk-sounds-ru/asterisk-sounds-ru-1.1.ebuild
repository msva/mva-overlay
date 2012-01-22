# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils

DESCRIPTION="Asterisk's russian sounds from IVR team."
HOMEPAGE="http://ivrvoice.ru/"
SRC_URI="
	wav? ( "http://ivrvoice.ru/downloader/download/file/10"  -> "${PN}"-wav.tar.gz )
	gsm? ( "http://ivrvoice.ru/downloader/download/file/11"  -> "${PN}"-gsm.tar.gz )
	alaw? ( "http://ivrvoice.ru/downloader/download/file/12" -> "${PN}"-alaw.tar.gz )"

KEYWORDS="~x86 ~amd64"

LICENSE="GPL-3"
SLOT="0"
IUSE="+alaw +gsm wav"

DEPEND=">=net-misc/asterisk-1.6.2.0"
RDEPEND="${DEPEND}"

pkg_setup() {
	use wav && (
	ewarn "You choose WAV sounds format. It is quite unusable, and you'll need to convert them to your format."
	ewarn "Most likely, you need only aLaw and/or GSM formats. Use package.use to disable unneeded formats." )
}

src_install() {
	insinto /var/lib/asterisk/sounds
	doins -r *
}
