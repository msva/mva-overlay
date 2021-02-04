# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-multilib git-r3

EGIT_REPO_URI="https://github.com/${PN}/${PN}-c.git"
KEYWORDS=""

DESCRIPTION="MessagePack is a binary-based efficient data interchange format"
HOMEPAGE="http://msgpack.org/ https://github.com/msgpack/msgpack-c/"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="+cxx +cxx11 boost test examples"
# static-libs

DEPEND="
	boost? ( dev-libs/boost )
	test? (
		>=dev-cpp/gtest-1.6.0-r2[${MULTILIB_USEDEP}]
		sys-libs/zlib[${MULTILIB_USEDEP}]
	)
"

DOCS=( CHANGELOG.md QUICKSTART-C.md QUICKSTART-CPP.md README.md )

use_onoff() {
	usex "${1}" "ON" "OFF"
}

multilib_src_configure() {
	local bit="OFF";
	if use x86 || use arm || use mips || ! multilib_is_native_abi; then
		# not sure if applies to non-x86 32bit arches. Need tests.
		bit="ON";
	fi
	local mycmakeargs=(
		-DMSGPACK_32BIT="${bit}"
		-DMSGPACK_BOOST=$(use_onoff boost)
		-DMSGPACK_BUILD_EXAMPLES=$(use_onoff examples)
		-DMSGPACK_BUILD_TESTS=$(use_onoff test)
		-DMSGPACK_CXX11=$(use_onoff cxx11)
		-DMSGPACK_ENABLE_CXX=$(use_onoff cxx)
		#-DMSGPACK_ENABLE_SHARED=$(usex static-libs OFF ON)
	)
	cmake-utils_src_configure
}
