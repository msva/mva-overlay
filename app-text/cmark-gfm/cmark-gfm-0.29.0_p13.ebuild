# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="GitHub's fork of cmark, a CommonMark parsing and rendering library and program"
HOMEPAGE="https://github.com/github/cmark-gfm"
SRC_URI="https://github.com/github/cmark-gfm/archive/${PV//_p/.gfm.}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0/0.29.0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
IUSE="static-libs"

S="${WORKDIR}/${P/_p/.gfm.}"


#src_prepare() {
#	default
#	cmake_src_prepare
#	sed -r \
#		-e '/install.EXPORT cmark-gfm-extensions/s@lib\$\{LIB_SUFFIX\}/cmake-gfm-extensions@\$\{CMAKE_INSTALL_LIBDIR\}/cmake@' \
#		-i extensions/CMakeLists.txt || die
#}

src_configure() {
	local mycmakeargs=(
		-DCMARK_STATIC=$(usex static-libs)
		-DBUILD_SHARED_LIBS=ON
		-DCMARK_TESTS=OFF # current 3yo release is not compatible with modern pythons, and not needed in non-gentoo repo, actually
		-DCMARK_LIB_FUZZER=OFF # wrong flags
		-DCMARK_FUZZ_QUADRATIC=OFF # wrong flags
	)
	cmake_src_configure
}
