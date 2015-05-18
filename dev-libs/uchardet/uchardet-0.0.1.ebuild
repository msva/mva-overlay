# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from mva overlay; $

EAPI="5"

inherit cmake-utils

DESCRIPTION="C port of Mozilla's Automatic Charset Detection algorithm"
HOMEPAGE="http://code.google.com/p/uchardet/"
SRC_URI="http://uchardet.googlecode.com/files/${P}.tar.gz"

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	cmake-utils_src_install
	use static-libs || find "${ED}" -name '*.a' -exec rm '{}' \; 
}
