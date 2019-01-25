# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

MY_P="beta1"
# Upstream change strange version numeration: 2.4 = beta1, 2.5 (future release) = beta2...

DESCRIPTION="A nice 2D Snake game (like on Tetris)"
HOMEPAGE="http://snayke.net/ https://love2d.org/forums/viewtopic.php?f=5&t=2841"
#SRC_URI="http://snayke.net/downloads/snayke_${MY_P}.love -> ${P}.zip"
# ^ unavailable on the internets ATM
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
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
