# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

EGIT_REPO_URI="https://github.com/Tox/toxic"

inherit autotools git-2

DESCRIPTION="A CLI front end for ProjectTox Core"
HOMEPAGE="http://tox.im"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	net-im/tox-core
	sys-libs/ncurses[unicode]
	net-libs/libsodium
"
DEPEND="${RDEPEND}"

src_prepare() {
	eautoreconf
}

pkg_postinst() {
        elog "DHT node list is available via https://gist.github.com/Proplex/6124860"
        elog "or in #tox @ irc.freenode.org"
}