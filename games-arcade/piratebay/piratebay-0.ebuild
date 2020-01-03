# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

DESCRIPTION="A physics based game made for Devmania 2011 Overnight Contest"
HOMEPAGE="http://gamejams.schattenkind.net/2011/10/pirate-bay.html"
SRC_URI="http://sience.schattenkind.net/devmania/piratebay.love -> ${P}.zip"
LICENSE="ZLIB"
SLOT="0"
# Temporary broken. When I fix it — i'll unmask it
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""
RESTRICT=""

DEPEND=">=games-engines/love-0.8.0:*"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_install() {
	local dir="/usr/share/games/love/${PN}"
	insinto "${dir}"
	doins -r .
	make_wrapper "${PN}" "love /usr/share/games/love/${PN}"
	make_desktop_entry "${PN}"
}

pkg_postinst() {
	elog "${PN} savegames and configurations are stored in:"
	elog "~/.local/share/love/${PN}/"
}
