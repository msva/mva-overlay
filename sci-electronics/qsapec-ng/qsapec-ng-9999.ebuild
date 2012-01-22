# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit cmake-utils qt4-r2

DESCRIPTION="Qt based GUI for sapec-ng (electric circuit analizys program)"
LICENSE="GPL-3"
HOMEPAGE="http://qsapecng.sourceforge.net/"

SRC_URI=""
ESVN_REPO_URI="https://qsapecng.svn.sourceforge.net/svnroot/qsapecng/trunk"

KEYWORDS="~x86 ~amd64"
IUSE="doc"
SLOT="0"

RDEPEND="x11-libs/qt-gui:4
	sci-electronics/sapec-ng
	>=x11-libs/qwt-5.1.2
"
#qt-core should arrive with qt-gui deps.

DEPEND="${RDEPEND}
	>=dev-libs/boost-1.41.0
	>=dev-util/cmake-2.6
	doc? ( app-doc/doxygen )
"

S="${WORKDIR}/QSapecNG-${PV}-source"
DOCS=( "${S}/README" "${S}/AUTHOR" "${S}/TODO" )

src_configure() {
	cmake-utils_src_configure
}

src_install() {
	if use doc; then
		cd "${S}"
		doxygen doxy.cfg || die "Generating documentation failed"
		HTML_DOCS=( "${S}/doc/html/*" )
	fi

	cmake-utils_src_install
}