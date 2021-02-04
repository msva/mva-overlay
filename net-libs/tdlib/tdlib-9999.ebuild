# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

#inherit multibuild
inherit cmake-utils git-r3

DESCRIPTION="Cross-platform library for building Telegram clients"
HOMEPAGE="https://github.com/tdlib/td"
EGIT_REPO_URI="https://github.com/tdlib/td"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS=""
IUSE="+cli +java +lto"

BDEPEND="
	|| (
		>=sys-devel/clang-3.4:=
		>=sys-devel/gcc-4.9:=
	)
	dev-util/gperf
	virtual/jdk:=
"
RDEPEND="
	dev-libs/openssl:0=
	sys-libs/zlib
"
DEPEND="
	${BDEPEND}
	${RDEPEND}
	>=dev-util/cmake-3.0.2
"
# doc? ( doxygen )

DOCS=( README.md )

src_prepare() {
	sed -r \
		-e '/install\(TARGETS/,/  INCLUDES/{s@(LIBRARY DESTINATION).*@\1 ${CMAKE_INSTALL_LIBDIR}@;s@(ARCHIVE DESTINATION).*@\1 ${CMAKE_INSTALL_LIBDIR}@;s@(RUNTIME DESTINATION).*@\1 ${CMAKE_INSTALL_BINDIR}@}' \
		-i CMakeLists.txt
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DTD_ENABLE_JNI=$(usex java ON OFF)
#		-DTD_ENABLE_DOTNET=$(usex dotnet ON OFF)
		-DTD_ENABLE_LTO=$(usex lto ON OFF)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	use cli && dobin "${BUILD_DIR}"/tg_cli
#	exeinto "/usr/$(get_libdir)"
#	doexe "${BUILD_DIR}"/libtdjson.so
#	^ NULLed DT_RUNPATH :'(
}
