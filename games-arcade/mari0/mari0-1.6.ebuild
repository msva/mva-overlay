# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils games

DESCRIPTION="A 2D SuperMarioBros. + p0rtal clone"
HOMEPAGE="http://stabyourself.net/mari0/"
SRC_URI="http://stabyourself.net/dl.php?file=${PN}-1006/${PN}-source.zip -> ${P}.zip"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT=""

DEPEND=">=games-engines/love-0.8.0"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_unpack() {
	default
	mv "${P/-/_}.love" "${P}.zip"
	unpack "./${P}.zip"
	rm "${P}.zip"
}

src_prepare() {
	default
	epatch_user
}

src_install() {
	insinto "/usr/share/games/love/${P}"
	doins -r .
	games_make_wrapper mari0 "love /usr/share/games/love/${P}"
}
