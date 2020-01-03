# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils patches
if [[ "${PV}" == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/grishka/${PN}"
	inherit git-r3
else
	SRC_URI="https://github.com/grishka/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
	# ~mips
	# ^ pulseaudio
fi

DESCRIPTION="VoIP library for Telegram clients"
HOMEPAGE="https://github.com/grishka/libtgvoip"

LICENSE="Unlicense"
SLOT="0"
IUSE="alsa disable-reassembler libcxx libressl pulseaudio static-libs"
REQUIRED_USE="|| ( alsa pulseaudio )"

RDEPEND="
	alsa? ( media-libs/alsa-lib )
	libcxx? (
		sys-devel/clang:=
		sys-devel/clang-runtime:=[libcxx,compiler-rt]
		sys-libs/libcxx:=
	)
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	media-libs/opus
	pulseaudio? ( media-sound/pulseaudio )
"
DEPEND="
	${RDEPEND}
"

_isclang() {
	[[ "${CXX}" =~ clang ]]
}

src_prepare() {
	cp "${FILESDIR}/cmake/libtgvoip.cmake" "${S}/CMakeLists.txt"
	cp "${FILESDIR}/cmake/libtgvoip-webrtc.cmake" "${S}/webrtc_dsp/CMakeLists.txt"
	patches_src_prepare
}

src_configure() {
	if use libcxx; then
		_isclang || export CC=clang CXX=clang++
		append-cxxflags "-stdlib=libc++"
	fi
	#_isclang && append-cxxflags "-Wno-error"
	local mycmakeargs=(
		-DENABLE_ALSA=$(usex alsa ON OFF)
		-DENABLE_PULSEAUDIO=$(usex pulseaudio ON OFF)
		-DBUILD_STATIC_LIBRARY=$(usex static-libs ON OFF)
	)
	cmake-utils_src_configure
}
