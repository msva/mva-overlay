# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CMAKE_MIN_VERSION="3.8"

inherit eutils gnome2-utils xdg cmake-utils toolchain-funcs flag-o-matic multilib git-r3 patches

DESCRIPTION="Official desktop client for Telegram"
HOMEPAGE="https://desktop.telegram.org"

if [[ "${PV}" == 9999 ]]; then
	KEYWORDS=""
	EGIT_BRANCH="dev"
else
	EGIT_COMMIT="v${PV}"
	KEYWORDS="~amd64 ~x86"
fi

EGIT_REPO_URI="https://github.com/telegramdesktop/tdesktop"
EGIT_SUBMODULES=( '*' -Telegram/ThirdParty/{xxHash,Catch,lz4,rlottie} )
#,tgvoip
#} )

LICENSE="GPL-3-with-openssl-exception"
SLOT="0"
IUSE="clang crash-report custom-api-id debug +gtk3 openal-eff +pulseaudio libressl wide-baloons"
# upstream-api-id"

# ^ libav support?

COMMON_DEPEND="
	app-arch/lz4:=
	app-arch/xz-utils:=
	crash-report? ( dev-util/google-breakpad:= )
	dev-cpp/range-v3:=
	dev-libs/rapidjson:=
	dev-libs/xxhash:=
	dev-qt/qtcore:5=
	dev-qt/qtdbus:5=
	dev-qt/qtgui:5=[xcb,jpeg,png]
	dev-qt/qtnetwork:5=
	dev-qt/qtwidgets:5=[xcb,png]
	dev-qt/qtimageformats:5=
	gtk3? (
		x11-libs/gtk+:3
		dev-libs/libappindicator:3
		>=dev-qt/qtgui-5.7:5[gtk(+)]
	)
	libressl? ( dev-libs/libressl:= )
	!libressl? ( dev-libs/openssl:0= )
	media-libs/openal:=
	media-libs/opus:=
	media-libs/rlottie:=
	media-video/ffmpeg:=
	!net-im/telegram
	!net-im/telegram-desktop-bin
	openal-eff? ( >=media-libs/openal-1.19.1:= )
	pulseaudio? ( media-sound/pulseaudio:= )
	sys-libs/zlib:=[minizip]
	x11-libs/libdrm:=
	x11-libs/libva:=[X,drm]
	x11-libs/libX11:=
"

RDEPEND="
	${COMMON_DEPEND}
"

DEPEND="
	clang? (
		sys-devel/clang
		sys-devel/clang-runtime[libcxx,compiler-rt]
		media-libs/rlottie:=[libcxx]
	)
	!clang? ( >=sys-devel/gcc-8.2.0-r6 )
	virtual/pkgconfig
	${COMMON_DEPEND}
"

CMAKE_USE_DIR="${S}/Telegram"

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		if ! use clang && has_version '>=sys-devel/gcc-9.1.0' && has_version '<sys-devel/gcc-9.1.0-r2' && [[ -z "${I_HAVE_PATCHED_GCC_9_1_FOR_TELEGRAM}" ]]; then
			die "GCC-9.1.0 (without special patch) causes https://github.com/telegramdesktop/tdesktop/issues/5996"
		fi
	fi
	if [[ "${CXX}" =~ clang ]]; then
		if ! use clang; then
			die "Building ${PN} with clang requires 'clang' USE-flag to be enabled"
		fi
	fi
}

