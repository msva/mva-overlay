# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils

DESCRIPTION="Nice application to work with drumbeats and play in 'Guitar Anti-Hero'"
HOMEPAGE="http://stabyourself.net/rimshot/"
SRC_URI="http://stabyourself.net/dl.php?file=${PN}/${PN}-source.zip -> ${P}.zip"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""
RESTRICT=""

DEPEND=">=games-engines/love-0.8.0:*"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_unpack() {
	default
	#it is only one .love file (but with a crappy name), so we can use asterisk
	mv *.love "${P}.zip"
	unpack "./${P}.zip"
	rm "${P}.zip"
}

src_prepare() {
	# patch to work with love 0.8.0
	sed -r -e 's#(\trequire.*)(.lua)(.*)#\1\3#g' -i main.lua
	default
}

src_install() {
	local dir="/usr/share/games/love/${PN}"
	insinto "${dir}"
	doins -r .
	doins -s scalable "${FILESDIR}/${PN}.svg"
	make_wrapper "${PN}" "love /usr/share/games/love/${PN}"
	make_desktop_entry "${PN}"
}

pkg_postinst() {
	elog "${PN} savegames and configurations are stored in:"
	elog "~/.local/share/love/${PN}/"
}
