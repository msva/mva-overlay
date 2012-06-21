# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from mva overlay $

EAPI="4"

inherit eutils

DESCRIPTION="Plugins for 2gis (pseudo-9999 package)"
HOMEPAGE="http://2gis.ru"
SRC_URI="
area? ( http://download.2gis.ru/arhives/ComputeAreaPlugin2.zip )
goto? ( http://download.2gis.ru/arhives/GoTo.zip )
photo? ( http://download.2gis.ru/arhives/2GISPlugin_Photo-1.0.4.0.zip )
mapnotes? ( http://download.2gis.ru/arhives/MapNotes.zip )
gps? ( http://download.2gis.ru/arhives/2GISPlugin_GPS-1.12.0.zip )
"

LICENSE="2Gis-ru"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="area goto photo mapnotes gps"

DEPEND="app-arch/unzip"
RDEPEND="app-misc/2gis"

S="${WORKDIR}"

src_install() {
	insinto /opt/2gis/Plugins/
	doins -r . || die
}