src_prepare() {
	local CMAKE_MODULES_DIR="${S}/Telegram/cmake"
	local THIRD_PARTY_DIR="${S}/Telegram/ThirdParty"
	local LIBTGVOIP_DIR="${THIRD_PARTY_DIR}/libtgvoip"

	cp "${FILESDIR}/cmake/Telegram.cmake" "${S}/Telegram/CMakeLists.txt"
	cp "${FILESDIR}/cmake/ThirdParty-crl.cmake" "${THIRD_PARTY_DIR}/crl/CMakeLists.txt"
	cp "${FILESDIR}/cmake/ThirdParty-libtgvoip.cmake" "${LIBTGVOIP_DIR}/CMakeLists.txt"
	cp "${FILESDIR}/cmake/ThirdParty-libtgvoip-webrtc.cmake" \
		"${LIBTGVOIP_DIR}/webrtc_dsp/CMakeLists.txt"

	mkdir "${CMAKE_MODULES_DIR}" || die
	use crash-report && cp "${FILESDIR}/cmake/FindBreakpad.cmake" "${CMAKE_MODULES_DIR}"
	cp "${FILESDIR}/cmake/TelegramCodegen.cmake" "${CMAKE_MODULES_DIR}"
	cp "${FILESDIR}/cmake/TelegramCodegenTools.cmake" "${CMAKE_MODULES_DIR}"
	cp "${FILESDIR}/cmake/TelegramTests.cmake" "${CMAKE_MODULES_DIR}"

	patches_src_prepare

	if use custom-api-id; then
		if [[ -n "${TELEGRAM_CUSTOM_API_ID}" ]] && [[ -n "${TELEGRAM_CUSTOM_API_HASH}" ]]; then
			echo "Your custom ApiId is ${TELEGRAM_CUSTOM_API_ID}"
			echo "Your custom ApiHash is ${TELEGRAM_CUSTOM_API_HASH}"
		else
			eerror ""
			eerror "It seems you did not set one or both of TELEGRAM_CUSTOM_API_ID and TELEGRAM_CUSTOM_API_HASH variables,"
			eerror "which are required for custom-api-id USE-flag."
			eerror "You can set them either in:"
			eerror "- /etc/portage/make.conf (globally, so all applications you'll build will see that ID and HASH"
			eerror "- /etc/portage/env/${CATEGORY}/${PN} (privately for this package builds)"
			eerror ""
			die "You should correctly set both TELEGRAM_CUSTOM_API_ID and TELEGRAM_CUSTOM_API_HASH variables if you want custom-api-id USE-flag"
		fi
	fi
	mv "${S}"/lib/xdg/telegram{,-}desktop.desktop || die "Failed to fix .desktop-file name"
}

src_configure() {
	local mycxxflags=(
		# ApiId and ApiHash are from Debian repository:
		# https://salsa.debian.org/debian/telegram-desktop/blob/debian/master/debian/patches/Debian-API-ID.patch#L16
		# The Telegram desktop developer John Preston thinks that Debian id/hash pair can be used in Gentoo ebuild:
		# https://github.com/telegramdesktop/tdesktop/issues/4717#issuecomment-438152135
		# The test pair from Telegram desktop repository: TDESKTOP_API_ID=17349 and TDESKTOP_API_HASH=344583e45741c457fe1862106095a5eb
		$(usex custom-api-id "-DTDESKTOP_API_ID=${TELEGRAM_CUSTOM_API_ID}" "-DTDESKTOP_API_ID=50322")
		$(usex custom-api-id "-DTDESKTOP_API_HASH=${TELEGRAM_CUSTOM_API_HASH}" "-DTDESKTOP_API_HASH=9ff1a639196c0779c86dd661af8522ba")
		-DLIBDIR="$(get_libdir)"

#		-DTDESKTOP_DISABLE_CRASH_REPORTS
#		-DTDESKTOP_DISABLE_REGISTER_CUSTOM_SCHEME
#		-DTDESKTOP_DISABLE_DESKTOP_FILE_GENERATION
	)

	if [[ "${CXX}" =~ clang ]]; then
			mycxxflags+=("-stdlib=libc++")
	fi

	local mycmakeargs=(
		-DCMAKE_CXX_FLAGS:="${mycxxflags[*]}"
		-DENABLE_CRASH_REPORTS="$(usex crash-report ON OFF)"
		-DENABLE_GTK_INTEGRATION="$(usex gtk3 ON OFF)"
		-DENABLE_OPENAL_EFFECTS="$(usex openal-eff ON OFF)"
		-DENABLE_PULSEAUDIO=$(usex pulseaudio ON OFF)
		-DBUILD_TESTS="OFF"
		# ^ $(usex test)?
	)
	use crash-report && mycmakeargs+=(
		-DBREAKPAD_CLIENT_INCLUDE_DIR="/usr/include/breakpad"
		-DBREAKPAD_CLIENT_LIBRARY="/usr/$(get_libdir)/libbreakpad_client.a"
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	default

	local icon_size
	for icon_size in 16 32 48 64 128 256 512; do
		newicon -s "${icon_size}" \
			"${S}/Telegram/Resources/art/icon${icon_size}.png" \
			telegram-desktop.png
	done
}

pkg_preinst() {
	xdg_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_icon_cache_update
}
