# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils unpacker versionator multilib

magic32=15
magic64=339

MY_PV="$(get_version_component_range 1-3)"
MY_PBV=$(get_version_component_range 4)

DESCRIPTION="Proprietary freeware multimedia map of several Russian and Ukrainian towns"
HOMEPAGE="http://2gis.ru"
SRC_URI="
	x86? ( http://deb.2gis.ru/pool/non-free/2/${PN}/${PN}_${MY_PV}-0trusty1+shv${MY_PBV}+r${magic32}_i386.deb )
	amd64? ( http://deb.2gis.ru/pool/non-free/2/${PN}/${PN}_${MY_PV}-0trusty1+shv${MY_PBV}+r${magic64}_amd64.deb )
"

LICENSE="2Gis-ru"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="+data"

RDEPEND="
	!!<=app-misc/2gis-4.0
	!app-misc/2gis-data
	!app-misc/2gis-plugins
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtopengl:5
	dev-qt/qtwidgets:5
	dev-qt/qtwebkit:5
	media-libs/mesa
"
#	data? ( app-misc/2gis-data )
DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_unpack() {
	unpack_deb ${A}
}

src_prepare() {
#	mkdir usr/$(get_libdir)_n/2GIS/v4/lib/ -p
#	mv usr/lib/2GIS/v4/lib/libz.so.1 usr/$(get_libdir)_n/2GIS/v4/lib/libz.so.1
#	mv usr/lib/2GIS/v4/lib/libpng12.so.0 usr/$(get_libdir)_n/2GIS/v4/lib/libpng12.so.0
	rm -r usr/lib
#	mv usr/$(get_libdir)_n usr/$(get_libdir)
#	rm -r var/cache
	default
}

src_install() {
	insinto /
	doins -r usr var
	dobin usr/bin/2gis
}
