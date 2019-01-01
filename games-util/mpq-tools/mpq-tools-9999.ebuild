# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 autotools

DESCRIPTION="utilities for manipulating MPQ archives used in Blizzard games"
HOMEPAGE="https://libmpq.org/"
EGIT_REPO_URI="https://github.com/msva/${PN}"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	games-util/libmpq
"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	eautoreconf
}
