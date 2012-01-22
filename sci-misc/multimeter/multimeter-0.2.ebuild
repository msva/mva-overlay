# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils linux-mod

DESCRIPTION="A litte data acquisition tool for the V&A VA18B (and others, e.g. PeakTech 3375) multimeter."
HOMEPAGE="http://multimeter.schewe.com/"
SRC_URI="http://multimeter.schewe.com/${PN}-${PV}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT=""

DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}"

pkg_setup() {
        CONFIG_CHECK="~USB_SERIAL_SPCP8X5"
        linux-mod_pkg_setup
}

src_install() {
	dobin multimeter
	dodoc README
}