# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

MY_SHA="3d56ba9e7f2d61fd8c9c2a7715b46fde38c00123"

DESCRIPTION="Guideline Support Library implementation by Microsoft"
HOMEPAGE="https://github.com/Microsoft/GSL"
SRC_URI="https://github.com/Microsoft/GSL/archive/${MY_SHA:-v${PV}}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/GSL-${MY_SHA:-${PV}}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~mips ~x86"
# ~arm ~arm64
# ^ catch
IUSE="test"

# header only library
RDEPEND=""
DEPEND="test? ( dev-cpp/catch:1 )"

PATCHES=(
	"${FILESDIR}/${PN}-1.0.0-use_system_catch-636828.patch"
	"${FILESDIR}/${PN}-1.0.0-disable_Werror-644042.patch"
)

src_configure() {
	local mycmakeargs=(
		-DGSL_TEST=$(usex test)
	)
	use test && mycmakeargs+=( -DFORCE_SYSTEM_CATCH=ON )
	cmake-utils_src_configure
}
