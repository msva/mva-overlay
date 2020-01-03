# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_MIN_VERSION="3.16"

inherit cmake-utils flag-o-matic toolchain-funcs desktop xdg-utils xdg

inherit git-r3
# ^ TODO: conditional (only for 9999)? maybe port to tarballs before moving to gentoo repo.
inherit patches
# ^ TODO: drop before moving to gentoo repo, and port to manual selection

DESCRIPTION="Official desktop client for Telegram"
HOMEPAGE="https://desktop.telegram.org"

EGIT_REPO_URI="https://github.com/telegramdesktop/tdesktop.git"
EGIT_SUBMODULES=(
	'*'
	-Telegram/ThirdParty/{xxHash,Catch,lz4,rlottie,variant,libtgvoip,GSL,lib_rlottie}
	# TODO: unbundle other modules
)

if [[ "${PV}" == 9999 ]]; then
	KEYWORDS=""
	EGIT_BRANCH="dev"
else
	EGIT_COMMIT="v${PV}"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3-with-openssl-exception"
SLOT="0"
IUSE="clang crash-report custom-api-id debug +gtk3 gtk-file-dialog libressl lto +openal-eff +pulseaudio spell system-fonts test wide-baloons"

REQUIRED_USE="gtk-file-dialog? ( gtk3 )"

COMMON_DEPEND="
	app-arch/lz4:=
	app-arch/xz-utils:=
	app-text/enchant
	crash-report? ( dev-util/google-breakpad:= )
	>dev-cpp/ms-gsl-2.0.0:=
	>=dev-cpp/range-v3-0.9.1:=
	dev-cpp/variant:=
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
	media-libs/libexif
	media-libs/libtgvoip:=
	media-libs/openal:=
	media-libs/opus:=
	>=media-libs/rlottie-0_pre20190818:=[module,threads,telegram-patches]
	media-video/ffmpeg:=
	!net-im/telegram
	!net-im/telegram-desktop-bin
	openal-eff? ( >=media-libs/openal-1.19.1:= )
	pulseaudio? ( media-sound/pulseaudio:= )
	sys-libs/zlib:=[minizip]
	test? ( dev-cpp/catch )
	x11-libs/libdrm:=
	x11-libs/libva:=[X,drm]
	x11-libs/libxkbcommon
	x11-libs/libX11:=
"
# gtk3? ( x11-themes/QGnomePlatform gnome-base/gsettings-desktop-schemas )
# + patch for QT_QPA_PLATFORMTHEME=gnome
# ^ ?

RDEPEND="
	${COMMON_DEPEND}
"

DEPEND="
	clang? (
		sys-devel/clang:=
		sys-devel/clang-runtime:=[libcxx,compiler-rt]
		sys-libs/libcxx:=
		media-libs/rlottie:=[libcxx]
		media-libs/libtgvoip:=[libcxx]
	)
	!clang? ( >=sys-devel/gcc-8.2.0-r6:= )
	virtual/pkgconfig
	${COMMON_DEPEND}
"

#CMAKE_USE_DIR="${S}/Telegram"

#PATCHES=( "${FILESDIR}/patches" )

_isclang() {
	[[ "${CXX}" =~ clang ]]
}

pkg_pretend() {
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

	if tc-is-gcc && [[ $(gcc-major-version) -lt 7 ]]; then
		die "Minimal compatible gcc version is 7.0. Please, upgrade (or use clang)"
	fi
}

