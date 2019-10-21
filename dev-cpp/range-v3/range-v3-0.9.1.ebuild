# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils git-r3

DESCRIPTION="Experimental range library for C++11/14/17"
HOMEPAGE="https://github.com/ericniebler/range-v3"
EGIT_REPO_URI="https://github.com/ericniebler/range-v3"
if [[ "${PV}" != 9999 ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~mips ~x86"
	EGIT_COMMIT="${PV}"
fi

LICENSE="Boost-1.0"
SLOT="0"
IUSE="examples test"

RDEPEND=""
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DRANGE_V3_TESTS=$(usex test)
		-DRANGE_V3_EXAMPLES=$(usex examples)
		-DRANGES_MODULES=yes
		#-DRANGES_ASAN=yes # Address Sanitizer
		#-DRANGES_MSAN=yes # Memory Sanitizer
		-DRANGE_V3_PERF=no
	)
	# maybe "if building with clang then" -DRANGES_LLVM_POLLY=yes
	cmake-utils_src_configure
}
