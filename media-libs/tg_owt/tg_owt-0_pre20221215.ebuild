# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

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
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
	EGIT_COMMIT="1512ef693a7469d7dbc61191ecc0b487bc7f594f"
	SRC_URI="https://github.com/desktop-app/${PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
fi

LICENSE="BSD"
SLOT="0"
IUSE="pipewire screencast +X"

REQUIRED_USE="screencast? ( pipewire )"

# Bundled libs:
# - libsrtp (project uses private APIs)
# - pffft (no stable versioning, patched)
# - rnnoise (private APIs)
RDEPEND="
	>=dev-cpp/abseil-cpp-20220623.1:=
	dev-libs/crc32c
	dev-libs/libevent:=
	dev-libs/openssl:=
	dev-libs/protobuf:=
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
"
#	dev-lang/yasm

PATCHES=(
	"${FILESDIR}/0000_pkgconfig.patch"
	"${FILESDIR}/${PN}-0_pre20221215-allow-disabling-pipewire.patch"
	"${FILESDIR}/${PN}-0_pre20221215-allow-disabling-pulseaudio.patch"
	"${FILESDIR}/${PN}-0_pre20221215-expose-set_allow_pipewire.patch"
	"${FILESDIR}/libyuv.patch"
	"${FILESDIR}/libyuv_2.patch"
	"${FILESDIR}/libyuv_3.patch"
	"${FILESDIR}/libyuv_4.patch"
	"${FILESDIR}/fix-clang-emplace.patch"
	"${FILESDIR}/patch-cmake-absl-external.patch"
	"${FILESDIR}/patch-cmake-crc32c-external.patch"
)

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
	append-cppflags '-DNDEBUG' # Telegram sets that in code
	# (and I also forced that in ebuild to have the same behaviour),
	# and segfaults on voice calls on mismatch
	# (if tg was built with it, and deps are built without it, and vice versa)

	local mycmakeargs=(
		-DTG_OWT_PACKAGED_BUILD=ON
		-DBUILD_SHARED_LIBS=ON
		-DTG_OWT_USE_PROTOBUF=ON
		-DTG_OWT_USE_X11=$(usex X ON OFF)
		-DTG_OWT_USE_PIPEWIRE=$(usex pipewire ON OFF)
		-DTG_OWT_DLOPEN_PIPEWIRE=$(usex pipewire ON OFF)
	)

	cmake_src_configure
}
src_install() {
	cmake_src_install

	# Save about 15MB of useless headers
	rm -r "${ED}/usr/include/tg_owt/rtc_base/third_party" || die
	rm -r "${ED}/usr/include/tg_owt/common_audio/third_party" || die
	rm -r "${ED}/usr/include/tg_owt/modules/third_party" || die
	rm -r "${ED}/usr/include/tg_owt/third_party" || die

	# Install a few headers anyway, as required by net-im/telegram-desktop...
	local headers=(
		# third_party/libyuv/include
		rtc_base/third_party/sigslot
		rtc_base/third_party/base64
	)
	for dir in "${headers[@]}"; do
	    pushd "${S}/src/${dir}" > /dev/null || die
	    find -type f -name "*.h" -exec install -Dm644 '{}' "${ED}/usr/include/tg_owt/${dir}/{}" \; || die
		popd > /dev/null || die
	done
}
