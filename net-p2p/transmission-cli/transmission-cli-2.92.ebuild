# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit multilib

DESCRIPTION="A Fast, Easy and Free BitTorrent client - command line (CLI) version"
HOMEPAGE="http://www.transmissionbt.com/"
MY_PN="transmission"
MY_P="${MY_PN}-${PV}"

SRC_URI="http://download.transmissionbt.com/${MY_PN}/files/${MY_P}.tar.xz"

KEYWORDS="~amd64 ~x86"
IUSE=""

SLOT=0


S="${WORKDIR}/${MY_P}"

src_prepare() {
	eapply_user
	default
}

src_configure() {
	econfargs+=(
		--enable-cli
		--disable-daemon
		--without-gtk
	)
	econf "${econfargs[@]}"
}

src_install() {
	dobin cli/transmission-cli
	doman cli/transmission-cli.1
}

