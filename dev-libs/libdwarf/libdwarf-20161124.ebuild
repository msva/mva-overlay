# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic multilib-minimal

DESCRIPTION="Library for extracting DWARF data from code objects"
HOMEPAGE="https://www.prevanders.net/dwarf.html"
SRC_URI="https://www.prevanders.net/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/dwarf-${PV}/${PN}"

src_prepare() {
	append-cflags -fPIC
	default
	multilib_copy_sources
}

multilib_src_configure() {
	econf --enable-shared
}

multilib_src_install() {
	dolib.a libdwarf.a
	dolib.so libdwarf.so

	ln -sf libdwarf.so{,.1}
	dolib.so libdwarf.so.1

	insinto /usr/include

#	doins dwarf.h # Conflict with elfutils
	doins libdwarf.h 

	dodoc NEWS README CHANGES
}
