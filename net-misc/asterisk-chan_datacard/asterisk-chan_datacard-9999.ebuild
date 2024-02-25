# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 patches

DESCRIPTION="Datacard channel for Asterisk."
EGIT_REPO_URI="https://github.com/DerArtem/chan_datacard"
HOMEPAGE="http://www.makhutov.org/"

LICENSE="GPL-3"
SLOT="0"

RDEPEND="
	net-misc/asterisk
	dev-libs/libxml2
	sys-libs/ncurses:0
"
DEPEND="${RDEPEND}"

DOCS=( README.txt LICENSE.txt )

src_install() {
	insinto /usr/$(get_libdir)/asterisk/modules
	doins "${PN/*-/}.so"
	insinto /etc/asterisk
	doins etc/datacard.conf
	einstalldocs
}
