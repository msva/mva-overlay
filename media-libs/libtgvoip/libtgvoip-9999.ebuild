# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_MIN_VERSION="3.14.0"
inherit toolchain-funcs flag-o-matic cmake-utils patches

if [[ "${PV}" == 9999 ]]; then
#	EGIT_REPO_URI="https://github.com/grishka/${PN}"
	EGIT_REPO_URI="https://github.com/telegramdesktop/${PN}"
	inherit git-r3
else
	SRC_URI="https://github.com/telegramdesktop/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
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
		sys-devel/clang-runtime:=[libcxx]
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
	cp "${FILESDIR}/cmake/libtgvoip.cmake" "${S}/CMakeLists.txt"
	cp "${FILESDIR}/cmake/libtgvoip-webrtc.cmake" "${S}/webrtc_dsp/CMakeLists.txt"
	patches_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_ALSA=$(usex alsa ON OFF)
		-DENABLE_PULSEAUDIO=$(usex pulseaudio ON OFF)
		-DBUILD_STATIC_LIBRARY=$(usex static-libs ON OFF)
	)
	cmake-utils_src_configure
}
