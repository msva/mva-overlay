# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Plugins for 2gis"
HOMEPAGE="https://2gis.ru"
SRC_URI="
	area? ( https://download.2gis.ru/arhives/ComputeAreaPlugin2.zip -> 2GIS_Plugin_ComputeArea.zip )
	goto? ( https://download.2gis.ru/arhives/GoTo.zip -> 2GIS_Plugin_GoTo.zip )
	mapnotes? ( https://download.2gis.ru/arhives/MapNotes.zip -> 2GIS_Plugin_MapNotes.zip )
"

S="${WORKDIR}"

#	gps? ( http://download.2gis.ru/arhives/2GISPlugin_GPS-1.12.0.msi -> 2GIS_Plugin_GPS-1.12.0.7z )
#	photo? ( http://download.2gis.ru/arhives/2GISPlugin_Photo-1.0.4.0.msi -> 2GIS_Plugin_Photo-1.0.4.0.7z )
#	postcode? ( http://safegen.com/files/SafePostCode.msi -> 2GIS_Plugin_SafePostCode.7z )
#	ping? ( http://safegen.com/files/SafePing1001.msi -> 2GIS_Plugin_SafePing-1001.7z )

LICENSE="2Gis-ru"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="area goto mapnotes"
# photo gps postcode ping"

BDEPEND="app-arch/unzip"
RDEPEND="app-misc/2gis"

src_install() {
	insinto /opt/2gis/Plugins/
	doins -r . || die
}
