# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 toolchain-funcs

DESCRIPTION="Tool for flashing Rockchip devices"
HOMEPAGE="https://sourceforge.net/projects/rkflashtool/"
EGIT_REPO_URI="git://git.code.sf.net/p/${PN}/Git"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="virtual/libusb:1"
DEPEND="${RDEPEND}"

src_prepare(){
	sed -i \
		-e 's/CC	=/CC ?=/' \
		-e 's/CFLAGS	=/CFLAGS ?=/' \
		-e 's/LDFLAGS	=/LDFLAGS ?=/' \
		Makefile || die
	tc-export CC
	default
}

src_install(){
	dodoc README
	dobin ${PN} rkcrc rkflashtool rkmisc rkpad rkparameters rkparametersblock rkunpack rkunsign
}
