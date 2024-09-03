# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop wrapper

DESCRIPTION="Standalone client for Mikrotik routers"
HOMEPAGE="https://mikrotik.com/"
MY_PN="WinBox"
SRC_URI="https://download.mikrotik.com/routeros/${PN}/${PV//_}/${MY_PN}_Linux.zip"

S="${WORKDIR}"

LICENSE="EULA"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	media-libs/fontconfig
	media-libs/freetype
	media-libs/libglvnd
	sys-libs/zlib
	x11-libs/libxcb
	x11-libs/libxkbcommon
	x11-libs/xcb-util-image
	x11-libs/xcb-util-keysyms
	x11-libs/xcb-util-renderutil
	x11-libs/xcb-util-wm
"
DEPEND="app-arch/unzip"

src_install() {
	# TODO: bundle old libxcb as it doesn't work with current
	local instdir="/opt/${PN}"
	insinto "${instdir}"
	doins -r assets
	exeinto "${instdir}"
	doexe "${MY_PN}"
	make_wrapper "${PN}" "./${MY_PN}" "${instdir}"
	make_desktop_entry "${PN}" "${MY_PN}" "${PN}" # "/opt/${PN}/lib"
}
