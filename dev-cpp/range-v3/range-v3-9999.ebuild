# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils git-r3

DESCRIPTION="Experimental range library for C++11/14/17"
HOMEPAGE="https://github.com/ericniebler/range-v3"
EGIT_REPO_URI="https://github.com/ericniebler/range-v3"
KEYWORDS=""

LICENSE="Boost-1.0"
SLOT="0"
IUSE="-examples -test"

RDEPEND=""
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
		-DRANGE_V3_TESTS=$(usex test)
		-DRANGE_V3_EXAMPLES=$(usex examples)
		-DRANGE_V3_PERF=no
	)
	cmake-utils_src_configure
}
