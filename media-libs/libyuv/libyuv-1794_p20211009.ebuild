EAPI=8

inherit cmake

DESCRIPTION="Open source project that includes YUV scaling and conversion functionality"
HOMEPAGE="https://chromium.googlesource.com/libyuv/libyuv/"

EGIT_COMMIT="d13d9d5972ec99e9f923ec5ca2afb8c1d21b8e5a"
SRC_URI="https://chromium.googlesource.com/libyuv/libyuv.git/+archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-3"
KEYWORDS="~amd64 ~arm64"
SLOT="0/${PV}"

IUSE="static-libs test"

RDEPEND="virtual/jpeg"
DEPEND="
	${RDEPEND}
	test? (
		dev-cpp/gtest
		dev-cpp/gflags
	)
	dev-util/cmake
"

DOCS=( AUTHORS LICENSE PATENTS README.{md,chromium} )

PATCHES="${FILESDIR}/${P//_p*}-cmake-libdir.patch"

S="${WORKDIR}"

src_prepare() {
	cmake_src_prepare
	use static-libs || sed -i -r \
		-e '/TARGET_LINK_LIBRARIES.* yuvconvert /{s@(ly_lib)_static@\1_name@}' \
		-e '/.*target_link_libraries.*yuvconvert.*JPEG_LIBRARY.*/{p;s@yuvconvert@${ly_lib_shared}@}' \
		-e '/ly_lib_static/d' \
		CMakeLists.txt
}

src_configure() {
	local mycmakeargs=(-Wno-dev)
	if use test; then
		mycmakeargs+=(-DTEST=ON)
	fi
	cmake_src_configure
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
