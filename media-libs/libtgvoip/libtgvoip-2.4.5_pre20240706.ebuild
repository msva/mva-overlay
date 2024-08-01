# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic patches
# cmake

if [[ "${PV}" == 9999 ]]; then
	EGIT_SUBMODULES=(-cmake)
	EGIT_REPO_URI="https://github.com/telegramdesktop/${PN}"
	inherit git-r3
else
	if [[ "${PV}" == *_pre* ]]; then
		EGIT_COMMIT="2d2592860478e60d972b96e67ee034b8a71bb57a"
	fi
	MY_PV="${EGIT_COMMIT:-${PV}}"
	SRC_URI="https://github.com/telegramdesktop/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
	# ~mips
	# ^ pulseaudio
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

DESCRIPTION="VoIP library for Telegram clients"
HOMEPAGE="https://github.com/telegramdesktop/libtgvoip"

LICENSE="Unlicense"
SLOT="0"
IUSE="+alsa +dsp pulseaudio pipewire static-libs"
REQUIRED_USE="|| ( dsp alsa pulseaudio pipewire )"

RDEPEND="
	alsa? ( media-libs/alsa-lib )
	dsp? (
		dev-cpp/abseil-cpp:=
		>=media-libs/tg_owt-0_pre20230401:=
	)
	dev-libs/openssl:=
	media-libs/opus
	pulseaudio? ( !pipewire? ( media-sound/pulseaudio-daemon ) )
	pipewire? (
		!media-sound/pulseaudio-daemon
		media-video/pipewire[sound-server(-)]
	)
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	rm -rf "${S}"/webrtc_dsp # we'll link over tg_owt instead
	# Will be controlled by us
	sed -i -e '/^CFLAGS += -DTGVOIP_NO_DSP/d' Makefile.am || die
	# https://bugs.gentoo.org/717210
	echo 'libtgvoip_la_LIBTOOLFLAGS = --tag=CXX' >> Makefile.am || die
	# default
	patches_src_prepare
	eautoreconf
}

src_configure() {
	# Not using the CMake build despite being the preferred one, because
	# it's lacking relevant configure options.
	local myconf=(
		--disable-dsp  # WebRTC is linked from tg_owt
		$(use_with alsa)
		$(use_with pulseaudio pulse)
		$(use_with pipewire pulse)
	)
	if use dsp; then
		append-cppflags "-I${ESYSROOT}/usr/include/tg_owt"
		append-cppflags "-I${ESYSROOT}/usr/include/tg_owt/third_party/abseil-cpp"
		append-libs '-ltg_owt'
	else
		append-cppflags '-DTGVOIP_NO_DSP'
	fi
	econf "${myconf[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
