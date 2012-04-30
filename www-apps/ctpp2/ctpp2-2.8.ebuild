# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from mva overlay $

EAPI="4"

CMAKE_MIN_VERSION="2.8"
inherit cmake-utils

DESCRIPTION="CTPP is a tool separating data processing (business logic) from data presentation."
HOMEPAGE="http://ctpp.havoc.ru/ http://ctpp.havoc.ru/en/"
SRC_URI="http://ctpp.havoc.ru/download/${P}.tar.gz"

LICENSE="BSD"
SLOT="2"
KEYWORDS="~amd64"
IUSE="debug md5 iconv"

DEPEND="iconv? ( virtual/libiconv )
	md5? ( dev-libs/openssl )"

RDEPEND="${DEPEND}"

PATCHES=("${FILESDIR}"/*.patch)
src_configure() {
	mycmakeargs=(
		-DENABLE_OPTIMIZATION=ON \
		-DSKIP_RELINK_RPATH=ON
		$(cmake-utils_use debug DEBUG) \
		$(cmake-utils_use md5 MD5_SUPPORT)\
		$(cmake-utils_use iconv ICONV_SUPPORT)
		)

	cmake-utils_src_configure
}
