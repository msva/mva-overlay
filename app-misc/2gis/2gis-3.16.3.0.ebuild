# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop wrapper

DESCRIPTION="Proprietary freeware multimedia map of several Russian and Ukrainian towns"
HOMEPAGE="https://2gis.ru"
SRC_URI="https://download.2gis.ru/arhives/2GISShell-${PV}.orig.zip"

LICENSE="2Gis-ru"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+data"

DEPEND="
	app-arch/unzip
	media-gfx/imagemagick[png]
	media-gfx/icoutils
"
RDEPEND="
	virtual/wine
	data? ( app-misc/2gis-data )
"

S="${WORKDIR}"

src_install() {
	insinto /opt/${PN}
	doins -r 2gis/3.0/* || die

	bash "${FILESDIR}"/exe2png "2gis/3.0/grym.exe" "2gis_256.png" "256x256"
	for size in 16 22 24 32 36 48 64 72 96 128 192 256; do
		newicon -s ${size} -c apps "${PN}_256".png "${PN}".png
	done

	make_wrapper 2gis "wine grym.exe -nomta" /opt/${PN}
	make_desktop_entry 2gis "2Gis" 2gis "Qt;KDE;Education;Geography" || die
}
