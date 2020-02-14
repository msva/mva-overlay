# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs flag-o-matic autotools patches

if [[ "${PV}" == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/telegramdesktop/${PN}"
	inherit git-r3
else
	if [[ "${PV}" == *_pre* ]]; then
		MY_SHA="0bda19899e3cedc093d654ee659bd637ee3a775d"
	fi
	SRC_URI="https://github.com/telegramdesktop/${PN}/archive/${MY_SHA:-${PV}}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
	# ~mips
	# ^ pulseaudio
	S="${WORKDIR}/${PN}-${MY_SHA:-${PV}}"
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
	sed -i -r \
		-e "/tgvoipincludedir/s@^@libtgvoip_la_LIBTOOLFLAGS = --tag=CXX\n@" \
		Makefile.am

	patches_src_prepare
	eautoreconf
}

src_configure() {
	econf \
		$(usex alsa '' '--without-alsa') \
		$(usex pulseaudio '' '--without-pulse') \
		--enable-dsp \
		--enable-audio-callback
}
