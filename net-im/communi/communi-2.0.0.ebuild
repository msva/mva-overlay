# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from mva overlay; $

EAPI="5"

inherit qt4-r2

DESCRIPTION="A cross-platform IRC framework written with Qt 4"
HOMEPAGE="https://github.com/communi/communi"
SRC_URI="https://github.com/communi/communi/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="icu test"

RDEPEND="dev-qt/qtcore
	dev-libs/uchardet
	icu? ( dev-libs/icu )
	!icu? ( dev-libs/uchardet )"

DEPEND="${RDEPEND}
	test? ( dev-qt/qttest )"

src_prepare() {
	UCHD="${S}"/src/3rdparty/uchardet-0.0.1/uchardet.pri
	echo "CONFIG *= link_pkgconfig" > "$UCHD"
	echo "PKGCONFIG += uchardet" >> "$UCHD"
	qt4-r2_src_prepare
}

src_configure() {
	eqmake4 communi.pro -config no_examples \
		$(use icu || echo "-config no_icu") \
		$(use test || echo "-config no_tests")
}
