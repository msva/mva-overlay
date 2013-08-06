# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from mva overlay $

EAPI="5"

inherit eutils

DESCRIPTION="Proprietary freeware multimedia map of several Russian and Ukrainian towns"
HOMEPAGE="http://2gis.ru"
SRC_URI="http://download.2gis.ru/arhives/2GISShell-${PV}.orig.zip"

LICENSE="2Gis-ru"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="+data"

DEPEND="
	app-arch/unzip
	media-gfx/imagemagick
	media-gfx/icoutils
"
RDEPEND="
	app-emulation/wine
	data? ( app-misc/2gis-data )
"

S="${WORKDIR}"

src_install() {
	insinto /opt/${PN}
	doins -r 2gis/3.0/* || die

	bash "${FILESDIR}"/exe2png "2gis/3.0/grym.exe" "2gis_256.png" "256x256"
	for path in $(find /usr/share/icons/hicolor -maxdepth 1 -type d -iname '[0-9]*x[0-9]*'); do
		size=$(basename "${path}")
		convert 2gis_256.png -resize "${size}" 2gis.png
		insinto "${path}"/apps
		doins 2gis.png
	done

	make_wrapper 2gis "wine grym.exe -nomta" /opt/${PN}
	make_desktop_entry 2gis "2Gis" 2gis "Qt;KDE;Education;Geography" || die
}
