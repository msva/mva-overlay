# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic

DESCRIPTION="Library for extracting DWARF data from code objects"
HOMEPAGE="https://www.prevanders.net/dwarf.html"
SRC_URI="https://www.prevanders.net/libdwarf-${PV}.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="~dev-libs/libdwarf-${PV}"
RDEPEND="${DEPEND}"

S="${WORKDIR}/dwarf-${PV}/${PN}"

src_install() {
	dobin ${PN}
	doman ${PN}.1
	dolib dwarfdump.conf
}
