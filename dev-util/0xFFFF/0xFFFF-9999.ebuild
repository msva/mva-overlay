# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit git-r3

DESCRIPTION="Open Free Fiasco Firmware Flasher"
HOMEPAGE="https://github.com/pali/0xFFFF"

EGIT_REPO_URI="https://github.com/pali/0xFFFF"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
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
