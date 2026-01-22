# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

inherit desktop wrapper

DESCRIPTION="Nice application to work with drumbeats and play in 'Guitar Anti-Hero'"
HOMEPAGE="https://stabyourself.net/rimshot/"
SRC_URI="https://stabyourself.net/dl.php?file=${PN}/${PN}-source.zip -> ${P}.zip"

S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

DEPEND=">=games-engines/love-0.8.0:*"
RDEPEND="${DEPEND}"
BDEPEND="app-arch/unzip"

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
