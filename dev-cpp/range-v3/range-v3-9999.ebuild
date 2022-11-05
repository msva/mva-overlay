# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3

DESCRIPTION="Range library for C++14/17/20, basis for C++20's std::ranges"
HOMEPAGE="https://github.com/ericniebler/range-v3"
EGIT_REPO_URI="https://github.com/ericniebler/range-v3"
EGIT_COMMIT="0487cca29e352e8f16bbd91fda38e76e39a0ed28"
#SRC_URI="https://github.com/ericniebler/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Boost-1.0"
SLOT="0"

src_prepare() {
	sed -i -e '/Werror/d' -e '/Wextra/d' -e '/Wall/d' cmake/ranges_flags.cmake || die
	sed -i -e "s@lib/cmake@"$(get_libdir)"/cmake@g" CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	mycmakeargs=(
		-DRANGES_DEBUG_INFO=OFF
		# -DRANGES_DEEP_STL_INTEGRATION=ON
		-DRANGE_V3_EXAMPLES=OFF
		-DRANGE_V3_HEADER_CHECKS=OFF
		-DRANGE_V3_PERF=OFF
		-DRANGE_V3_TESTS=OFF
		-DRANGES_BUILD_CALENDAR_EXAMPLE=OFF
		-DRANGES_NATIVE=OFF
		#TODO: clang support + -DRANGES_MODULES=yes
	)
	cmake_src_configure
}
