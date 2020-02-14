# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake
if [[ "${PV}" == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/TartanLlama/expected"
else
	if [[ "${PV}" = *_pre* ]]; then
		MY_PV="1d9c5d8c0da84b8ddc54bd3d90d632eec95c1f13"
	else
		MY_PV="v${PV}"
	fi
	SRC_URI="https://github.com/TartanLlama/expected/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~arm64 ~arm"
	S="${WORKDIR}/${PN##tl-}-${MY_PV}"
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
