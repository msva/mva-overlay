# Copyright 1999-2023 Gentoo Authors
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
		EGIT_COMMIT="532b4970752ec2bf90e2003e0779bebd8f01500d"
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
	pulseaudio? ( !pipewire? ( media-sound/pulseaudio[daemon(-)] ) )
	pipewire? (
		media-sound/pulseaudio[-daemon(+)]
		media-video/pipewire[sound-server(-)]
	)
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	# cp "${FILESDIR}"/cmake/"${PN}".cmake "${S}"/CMakeLists.txt
	rm -rf "${S}"/webrtc_dsp # we'll link over tg_owt instead
	# Will be controlled by us
	sed -i -e '/^CFLAGS += -DTGVOIP_NO_DSP/d' Makefile.am || die
	# https://bugs.gentoo.org/717210
	echo 'libtgvoip_la_LIBTOOLFLAGS = --tag=CXX' >> Makefile.am || die
	# default
	patches_src_prepare
	eautoreconf
}

# src_configure() {
# 	filter-flags '-DDEBUG' # produces bugs in bundled forks of 3party code
# 	append-cppflags '-DNDEBUG' # Telegram sets that in code
# 		# (and I also forced that in ebuild to have the same behaviour),
# 		# and segfaults on voice calls on mismatch
# 		# (if tg was built with it, and deps are built without it, and vice versa)
# 	local mycmakeargs=(
# 		#-DDESKTOP_APP_USE_PACKAGED=TRUE
# 		#-DDESKTOP_APP_DISABLE_CRASH_REPORTS=TRUE
# 		-DBUILD_STATIC_LIBRARY=$(usex static-libs ON OFF)
# 		-DENABLE_ALSA=$(usex alsa ON OFF)
# 		-DENABLE_PULSEAUDIO=$(usex pulseaudio ON $(usex pipewire ON OFF))
# 	)
# 	cmake_src_configure
# }

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
		# append-cppflags "-I${ESYSROOT}/usr/include/tg_owt/third_party/abseil-cpp"
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
