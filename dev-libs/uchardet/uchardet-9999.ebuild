# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit cmake-utils git-r3

DESCRIPTION="C port of Mozilla's Automatic Charset Detection algorithm"
HOMEPAGE="https://github.com/BYVoid/uchardet"
EGIT_REPO_URI="https://github.com/BYVoid/uchardet"

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS=""
IUSE="static-libs"

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	cmake-utils_src_install
	use static-libs || find "${ED}" -name '*.a' -exec rm '{}' \; 
}
