# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

DESCRIPTION="Open source project that includes YUV scaling and conversion functionality"
HOMEPAGE="https://chromium.googlesource.com/libyuv/libyuv/"

# Fetch from: https://chromium.googlesource.com/libyuv/libyuv.git/+archive/${EGIT_COMMIT}.tar.gz
SRC_URI="https://dev.gentoo.org/~mva/distfiles/${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
SLOT="0/${PV}"

IUSE="static-libs test tools"

RDEPEND="media-libs/libjpeg-turbo"
DEPEND="
	${RDEPEND}
	test? (
		dev-cpp/gtest
		dev-cpp/gflags
	)
	dev-util/cmake
"

RESTRICT="!test? ( test )"

DOCS=( AUTHORS LICENSE PATENTS README.{md,chromium} )

PATCHES="${FILESDIR}/${P//_p*}-cmake-libdir.patch"

S="${WORKDIR}"
BUILD_DIR="${S}/build"

src_prepare() {
	cmake_src_prepare
	if use tools; then
		if ! use static-libs; then
			# link against libyuv dinamically, but not statically (unless static-libs is enabled)
			sed -i -r \
				-e '/TARGET_LINK_LIBRARIES.* yuvconvert /{s@(ly_lib)_static@\1_name@}' \
				-e '/.*target_link_libraries.*yuvconvert.*JPEG_LIBRARY.*/{p;s@yuvconvert@${ly_lib_shared}@}' \
				CMakeLists.txt

			# help linker to see just-built libyuv.so if we're doing clean install and prefer it over system-wide if we're upgrading
			append-ldflags '-L.'
			# append-ldflags '-lm'
		fi
	else
		sed -i \
			-e '/ yuvconvert /d' \
			-e '/^INSTALL.* PROGRAMS /d' \
			CMakeLists.txt
	fi
	#
	sed -i \
		-e '/ yuvconstants /d' \
		CMakeLists.txt
	# ^ broken anyway ATM, cries about undefined reference to roundf, and linking to libm doest help
	if ! use static-libs; then
		sed -i \
			-e '/ly_lib_static/d' \
			CMakeLists.txt
	fi
}

src_configure() {
	local mycmakeargs=(-Wno-dev)
	if use test; then
		mycmakeargs+=(-DTEST=ON)
	fi
	cmake_src_configure
}

src_compile() {
	cmake_src_compile libyuv.so
	if use static-libs; then
		cmake_src_compile libyuv.a
	fi
	if use tools; then
		cmake_src_compile yuvconvert
	fi
}

src_install() {
	cmake_src_install
	insinto /usr/$(get_libdir)/pkgconfig
	cat "${FILESDIR}/${PN}.pc.in" | \
	sed -e "s|@prefix@|/usr|" \
		-e "s|@exec_prefix@|\${prefix}|" \
		-e "s|@libdir@|/usr/$(get_libdir)|" \
		-e "s|@includedir@|\${prefix}/include|" \
		-e "s|@version@|${PV//_p*}|" > "${T}/${PN}.pc" || die
	doins "${T}/${PN}.pc"
}
