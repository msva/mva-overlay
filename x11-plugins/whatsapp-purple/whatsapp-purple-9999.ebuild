# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Whatsapp plugin for libpurple (Pidgin)"
HOMEPAGE="https://www.davidgf.net/2013/09/15/whatsapp_purple/index.html"

LICENSE="GPL-2"
SLOT="0"

EGIT_REPO_URI="https://github.com/davidgfnet/whatsapp-purple.git"

DEPEND="
	net-im/pidgin
	media-libs/freeimage
"
RDEPEND="${DEPEND}"

pkg_setup() {
	ewarn "WhatsApp upstream constantly brakes alternative clients,"
	ewarn "so this package most probably will not work as expected"
}
