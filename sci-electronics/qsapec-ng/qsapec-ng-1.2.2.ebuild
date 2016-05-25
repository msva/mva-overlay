# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit cmake-utils qt4-r2

DESCRIPTION="Qt based GUI for sapec-ng (electric circuit analizys program)"
LICENSE="GPL-3"
HOMEPAGE="http://qsapecng.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN/-/}/files/QSapecNG-${PV}-source.tar.gz"

KEYWORDS="~amd64 ~x86"
IUSE="doc"
SLOT="0"

RDEPEND="
	dev-qt/qtgui:4
	sci-electronics/sapec-ng
	x11-libs/qwt:5
"

DEPEND="
	${RDEPEND}
	>=dev-libs/boost-1.41.0
	>=dev-util/cmake-2.6
	doc? ( app-doc/doxygen )
"

S="${WORKDIR}/QSapecNG-${PV}-source"
DOCS=( README AUTHOR TODO )

src_configure() {
	cmake-utils_src_configure
}

src_install() {
	if use doc; then
		doxygen doxy.cfg || die "Generating documentation failed"
		HTML_DOCS=( doc/html/. )
	fi

	cmake-utils_src_install
}
