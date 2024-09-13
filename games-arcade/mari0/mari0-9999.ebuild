# Copyright 1999-2024 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop wrapper

DESCRIPTION="A mix from Nintendo's Super Mario Bros and Valve's Portal"
HOMEPAGE="http://stabyourself.net/mari0"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Stabyourself/mari0/"
else
	SRC_URI="https://github.com/Stabyourself/mari0/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi
LICENSE="MIT"
SLOT="0"

RDEPEND="
	>=games-engines/love-0.8.0
	media-libs/devil[gif,png]
"

src_unpack() {
	default
}

src_install() {
	local dir="/usr/share/games/love/${PN}"
	insinto "${dir}"
	doins -r .
	doicon -s scalable "${FILESDIR}/${PN}.svg"
	doicon "${S}/_DO_NOT_INCLUDE/icon.png"
	make_wrapper "${PN}" "love /usr/share/games/love/${P}"
	make_desktop_entry "${PN}"
}

pkg_postinst() {
	elog "${PN} savegames and configurations are stored in:"
	elog "~/.local/share/love/${PN}/"
}
