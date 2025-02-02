# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

DESCRIPTION="WebRTC (video) library (fork) for Telegram clients"
HOMEPAGE="https://github.com/desktop-app/tg_owt"

if [[ ! "${PV}" = 9999* ]]; then
	TG_OWT_COMMIT="be39b8c8d0db1f377118f813f0c4bd331d341d5e"
	LIBYUV_COMMIT="04821d1e7d60845525e8db55c7bcd41ef5be9406"
	LIBSRTP_COMMIT="a566a9cfcd619e8327784aa7cff4a1276dc1e895"
	# ABSL_COMMIT="d7aaad83b488fd62bd51c81ecf16cd938532cc0a"
	# check https://github.com/desktop-app/tg_owt/tree/master/src periodically for srtp and others commits
	SRC_URI="
		https://github.com/desktop-app/tg_owt/archive/${TG_OWT_COMMIT}.tar.gz -> ${P}.tar.gz
		https://github.com/cisco/libsrtp/archive/${LIBSRTP_COMMIT}.tar.gz -> libsrtp-${LIBSRTP_COMMIT}.tar.gz
		https://gitlab.com/chromiumsrc/libyuv/-/archive/${LIBYUV_COMMIT}/libyuv-${LIBYUV_COMMIT}.tar.bz2
	"
		# https://github.com/abseil/abseil-cpp/archive/${ABSL_COMMIT}.tar.gz -> abseil-cpp-${ABSL_COMMIT}.tar.gz
	S="${WORKDIR}/${PN}-${TG_OWT_COMMIT}"
	# Upstream libyuv: https://chromium.googlesource.com/libyuv/libyuv
else
	EGIT_REPO_URI="https://github.com/desktop-app/${PN}"
	inherit git-r3
	EGIT_SUBMODULES=(
		'*'
		# -src/third_party/libyuv
		-src/third_party/abseil-cpp
		-src/third_party/crc32c/src
		# -src/third_party/libsrtp # TODO: unbundle
	)
fi
# 👇 kludge for eix
[[ "${PV}" = 9999* ]] && SLOT="0/${PV}"
[[ "${PV}" = 9999* ]] || SLOT="0/${PV##*pre}"
[[ "${PV}" = 9999* ]] || KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
# 👆 kludge for eix

LICENSE="BSD"
IUSE="pipewire screencast +X"

REQUIRED_USE="screencast? ( pipewire )"

