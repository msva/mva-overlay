# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

EGIT_REPO_URI="https://github.com/Tox/toxic"

inherit git-r3

DESCRIPTION="A CLI front end for ProjectTox Core"
HOMEPAGE="http://tox.im"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS=""
IUSE="av"

RDEPEND="
	net-libs/tox
	sys-libs/ncurses[unicode]
	av? (
		media-libs/openal
		net-libs/tox[av]
	)
"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -r \
		-e "s@(PREFIX) =.*@\1 = /usr@" \
		-i build/Makefile
}

src_compile() {
	cd build
	emake
}

src_install() {
	cd build
	emake DESTDIR="${D}" install
}
pkg_postinst() {
	elog "DHT node list is available in /usr/share/${PN}/DHTnodes"
}
