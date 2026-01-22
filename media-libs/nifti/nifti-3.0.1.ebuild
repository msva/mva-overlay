# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

inherit cmake-multilib

DESCRIPTION="C libraries for NIFTI support"
HOMEPAGE="https://github.com/NIFTI-Imaging/nifti_clib"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/NIFTI-Imaging/nifti_clib"
else
	SRC_URI="https://github.com/NIFTI-Imaging/${PN}_clib/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
	S="${WORKDIR}/${PN}_clib-${PV}"
fi

LICENSE="BSD"
SLOT="0"

RDEPEND="virtual/zlib"
BDEPEND="
	${RDEPEND}
"

src_prepare() {
	cmake_src_prepare
	multilib_copy_sources
}

multilib_src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=OFF
		-DNIFTI_INSTALL_LIBRARY_DIR=$(get_libdir)
	)
	cmake_src_configure
}
