# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit autotools git-r3
EGIT_REPO_URI="https://gitorious.org/dfu-util/dfu-util.git"
SRC_URI=""
KEYWORDS=""

DESCRIPTION="implements the Host (PC) side of the USB DFU (Device Firmware Upgrade) protocol"
HOMEPAGE="http://wiki.openmoko.org/wiki/Dfu-util"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND="virtual/libusb:1"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	if [[ ${PV} == "9999" ]] ; then
		eautoreconf
	fi
	sed -i '/^bin_PROGRAMS/s:dfu-util_static[^ ]*::' src/Makefile.in
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc ChangeLog README TODO
}
