# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils git-r3

DESCRIPTION="Experimental range library for C++11/14/17"
HOMEPAGE="https://github.com/ericniebler/range-v3"
EGIT_REPO_URI="https://github.com/ericniebler/range-v3"
EGIT_COMMIT="0.3.0"
KEYWORDS="~x86 ~amd64 ~arm ~arm64 ~mips"

LICENSE="Boost-1.0"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"
