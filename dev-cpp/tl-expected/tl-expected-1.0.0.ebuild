# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake
if [[ "${PV}" == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/TartanLlama/expected"
else
	SRC_URI="https://github.com/TartanLlama/expected/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~arm64 ~arm"
fi

DESCRIPTION="Guideline Support Library implementation by Microsoft"
HOMEPAGE="https://github.com/TartanLlama/expected"

LICENSE="CC0-1.0"
SLOT="0"
IUSE="test"

# header only library
RDEPEND=""
DEPEND="test? ( dev-cpp/catch:1 )"

PATCHES=("${FILESDIR}/1.0.0-use_system_catch.patch")

src_configure() {
	local mycmakeargs=(
		-DEXPECTED_BUILD_TESTS=$(usex test)
	)
	use test && mycmakeargs+=( -DFORCE_SYSTEM_CATCH=ON )
	cmake_src_configure
}
