# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools git-r3

DESCRIPTION="JSON output from a shell"
HOMEPAGE="https://github.com/jpmens/jo"
EGIT_REPO_URI="https://github.com/jpmens/jo.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND=""

src_prepare() {
	default
	eautoreconf
}
