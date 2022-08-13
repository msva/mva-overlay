# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic toolchain-funcs

DESCRIPTION="WebRTC (video) library (fork) for Telegram clients"
HOMEPAGE="https://github.com/desktop-app/tg_owt"

if [[ "${PV}" == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/desktop-app/${PN}"
	inherit git-r3
	EGIT_SUBMODULES=(
		'*'
		-src/third_party/libyuv
		-src/third_party/libvpx/source/libvpx
		-src/third_party/pipewire
	)
else
	KEYWORDS="~amd64"
	#	~ppc64"
	#	^ libyuv (not a big deal, actually), clang-runtime[libcxx], libcxx (!)
	EGIT_COMMIT="10d5f4bf77333ef6b43516f90d2ce13273255f41"
	SRC_URI="https://github.com/desktop-app/${PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
fi

LICENSE="BSD"
SLOT="0"
IUSE="libcxx pipewire +X"

REQUIRED_USE="X"
#ppc64? ( !libcxx )"

# Bundled libs:
# - libsrtp (project uses private APIs)
# - pffft (no stable versioning, patched)
# - rnnoise (private APIs)
RDEPEND="
	dev-cpp/abseil-cpp:=[cxx17(+)]
	dev-libs/crc32c
	dev-libs/libevent:=
	dev-libs/openssl:=
	dev-libs/protobuf:=
	libcxx? (
		sys-devel/clang:=
		sys-devel/clang-runtime:=[libcxx]
		sys-libs/libcxx:=
	)
	media-libs/libjpeg-turbo:=
	>=media-libs/libvpx-1.10.0:=
	media-libs/libyuv
	media-libs/openh264:=
	media-libs/opus
	media-video/ffmpeg:=
	pipewire? (
		dev-libs/glib:2
		media-video/pipewire:=
	)
	X? (
		x11-libs/libX11
		x11-libs/libXcomposite
		x11-libs/libXdamage
		x11-libs/libXext
		x11-libs/libXfixes
		x11-libs/libXrender
		x11-libs/libXrandr
		x11-libs/libXtst
	)
"
#	net-libs/libsrtp
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	dev-lang/yasm
"

PATCHES=(
	"${FILESDIR}/0000_pkgconfig.patch"
	"${FILESDIR}/${PN}-0_pre20210626-allow-disabling-pipewire.patch"
	"${FILESDIR}/${PN}-0_pre20211207-allow-disabling-X11.patch"
	"${FILESDIR}/${PN}-0_pre20210626-allow-disabling-pulseaudio.patch"
	"${FILESDIR}/${PN}-0_pre20210626-expose-set_allow_pipewire.patch"
	"${FILESDIR}/libyuv.patch"
	"${FILESDIR}/libyuv_2.patch"
	"${FILESDIR}/libyuv_3.patch"
	"${FILESDIR}/libyuv_4.patch"
	"${FILESDIR}/fix-clang-emplace.patch"
	"${FILESDIR}/patch-cmake-absl-external.patch"
	"${FILESDIR}/patch-cmake-crc32c-external.patch"
)

pkg_pretend() {
	if use libcxx; then
		export CC="clang" CXX="clang++ -stdlib=libc++"
	# elif tc-is-clang; then
	# 	eerror "Clang builds fails for now, see https://github.com/desktop-app/tg_owt/issues/83"
	fi

	if [[ $(get-flag stdlib) == "libc++" ]]; then
		if ! tc-is-clang; then
			die "Building with libcxx (aka libc++) as stdlib requires using clang as compiler. Please set CC/CXX in portage.env"
		elif ! use libcxx; then
			die "Building with libcxx (aka libc++) as stdlib requires some dependencies to be also built with it. Please, set USE=libcxx on ${PN} to handle that."
		fi
	fi
}

src_prepare() {
	cp "${FILESDIR}"/"${PN}".pc.in "${S}" || die "failed to copy pkgconfig template"

	sed -i '/include(cmake\/libvpx.cmake)/d' CMakeLists.txt || die
	sed -i '/include(cmake\/libyuv.cmake)/d' CMakeLists.txt || die

	sed -i '/include(cmake\/libabsl.cmake)/d' CMakeLists.txt || die
	sed -i '/include(cmake\/libopenh264.cmake)/d' CMakeLists.txt || die
	sed -i '/include(cmake\/libevent.cmake)/d' CMakeLists.txt || die
	sed -i '/include(cmake\/libcrc32c.cmake)/d' CMakeLists.txt || die

	# sed -i '/include(cmake\/librnnoise.cmake)/d' CMakeLists.txt || die
	# sed -i '/include(cmake\/libsrtp.cmake)/d' CMakeLists.txt || die

	if ! use pipewire; then
		eapply "${FILESDIR}"/pipewire_off.patch
		eapply "${FILESDIR}"/pipewire_cmake.patch

		sed -i -e '/desktop_capture\/screen_drawer/d' CMakeLists.txt || die
	else
		append-cppflags -I/usr/include/pipewire-0.3 -I/usr/include/spa-0.2
	fi
	sed -i -e '/desktop_capture\/screen_capturer_integration_test/d' CMakeLists.txt || die
	sed -i -e '/desktop_capture\/window_finder_unittest/d' CMakeLists.txt || die

	rm -r "${S}"/src/third_party/{abseil-cpp,libvpx,libyuv,openh264,pipewire}
	# libsrtp,
	# rnnoise,

	sed \
		-e '/#include/s@third_party/libyuv/include/@@' \
		-i \
			"${S}"/src/sdk/objc/unittests/frame_buffer_helpers.mm \
			"${S}"/src/sdk/objc/unittests/RTCCVPixelBuffer_xctest.mm \
			"${S}"/src/sdk/objc/components/video_frame_buffer/RTCCVPixelBuffer.mm \
			"${S}"/src/sdk/objc/components/video_codec/RTCVideoEncoderH264.mm \
			"${S}"/src/sdk/objc/api/video_frame_buffer/RTCNativeI420Buffer.mm \
			"${S}"/src/sdk/android/src/jni/java_i420_buffer.cc \
			"${S}"/src/modules/video_coding/codecs/av1/dav1d_decoder.cc \
			"${S}"/src/api/video/i444_buffer.cc || die

	sed \
		-e '/#include/s@third_party/crc32c/src/include/@@' \
		-i \
			"${S}"/src/net/dcsctp/packet/crc32c.cc  || die

	sed \
		-e "1i#include <cstdint>" \
		-i "${S}/src/common_video/h265/h265_pps_parser.h" || die

	cmake_src_prepare
}

src_configure() {
	append-flags '-fPIC'
	filter-flags '-DDEBUG' # produces bugs in bundled forks of 3party code
	append-cppflags '-DNDEBUG' # Telegram sets that in code (and I also forced that in ebuild to have the same behaviour), and segfaults on voice calls on mismatch (if tg was built with it, and deps are built without it, and vice versa)

	local mycmakeargs=(
		-DTG_OWT_PACKAGED_BUILD=ON
		-DBUILD_SHARED_LIBS=ON
		-DTG_OWT_USE_PROTOBUF=ON
		-DTG_OWT_USE_X11=$(usex X ON OFF)
		-DTG_OWT_USE_PIPEWIRE=$(usex pipewire ON OFF)
		-DTG_OWT_DLOPEN_PIPEWIRE=$(usex pipewire ON OFF)
		# -DTG_OWT_BUILD_AUDIO_BACKENDS=$(usex alsa ON OFF)
		# -DTG_OWT_BUILD_PULSE_BACKEND=$(usex pulseaudio ON OFF)
	)

	cmake_src_configure
}
