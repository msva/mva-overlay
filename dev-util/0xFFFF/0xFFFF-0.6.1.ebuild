# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

DESCRIPTION="Open Free Fiasco Firmware Flasher"
HOMEPAGE="https://github.com/pali/0xFFFF"
SRC_URI="https://github.com/pali/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="
	sys-devel/make
	virtual/libusb:1
"
RDEPEND="
	virtual/libusb:1
"

src_prepare() {
	sed -r \
		-e 's@^(PREFIX).*@\1=/usr@' \
		-i src/Makefile
	default
}
