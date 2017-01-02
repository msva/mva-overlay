# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools multilib-minimal

DESCRIPTION="A libhal stub for flashplayer/adobecp, forwarding specific API parts to UDisks"
HOMEPAGE="https://github.com/cshorler/hal-flash"
SRC_URI="https://github.com/cshorler/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEPEND="
	sys-apps/dbus
	!sys-apps/hal
"
RDEPEND="
	${COMMON_DEPEND}
	sys-fs/udisks:0
"
DEPEND="
	${COMMON_DEPEND}
	virtual/pkgconfig
"

DOCS="README"

src_prepare() {
	default
	eautoreconf
	multilib_copy_sources
}

multilib_src_install() {
	default
	prune_libtool_files
}
