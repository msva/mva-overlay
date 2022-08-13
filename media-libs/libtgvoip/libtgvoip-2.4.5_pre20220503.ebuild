# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs flag-o-matic cmake patches

if [[ "${PV}" == 9999 ]]; then
	EGIT_SUBMODULES=(-cmake)
	EGIT_REPO_URI="https://github.com/telegramdesktop/${PN}"
	inherit git-r3
else
	if [[ "${PV}" == *_pre* ]]; then
		EGIT_COMMIT="78a8e22bedb0d06004da8bafeba88b7474cb89a4"
	fi
	MY_PV="${EGIT_COMMIT:-${PV}}"
	SRC_URI="https://github.com/telegramdesktop/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
	# ~mips
	# ^ pulseaudio
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

DESCRIPTION="VoIP library for Telegram clients"
HOMEPAGE="https://github.com/telegramdesktop/libtgvoip"

LICENSE="Unlicense"
SLOT="0"
IUSE="alsa libcxx libressl pulseaudio static-libs"
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
	>media-libs/tg_owt-0_pre20210101[libcxx=]
	pulseaudio? ( media-sound/pulseaudio )
"
DEPEND="
	${RDEPEND}
"

pkg_pretend() {
	if [[ $(get-flag stdlib) == "libc++" ]]; then
		if ! tc-is-clang; then
			die "Building with libcxx (aka libc++) as stdlib requires using clang as compiler. Please set CC/CXX in portage.env"
		elif ! use libcxx; then
			die "Building with libcxx (aka libc++) as stdlib requires some dependencies to be also built with it. Please, set USE=libcxx on ${PN} to handle that."
		fi
	fi
}

src_prepare() {
	rm -rf "${S}"/webrtc_dsp # we'll link over tg_owt instead
	cp "${FILESDIR}"/cmake/"${PN}".cmake "${S}"/CMakeLists.txt
	patches_src_prepare

	if use libcxx; then
		export CC="clang" CXX="clang++ -stdlib=libc++"
	fi
}

src_configure() {
	filter-flags '-DDEBUG' # produces bugs in bundled forks of 3party code
	append-cppflags '-DNDEBUG' # Telegram sets that in code (and I also forced that in ebuild to have the same behaviour), and segfaults on voice calls on mismatch (if tg was built with it, and deps are built without it, and vice versa)
	local mycmakeargs=(
		#-DDESKTOP_APP_USE_PACKAGED=TRUE
		#-DDESKTOP_APP_DISABLE_CRASH_REPORTS=TRUE
		-DBUILD_STATIC_LIBRARY=$(usex static-libs ON OFF)
		-DENABLE_ALSA=$(usex alsa ON OFF)
		-DENABLE_PULSEAUDIO=$(usex pulseaudio ON OFF)
	)
	cmake_src_configure
}
