# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

inherit cmake-multilib git-r3

EGIT_REPO_URI="https://github.com/${PN}/${PN}-c.git"
EGIT_BRANCH="c_master"

DESCRIPTION="MessagePack is a binary-based efficient data interchange format"
HOMEPAGE="https://msgpack.org/ https://github.com/msgpack/msgpack-c/"

LICENSE="Boost-1.0"
SLOT="0/2"
IUSE="+cxx boost doc static-libs test examples"
RESTRICT="!test? ( test )"

BDEPEND="doc? ( app-text/doxygen[dot] )"
RDEPEND="
	boost? ( dev-libs/boost[context,${MULTILIB_USEDEP}] )
"
DEPEND="
	test? (
		>=dev-cpp/gtest-1.6.0-r2[${MULTILIB_USEDEP}]
		virtual/zlib[${MULTILIB_USEDEP}]
	)
"

DOCS=( CHANGELOG.md QUICKSTART-C.md README.md )

use_onoff() {
	usex "${1}" "ON" "OFF"
}

src_unpack() {
	git-r3_src_unpack
	if use cxx; then
		EGIT_BRANCH="cpp_master" EGIT_CHECKOUT_DIR="${WORKDIR}/${P}-cpp" git-r3_src_unpack
	fi
}

multilib_src_configure() {
	local bit="OFF";
	if use x86 || use arm || use mips || ! multilib_is_native_abi; then
		# not sure if applies to non-x86 32bit arches. Need tests.
		bit="ON";
	fi
	local mycmakeargs=(
		-DMSGPACK_32BIT="${bit}"
		-DMSGPACK_BUILD_TESTS=$(use_onoff test)
		-DMSGPACK_ENABLE_STATIC=$(use_onoff static-libs)
		-DMSGPACK_ENABLE_SHARED=ON
		-DMSGPACK_BUILD_EXAMPLES=OFF
	)
	cmake_src_configure
	if use cxx && use doc; then
		local mycmakeargs=(
			-DMSGPACK_32BIT="${bit}"
			-DMSGPACK_BUILD_TESTS=OFF
			-DMSGPACK_BUILD_EXAMPLES=OFF
		)
		S="${WORKDIR}/${P}-cpp" CMAKE_IN_SOURCE_BUILD=ON cmake_src_configure
	fi
}

multilib_src_compile() {
	cmake_src_compile

	if multilib_is_native_abi && use doc; then
		cmake_build doxygen
		if use css; then
			S="${WORKDIR}/${P}-cpp" CMAKE_IN_SOURCE_BUILD=ON cmake_build doxygen
		fi
	fi
}

multilib_src_install() {
	if multilib_is_native_abi; then
		if use cxx; then
			DOCS+=("${WORKDIR}/${P}-cpp"/QUICKSTART-CPP.md)

			if use examples; then
				docinto examples/cpp
				dodoc -r "${WORKDIR}/${P}-cpp/example/."
				docompress -x /usr/share/doc/${PF}/examples/cpp
			fi
		fi

		if use doc; then
			local HTML_DOCS=( "${BUILD_DIR}/docs/." )

			mkdir docs || die
			mv doc_c/html docs/c || die

			if use cxx; then
				mv "${WORKDIR}/${P}-cpp/doc_cpp/html" docs/cpp || die
			fi
		fi

		if use examples; then
			docinto examples/c
			dodoc -r "${S}/example/."
			docompress -x /usr/share/doc/${PF}/examples/c
		fi
	fi

	cmake_src_install
	if use cxx; then
		insinto /usr/include
		doins -r "${WORKDIR}/${P}-cpp/include/."
	fi
	# einstalldocs
}