# Bundled libs:
# - libyuv (no stable versioning, www-client/chromium and media-libs/libvpx bundle it
# - libsrtp (project uses private APIs)
# - pffft (no stable versioning, patched)
# - rnnoise (private APIs)
RDEPEND="
	>=dev-cpp/abseil-cpp-20240116.2:=
	dev-libs/openssl:=
	media-libs/libjpeg-turbo:=
	>=media-libs/libvpx-1.10.0:=
	media-libs/openh264:=
	media-libs/opus
	media-video/ffmpeg:=[opus,vpx,openh264]
	pipewire? (
		dev-libs/glib:2
		media-video/pipewire:=
	)
	dev-libs/crc32c
	screencast? (
		media-libs/libglvnd[X=]
		media-libs/mesa
		x11-libs/libdrm
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
#	media-libs/libyuv
#	net-libs/libsrtp
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	X? ( x11-base/xorg-proto )
"
#	dev-lang/yasm

PATCHES=(
	"${FILESDIR}/0000_pkgconfig.patch"
	"${FILESDIR}/${PN}-0_pre20221215-allow-disabling-pipewire.patch"
	"${FILESDIR}/${PN}-0_pre20221215-allow-disabling-pulseaudio.patch"
	"${FILESDIR}/${PN}-0_pre20221215-expose-set_allow_pipewire.patch"
	# "${FILESDIR}/fix-clang-emplace.patch"
	"${FILESDIR}/patch-cmake-absl-external.patch"
	# XXX: 👆comment for re-bundling absl
	"${FILESDIR}/patch-cmake-crc32c-external.patch"
)

src_unpack() {
	if [[ "${PV}" == 9999 ]]; then
		git-r3_src_unpack
	else
		unpack "${P}.tar.gz"
		unpack "libyuv-${LIBYUV_COMMIT}.tar.bz2"
		mv -T "libyuv-${LIBYUV_COMMIT}" "${S}/src/third_party/libyuv" || die
		unpack "libsrtp-${LIBSRTP_COMMIT}.tar.gz"
		mv -T "libsrtp-${LIBSRTP_COMMIT}" "${S}/src/third_party/libsrtp" || die
		# unpack "abseil-cpp-${ABSL_COMMIT}.tar.gz"
		# mv -T "abseil-cpp-${ABSL_COMMIT}" "${S}/src/third_party/abseil-cpp" || die
		# XXX: 👆for re-bundling absl
	fi
}

src_prepare() {
	cp "${FILESDIR}"/"${PN}".pc.in "${S}" || die "failed to copy pkgconfig template"

	# sed -i '/include(cmake\/libyuv.cmake)/d' CMakeLists.txt || die

	sed -i '/include(cmake\/libabsl.cmake)/d' CMakeLists.txt || die
	# XXX: 👆comment for re-bundling absl
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

	# rm -r "${S}"/src/third_party/crc32c
	# XXX: 👆for re-bundling absl
	rm -r "${S}"/src/third_party/{crc32c,abseil-cpp}
	# libyuv,
	# pipewire,
	# libsrtp,
	# rnnoise,

	# sed \
	# 	-e '/#include/s@third_party/libyuv/include/@@' \
	# 	-i \
	# 		"${S}"/src/sdk/objc/unittests/frame_buffer_helpers.mm \
	# 		"${S}"/src/sdk/objc/unittests/RTCCVPixelBuffer_xctest.mm \
	# 		"${S}"/src/sdk/objc/components/video_frame_buffer/RTCCVPixelBuffer.mm \
	# 		"${S}"/src/sdk/objc/components/video_codec/RTCVideoEncoderH264.mm \
	# 		"${S}"/src/sdk/objc/api/video_frame_buffer/RTCNativeI420Buffer.mm \
	# 		"${S}"/src/sdk/android/src/jni/java_i420_buffer.cc \
	# 		"${S}"/src/modules/video_coding/codecs/av1/dav1d_decoder.cc \
	# 		"${S}"/src/api/video/i444_buffer.cc || die

	# FIXME: abseil-cpp related things (absl::string_view casts)
	# tg_owt uses (when bundled) git-almost-HEAD (april's commit) link in submodule
	# gentoo for now have only release january release.
	# Upgrading to july release (placing it in overlay) doesn't help with build failure (without this) either
	# Although, I guess it is related to this:
	# https://github.com/gentoo/gentoo/pull/32281#issuecomment-1676404974
	sed -r \
		-e "/[ ]*(group_name = )(kDefaultProbingScreenshareBweSettings)/s@@\1(std::string)\2@" \
		-i "${S}/src/rtc_base/experiments/alr_experiment.cc" || die
	sed -r \
		-e "/[ \t]*transaction_id.insert/s@(magic_cookie)@(std::string)\1@" \
		-i "${S}/src/api/transport/stun.cc" || die
	sed -r \
		-e "/(candidate_stats->candidate_type = )(candidate.type_name)/s@@\1(std::string)\2@" \
		-i "${S}/src/pc/rtc_stats_collector.cc" || die
	# append-cppflags -I"${S}/src/third_party/abseil-cpp"
	# XXX: 👆for re-bundling absl

	cmake_src_prepare
}

src_configure() {
	append-flags '-fPIC'
	filter-flags '-DDEBUG' # produces bugs in bundled forks of 3party code
	# Defined by -DCMAKE_BUILD_TYPE=Release, avoids crashes
	# See https://bugs.gentoo.org/754012
	# EAPI 8 still wipes this flag.
	append-cppflags '-DNDEBUG' # Telegram sets that in code
	# (and I also forced that in ebuild to have the same behaviour),
	# and segfaults on voice calls on mismatch
	# (if tg was built with it, and deps are built without it, and vice versa)

	local mycmakeargs=(
		-DTG_OWT_PACKAGED_BUILD=ON
		-DBUILD_SHARED_LIBS=ON
		# -DTG_OWT_USE_PROTOBUF=ON
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
		third_party/libyuv/include
		# third_party/abseil-cpp/absl
		# XXX: 👆for re-bundling absl
		rtc_base/third_party/sigslot
		rtc_base/third_party/base64
	)
	for dir in "${headers[@]}"; do
	    pushd "${S}/src/${dir}" > /dev/null || die
	    find -type f -name "*.h" -exec install -Dm644 '{}' "${ED}/usr/include/tg_owt/${dir}/{}" \; || die
		popd > /dev/null || die
	done
}
