# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils qmake-utils

DESCRIPTION="The free and open source and cross platform screen sharing software"
HOMEPAGE="https://github.com/ArsenArsen/KShare"

if [[ "${PV}" == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ArsenArsen/KShare"
	KEYWORDS=""
else
	QHOTKEY_SHA="91f3542b5d11a6df8e5735ef03f336c399ceab93"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
	SRC_URI="
		https://github.com/ArsenArsen/KShare/archive/v${PV}.tar.gz -> ${P}.tar.gz
		https://github.com/Skycoder42/QHotkey/archive/${QHOTKEY_SHA}.tar.gz -> ${PN}_qhotkey-${PV}.tar.gz
	"
	S="${WORKDIR}/KShare-${PV}"
fi

LICENSE="MIT"
SLOT="0"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	media-video/ffmpeg:0
	x11-libs/libX11:0
	x11-libs/libxcb:0
"
DEPEND="${RDEPEND}"

src_prepare() {
	if [[ "${PV}" != 9999  ]]; then
		# Yup, dirty hack. Suggest your way.
		rmdir QHotkey
		mv ../QHotkey* QHotkey
	fi
	default
}

src_configure() {
	eqmake5
}

src_install() {
	newbin "KShare" "${PN}"
	newicon -s scalable "icons/icon.svg" "${PN}.svg"
	newicon -s 512 "icons/icon.png" "${PN}.png"
	make_desktop_entry "${PN}" "KShare" "${PN}" "Qt;Utility;Graphics;"
}
