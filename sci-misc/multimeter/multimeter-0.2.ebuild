# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-info

DESCRIPTION="Data acquisition tool for V&A VA18B and clones (as PeakTech 3375) multimeter"
HOMEPAGE="https://multimeter.schewe.com/"
SRC_URI="https://multimeter.schewe.com/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}"

DOCS=( README )

pkg_setup() {
	CONFIG_CHECK="~USB_SERIAL_SPCP8X5"
	linux-info_pkg_setup
}

src_install() {
	dobin multimeter
}
