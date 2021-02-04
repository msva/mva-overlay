# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils linux-mod

DESCRIPTION="Data acquisition tool for V&A VA18B and clones (as PeakTech 3375) multimeter"
HOMEPAGE="http://multimeter.schewe.com/"
SRC_URI="http://multimeter.schewe.com/${PN}-${PV}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT=""

DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}"

DOCS=( README )

pkg_setup() {
	CONFIG_CHECK="~USB_SERIAL_SPCP8X5"
	linux-mod_pkg_setup
}

src_install() {
	dobin multimeter
}
