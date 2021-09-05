# Copyright 1999-2021 Gentoo Authors
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
	KEYWORDS="~amd64 ~ppc64"
	EGIT_COMMIT="91d836dc84a16584c6ac52b36c04c0de504d9c34"
	SRC_URI="https://github.com/desktop-app/${PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
fi


LICENSE="BSD-3"
SLOT="0"
IUSE="+X +alsa libcxx pipewire pulseaudio"
REQUIRED_USE="pulseaudio? ( alsa )"

# Bundled libs:
# - libyuv (no stable versioning, www-client/chromium and media-libs/libvpx bundle it)
# - libsrtp (project uses private APIs)
# - pffft (no stable versioning, patched)
# - rnnoise (private APIs)
# media-libs/libjpeg-turbo is required for libyuv
DEPEND="
	dev-cpp/abseil-cpp:=[cxx17(+)]
	dev-lang/yasm
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
	net-libs/usrsctp
	alsa? ( media-libs/alsa-lib )
	pulseaudio? (
		media-sound/pulseaudio
	)
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
#	media-libs/rnnoise
#	net-libs/libsrtp
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/0000_pkgconfig.patch"
	"${FILESDIR}/tg_owt-0_pre20210626-allow-disabling-pipewire.patch"
	"${FILESDIR}/tg_owt-0_pre20210626-allow-disabling-X11.patch"
	"${FILESDIR}/tg_owt-0_pre20210626-allow-disabling-pulseaudio.patch"
	"${FILESDIR}/tg_owt-0_pre20210626-expose-set_allow_pipewire.patch"
	"${FILESDIR}/libyuv.patch"
	"${FILESDIR}/libyuv_2.patch"
	"${FILESDIR}/libyuv_3.patch"
	"${FILESDIR}/libyuv_4.patch"
)

pkg_pretend() {
	if use libcxx; then
		append-cxxflags "-stdlib=libc++"
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
#	sed -i '/include(cmake\/librnnoise.cmake)/d' CMakeLists.txt || die
#	sed -i '/include(cmake\/libsrtp.cmake)/d' CMakeLists.txt || die
	sed -i '/include(cmake\/libusrsctp.cmake)/d' CMakeLists.txt || die
	sed -i '/include(cmake\/libevent.cmake)/d' CMakeLists.txt || die

	append-cppflags -I/usr/include/pipewire-0.3 -I/usr/include/spa-0.2

	if !use pipewire; then
		eapply "${FILESDIR}"/pipewire_off.patch
		eapply "${FILESDIR}"/pipewire_cmake.patch

		sed -i -e '/desktop_capture\/screen_drawer/d' CMakeLists.txt || die
		sed -i -e '/desktop_capture\/screen_capturer_integration_test/d' CMakeLists.txt || die
		sed -i -e '/desktop_capture\/window_finder_unittest/d' CMakeLists.txt || die
	fi

	rm -r "${S}"/src/third_party/{abseil-cpp,libvpx,libyuv,openh264,pipewire,usrsctp}
#	libsrtp,
#	rnnoise,

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
		-DTG_OWT_BUILD_AUDIO_BACKENDS=$(usex alsa ON OFF)
		-DTG_OWT_BUILD_PULSE_BACKEND=$(usex pulseaudio ON OFF)
	)

	cmake_src_configure
}
