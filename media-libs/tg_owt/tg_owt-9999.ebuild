# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs flag-o-matic cmake patches

if [[ "${PV}" == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/desktop-app/${PN}"
	inherit git-r3
else
#####################
#	SRC_URI="https://github.com/desktop-app/${PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
#	# ^ no releases yet
#	S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
#####################
#	^^^^^^^^ tarballed version doesn't work because of submodules (libvpx and libyuv)
#	TODO: unbundle them (!!!)
#	// Currently I've not enough spare time for that.
#	// Help is appreciated
	KEYWORDS="~amd64 ~ppc64"
#########
	EGIT_COMMIT="a19877363082da634a3c851a4698376504d2eaee"
	EGIT_REPO_URI="https://github.com/desktop-app/${PN}"
	inherit git-r3
#########
fi

DESCRIPTION="WebRTC (video) library (fork) for Telegram clients"
HOMEPAGE="https://github.com/desktop-app/tg_owt"

LICENSE="BSD-3"
SLOT="0"
IUSE="pulseaudio libcxx libressl"

# TODO: finish unbundling!
DEPEND="
	libcxx? (
		sys-devel/clang:=
		sys-devel/clang-runtime:=[libcxx]
		sys-libs/libcxx:=
	)
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	dev-libs/protobuf:=
	media-libs/alsa-lib
	media-libs/libjpeg-turbo:=
	media-libs/libvpx:=
	media-libs/openh264:=
	media-libs/opus
	media-video/ffmpeg:=
	!pulseaudio? ( media-sound/apulse[sdk] )
	pulseaudio? ( media-sound/pulseaudio )
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	virtual/pkgconfig
	amd64? ( dev-lang/yasm )
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
	cp "${FILESDIR}"/"${PN}".pc.in "${S}" || die "failed to copy pkgconfig template"
	patches_src_prepare
}

src_configure() {
	append-flags '-fPIC'
	filter-flags '-DDEBUG' # produces bugs in bundled forks of 3party code
	append-cppflags '-DNDEBUG' # Telegram sets that in code (and I also forced that in ebuild to have the same behaviour), and segfaults on voice calls on mismatch (if tg was built with it, and deps are built without it, and vice versa)
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=TRUE
		-DTG_OWT_PACKAGED_BUILD=TRUE
		-DTG_OWT_USE_PROTOBUF=TRUE # Strange things: it is disabled anyway, but build fails with FALSE.
	)
	cmake_src_configure
}
