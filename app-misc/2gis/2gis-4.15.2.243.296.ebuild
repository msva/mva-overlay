# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from mva overlay; $

EAPI="5"

inherit eutils unpacker versionator

DESCRIPTION="Proprietary freeware multimedia map of several Russian and Ukrainian towns"
HOMEPAGE="http://2gis.ru"
SRC_URI="http://deb.2gis.ru/pool/non-free/2/${PN}/${PN}_$(get_version_component_range 1-3)-0trusty1+shv$(get_version_component_range 4)+r$(get_version_component_range 5)_amd64.deb"

LICENSE="2Gis-ru"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="+data"

RDEPEND="
	!!<=app-misc/2gis-4.0
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtopengl:5
	dev-qt/qtwidgets:5
	dev-qt/qtwebkit:5
	media-libs/mesa
	sys-devel/gcc
	data? ( app-misc/2gis-data )
"
DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_unpack() {
	unpack_deb "${A}"
}

src_prepare() {
	rm -r usr/lib
}

src_install() {
	insinto /
	doins -r usr var
	dobin usr/bin/2gis
}
