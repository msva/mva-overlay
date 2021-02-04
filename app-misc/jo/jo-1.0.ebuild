# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="JSON output from a shell"
HOMEPAGE="https://github.com/jpmens/jo"
SRC_URI="https://github.com/jpmens/jo/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_prepare() {
	default
	eautoreconf
}