src_prepare() {
	cp -r "${FILESDIR}/cmake" "${S}" || die

	sed -i \
		-e '/-W.*/d' \
		-e '/PIC/a-Wno-error\n-Wno-all' \
		-e "$(usex debug '' 's@-g[a-zA-Z0-9]*@@')" \
		-e "$(usex lto '' 's@-flto@@')" \
		-e "s@-Ofast@@" \
		cmake/options_linux.cmake || die
#		echo > cmake/options_linux.cmake
#		^ Maybe just clean it out instead of trying to fix?
#		^ There is not so mush useful compiler flags, actually.

	sed -i \
		-e '/include.cmake.external.qt.package/d' \
		-e '/include.*options.cmake/ainclude(cmake/external.cmake)' \
		-e '$ainclude(cmake/install.cmake)' \
		CMakeLists.txt || die

# Ideally:
#	sed -i \
#		-e '/add_subdirectory.*external/d' \
#		cmake/CMakeLists.txt || die
# But...
	sed -i \
		-e '/add_subdirectory.auto_updates/d' \
		-e '/add_subdirectory.ffmpeg/d' \
		-e '/add_subdirectory.lz4/d' \
		-e '/add_subdirectory.openal/d' \
		-e '/add_subdirectory.openssl/d' \
		-e '/add_subdirectory.opus/d' \
		-e '/add_subdirectory.qt/d' \
		-e '/add_subdirectory.zlib/d' \
		-e '/add_subdirectory.rlottie/d' \
		-e '/add_subdirectory.gsl/d' \
		-e '/add_subdirectory.xxhash/d' \
		-e '/add_subdirectory.variant/d' \
		-e '/add_subdirectory.ranges/d' \
		-e '/add_subdirectory.iconv/d' \
		cmake/external/CMakeLists.txt || die

	use crash-report || {
		sed -i \
			-e '/external_crash_reports/d' \
			Telegram/lib_base/CMakeLists.txt || die
		sed -i \
			-e '/add_subdirectory.crash_reports/d' \
			cmake/external/CMakeLists.txt || die
	# ^ TODO: patch to use system-wide breakpad
	}

	sed -i \
		-e '/LINK_SEARCH_START_STATIC/d' \
		cmake/init_target.cmake || die

	sed -i \
		-e 's@qt_static_plugins@qt_functions@' \
		-e '/third_party_loc.*minizip/d' \
		-e '/include.cmake.lib_tgvoip/d' \
		-e '/desktop-app::external_auto_updates/d' \
		Telegram/CMakeLists.txt || die

	sed -i \
		-e '1s:^:#include <QtCore/QVersionNumber>\n:' \
		Telegram/SourceFiles/platform/linux/notifications_manager_linux.cpp || die

#	sed -i \
#		-e '/Q_IMPORT_PLUGIN/d' \
#		Telegram/SourceFiles/qt_static_plugins.cpp || die
#		echo > Telegram/SourceFiles/qt_static_plugins.cpp
#		^ Maybe, wipe it out, just in case (even we prevented it to be used)?

	patches_src_prepare
#	cmake-utils_src_prepare
#	^ to be used when will be ported to gentoo repo
}

src_configure() {
	local mycxxflags=(
		${CXXFLAGS}
		-Wno-error=deprecated-declarations
		-DLIBDIR="$(get_libdir)"
		-DTDESKTOP_DISABLE_AUTOUPDATE
		$(usex system-fonts -DTDESKTOP_USE_PACKED_RESOURCES "")
		$(usex openal-eff "" -DTDESKTOP_DISABLE_OPENAL_EFFECTS)
	)

	_isclang && mycxxflags+=("-stdlib=libc++")
	# ^ randomly fails to build otherwise

	local mycmakeargs=(
		-DCMAKE_CXX_FLAGS:="${mycxxflags[*]}"

		# ApiId and ApiHash are from Debian repository:
		# https://salsa.debian.org/debian/telegram-desktop/blob/debian/master/debian/patches/Debian-API-ID.patch#L16
		# The Telegram desktop developer John Preston thinks that Debian id/hash pair can be used in Gentoo ebuild:
		# https://github.com/telegramdesktop/tdesktop/issues/4717#issuecomment-438152135
		-DTDESKTOP_API_ID=$(usex custom-api-id "${TELEGRAM_CUSTOM_API_ID}" "50322")
		-DTDESKTOP_API_HASH=$(usex custom-api-id "${TELEGRAM_CUSTOM_API_HASH}" "9ff1a639196c0779c86dd661af8522ba")

		-DDESKTOP_APP_DISABLE_SPELLCHECK=$(usex spell OFF ON)
		-DDESKTOP_APP_DISABLE_CRASH_REPORTS="$(usex crash-report OFF ON)"

		-DTDESKTOP_DISABLE_GTK_INTEGRATION="$(usex gtk3 OFF ON)"
		-DTDESKTOP_FORCE_GTK_FILE_DIALOG=$(usex gtk-file-dialog ON OFF)
		#-DTDESKTOP_DISABLE_REGISTER_CUSTOM_SCHEME
		#-DTDESKTOP_DISABLE_NETWORK_PROXY

		-DTDESKTOP_API_TEST=$(usex test ON OFF)
	)
#	use crash-report && mycmakeargs+=(
#		-DBREAKPAD_CLIENT_INCLUDE_DIR="/usr/include/breakpad"
#		-DBREAKPAD_CLIENT_LIBRARY="/usr/$(get_libdir)/libbreakpad_client.a"
#	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	default

	local icon_size
	for icon_size in 16 32 48 64 128 256 512; do
		newicon -s "${icon_size}" \
			"${S}/Telegram/Resources/art/icon${icon_size}.png" \
			telegram.png
	done

	newmenu "${S}"/lib/xdg/telegramdesktop.desktop telegram-desktop.desktop
}

pkg_preinst() {
	xdg_pkg_preinst
}

pkg_postinst() {
	xdg_pkg_postinst
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_pkg_postrm
	xdg_icon_cache_update
}
