# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg cmake optfeature flag-o-matic toolchain-funcs

inherit git-r3
# ^ TODO: conditional (only for 9999)? maybe port to tarballs before moving to gentoo repo.
inherit patches
# ^ TODO: drop before moving to gentoo repo, and port to manual selection

DESCRIPTION="Official desktop client for Telegram"
HOMEPAGE="https://desktop.telegram.org"

EGIT_REPO_URI="https://github.com/telegramdesktop/tdesktop.git"
EGIT_SUBMODULES=(
	'*'
	-Telegram/ThirdParty/{xxHash,Catch,lz4,libdbusmenu-qt,fcitx{5,}-qt{,5},hime,hunspell,nimf,qt5ct,range-v3,jemalloc,wayland-protocols,plasma-wayland-protocols,dispatch}
	#,kimageformats,kcoreaddons}
)

if [[ "${PV}" == 9999 ]]; then
	EGIT_BRANCH="dev"
else
	# TODO: tarballs
	EGIT_COMMIT="v${PV}"
	KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
	# ~arm # blocked by range in gentoo-repo
	# ~mipsel # blocked by all :(
fi

LICENSE="GPL-3-with-openssl-exception"
SLOT="0"
IUSE="custom-api-id +dbus debug enchant +hunspell +jemalloc lto pipewire pulseaudio qt6 qt6-imageformats +screencast +system-gsl +system-expected +system-libtgvoip system-rlottie +system-variant test +wayland +webkit +webrtc +X"

REQUIRED_USE="
	^^ ( enchant hunspell )
	webkit? ( dbus )
	qt6-imageformats? ( qt6 )
"

MYPATCHES=(
	"hide-banned"
	"hide-sponsored-messages"
	"wide-baloons"
	"chat-ids"
	"increase-limits"
)
USE_EXPAND_VALUES_TDESKTOP_PATCHES="${MYPATCHES[@]}"
for p in ${MYPATCHES[@]}; do
	IUSE="${IUSE} tdesktop_patches_${p}"
done

KIMAGEFORMATS_RDEPEND="
	media-libs/libavif:=
	media-libs/libheif:=
	media-libs/libjxl
"
# kde-frameworks/kimageformats
# kde-frameworks/kcoreaddons
COMMON_DEPEND="
	!net-im/telegram-desktop-bin
	app-arch/lz4:=
	dev-libs/openssl:=
	dev-libs/xxhash:=
	dev-libs/libdispatch
	dev-libs/libsigc++:2
	media-fonts/open-sans:*
	media-libs/fontconfig:=
	media-libs/rnnoise:=
	media-libs/libyuv:=
	media-libs/openal:=[pipewire=]
	media-libs/opus:=
	media-video/ffmpeg:=[opus,vpx]
	sys-libs/zlib:=[minizip]
	dbus? (
		dev-qt/qtdbus:5
		dev-libs/libdbusmenu-qt[qt5(+)]
		>=dev-cpp/glibmm-2.76
	)
	jemalloc? ( dev-libs/jemalloc:=[-lazy-lock] )
	!qt6? (
		>=dev-qt/qtcore-5.15:5
		>=dev-qt/qtgui-5.15:5[dbus?,jpeg,png,wayland?,X?]
		>=dev-qt/qtimageformats-5.15:5
		>=dev-qt/qtnetwork-5.15:5[ssl]
		>=dev-qt/qtsvg-5.15:5
		>=dev-qt/qtwidgets-5.15:5[png,X?]
		kde-frameworks/kcoreaddons:=
	)
	qt6? (
		dev-qt/qt5compat:6
		dev-qt/qtbase:6[dbus?,gui,network,opengl,widgets,X?]
		dev-qt/qtimageformats:6
		dev-qt/qtsvg:6
		wayland? ( dev-qt/qtwayland:6 )
		qt6-imageformats? ( ${KIMAGEFORMATS_RDEPEND} )
	)
	X? (
		x11-libs/libxcb:=
		x11-libs/xcb-util-keysyms
	)
	pulseaudio? (
		!pipewire? ( media-sound/pulseaudio[daemon(+)] )
	)
	pipewire? (
		media-video/pipewire[sound-server(+)]
		media-sound/pulseaudio[-daemon(+)]
	)
	system-libtgvoip? ( >media-libs/libtgvoip-2.4.4:=[pulseaudio(-)=,pipewire(-)=] )
	system-rlottie? ( >=media-libs/rlottie-0_pre20190818:=[threads(-),-cache(-)] )
	enchant? ( app-text/enchant:= )
	hunspell? ( >=app-text/hunspell-1.7:= )
	webrtc? (
		dev-cpp/abseil-cpp:=
		media-libs/libjpeg-turbo:=
		media-libs/libyuv:=
		dev-libs/openssl:=
		>=media-libs/tg_owt-0_pre20221215[pipewire(-)=,screencast=,X=]
	)
	wayland? (
		kde-frameworks/kwayland:=
		dev-libs/wayland-protocols:=
		dev-libs/plasma-wayland-protocols:=
	)
	webkit? ( net-libs/webkit-gtk:= )
	X? ( x11-libs/libxcb:= )
"

RDEPEND="
	${COMMON_DEPEND}
"
DEPEND="
	${COMMON_DEPEND}
"
BDEPEND="
	${COMMON_DEPEND}
	system-variant? ( dev-cpp/variant:= )
	system-expected? ( >dev-cpp/tl-expected-1.0.0:= )
	system-gsl? ( >dev-cpp/ms-gsl-2.0.0:= )
	>=dev-cpp/range-v3-0.10.0:=
	>=dev-util/cmake-3.16
	virtual/pkgconfig
	amd64? ( dev-lang/yasm )
"

RESTRICT="!test? ( test )"

pkg_pretend() {
	if has_version '>=dev-libs/openssl-3.0'; then
		eerror "!!!!!!!!!!!!!!!"
		eerror "!!! WARNING !!!"
		eerror "!!!!!!!!!!!!!!!"
		eerror ""
		eerror "There is known issue that ${P} can't connect to group audio/video chats if you use >=openssl-3."
		eerror "Also, as for me, it neither able to connect to 1-to-1 calls (even P2P, not only through servers)."
		eerror ""
		eerror "You have been warned!"
		ewarn "Refs:"
		ewarn " - https://github.com/telegramdesktop/tdesktop/issues/26108"
		ewarn " - https://github.com/telegramdesktop/tdesktop/issues/24692"
	fi
	if use wayland && use webkit; then
		ewarn "If you use Wayland as you main graphic system, keep in mind that embedded webview (webkit),"
		ewarn "which is used for payments, may not work on 'clean' wayland (without xwayland mode)."
	fi
	if ! use webrtc; then
		eerror "Telegram Desktop's upstream made webrtc mandatory for build."
		eerror "We're working on patch to make it possible to disable it again, but it isn't ready atm."
		eerror "So, if build will fail - it is not a bug, you've been warned"
	fi
	if use custom-api-id; then
		if [[ -n "${TELEGRAM_CUSTOM_API_ID}" ]] && [[ -n "${TELEGRAM_CUSTOM_API_HASH}" ]]; then
			einfo "${P} was built with your custom ApiId and ApiHash"
		else
			eerror ""
			eerror "It seems you did not set one or both of TELEGRAM_CUSTOM_API_ID and TELEGRAM_CUSTOM_API_HASH variables,"
			eerror "which are required for custom-api-id USE-flag."
			eerror "You can set them either in:"
			eerror "- /etc/portage/make.conf (globally, so all applications you'll build will see that ID and HASH"
			eerror "- /etc/portage/env/${CATEGORY}/${PN} (privately for this package builds)"
			eerror ""
			die "You should correctly set both TELEGRAM_CUSTOM_API_ID and TELEGRAM_CUSTOM_API_HASH variables"
		fi
	fi

	if get-flag -flto >/dev/null || use lto; then
		eerror ""
		eerror "Keep in mind, that building with LTO may take about 20G RAM, and (unstripped) binary size may be about 2.5G."
		if tc-is-clang; then
			eerror ""
			eerror "Qt5 is incompatible with LTO builds using clang at this moment."
			eerror "Ref: https://bugreports.qt.io/browse/QTBUG-61710"
			die "Please, read the error above."
		fi
	fi

	if use system-rlottie; then
		eerror "Currently, ${PN} is totally incompatible with Samsung's rlottie, and uses custom bundled fork."
		eerror "Build will definitelly fail. You've been warned!"
		eerror "Even if you have custom patches to make it build, there is another issue:"
		ewarn ""
		ewarn "Unfortunately, ${PN} uses custom modifications over rlottie"
		ewarn "(which aren't accepted by upstream, since they made it another way)."
		ewarn "This leads to following facts:"
		ewarn "  - Colors replacement maps are not working when you link against system rlottie package."
		ewarn "      That means, for example, that 'giant animated emojis' will ignore skin-tone colors"
		ewarn "      and will always be yellow"
		ewarn "      Ref: https://github.com/Samsung/rlottie/pull/252"
		ewarn "  - Crashes on some stickerpacks"
		ewarn "      Probably related to: https://github.com/Samsung/rlottie/pull/262"
	fi
}

src_unpack() {
	use system-gsl && EGIT_SUBMODULES+=(-Telegram/ThirdParty/GSL)
	use system-expected && EGIT_SUBMODULES+=(-Telegram/ThirdParty/expected)
	use system-libtgvoip && EGIT_SUBMODULES+=(-Telegram/ThirdParty/libtgvoip)
	use system-variant && EGIT_SUBMODULES+=(-Telegram/ThirdParty/variant)
	use system-rlottie && EGIT_SUBMODULES+=(-Telegram/{lib_rlottie,ThirdParty/rlottie})
	# ^ Ref: https://bugs.gentoo.org/752417

	git-r3_src_unpack
}

src_prepare() {
	use system-rlottie || (
	# Ref: https://bugs.gentoo.org/752417
		sed -i \
			-e 's/DESKTOP_APP_USE_PACKAGED/0/' \
			cmake/external/rlottie/CMakeLists.txt || die
	)

	sed -i \
		-e '/-W.*/d' \
		-e '/PIC/a-Wno-error\n-Wno-all' \
		-e "$(usex debug '' 's@-g[a-zA-Z0-9]*@@')" \
		-e "$(usex lto '' 's@-flto@@')" \
		-e "s@-Ofast@@" \
		cmake/options_linux.cmake || die

#		echo > cmake/options_linux.cmake
#		^ Maybe just wipe it out instead of trying to fix?
#		^ There are not so mush useful compiler flags, actually.

	# Bundle kde-frameworks/kimageformats for qt6, since it's impossible to
	#   build in gentoo right now.
	if use qt6-imageformats; then
		sed -e 's/DESKTOP_APP_USE_PACKAGED_LAZY/TRUE/' -i \
			cmake/external/kimageformats/CMakeLists.txt || die
		printf "%s\n" \
			'Q_IMPORT_PLUGIN(QAVIFPlugin)' \
			'Q_IMPORT_PLUGIN(HEIFPlugin)' \
			'Q_IMPORT_PLUGIN(QJpegXLPlugin)' \
			>> cmake/external/qt/qt_static_plugins/qt_static_plugins.cpp || die
	fi

	# kde-frameworks/kcoreaddons is bundled when using qt6, see:
	#   cmake/external/kcoreaddons/CMakeLists.txt

	patches_src_prepare
#	cmake_src_prepare
#	^ to be used when will be ported to gentoo repo
}

src_configure() {
	filter-flags '-DDEBUG' # produces bugs in bundled forks of 3party code
	append-cppflags '-DNDEBUG' # Telegram sets that in code
	# (and I also forced that here and in libtgvoip ebuild to have the same behaviour),
	# and segfaults on voice calls on mismatch
	# (if tg was built with it, and deps are built without it, and vice versa)
	use lto && (
		append-flags '-flto'
		append-ldflags '-flto'
	)
	local mycxxflags=(
		${CXXFLAGS}
		-Wno-error=deprecated-declarations
		-Wno-deprecated-declarations
		-Wno-switch
		-DLIBDIR="$(get_libdir)"
		-DTDESKTOP_DISABLE_AUTOUPDATE
		$(usex webrtc "" "-DDESKTOP_APP_DISABLE_WEBRTC_INTEGRATION")
		$(usex webkit "" "-DDESKTOP_APP_DISABLE_WEBKITGTK")
		# Currently, only needs for "paymens" functionality, and also doesn't work on Wayland, and also with mutter WM.
	)

	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_tl-expected=$(usex !system-expected)  # header only lib, some git version. prevents warnings.
		-DQT_VERSION_MAJOR=$(usex qt6 6 5)

		-DCMAKE_CXX_FLAGS:="${mycxxflags[*]}"

		# Qt6 is masked in Gentoo at the moment.
		# -DDESKTOP_APP_QT6=OFF

		# Upstream does not need crash reports from custom builds anyway
		-DDESKTOP_APP_DISABLE_CRASH_REPORTS=ON

		-DDESKTOP_APP_USE_ENCHANT=$(usex enchant)  # enables enchant and disables hunspell

		# Unbundling:
		-DDESKTOP_APP_USE_PACKAGED=ON # Main

		-DDESKTOP_APP_DISABLE_DBUS_INTEGRATION=$(usex !dbus)

		-DDESKTOP_APP_DISABLE_JEMALLOC=$(usex !jemalloc)

		-DDESKTOP_APP_DISABLE_WAYLAND_INTEGRATION="$(usex !wayland)"

		-DDESKTOP_APP_DISABLE_X11_INTEGRATION=$(usex !X)

		$(usex webrtc "" "-DDESKTOP_APP_DISABLE_WEBRTC_INTEGRATION=ON")

		$(usex lto "-DCMAKE_INTERPROCEDURAL_OPTIMIZATION=ON" '')

		-DTDESKTOP_API_TEST=$(usex test)

		# Snapcraft (snap, flatpack, whatever) API keys:
		# As of my discussion with John Preston, he specifically asked TG servers owners to never ban snap's keys:
		# TODO: (!!!!!!!) Ask Gentoo Council (or whatever) to get "official" Gentoo keys.
		-DTDESKTOP_API_ID=$(usex custom-api-id "${TELEGRAM_CUSTOM_API_ID}" "611335")
		-DTDESKTOP_API_HASH=$(usex custom-api-id "${TELEGRAM_CUSTOM_API_HASH}" "d524b414d21f4d37f08684c1df41ac9c")

#		-DDESKTOP_APP_LOTTIE_USE_CACHE=NO
#		# in case of caching bugs. Maybe also useful with system-rlottie[cache]. TODO: test that idea.
	)
	cmake_src_configure
}

pkg_preinst() {
	xdg_pkg_preinst
}

pkg_postinst() {
	xdg_pkg_postinst
	if ! use X && ! use screencast; then
		ewarn "both the 'X' and 'screencast' USE flags are disabled, screen sharing won't work!"
		ewarn
	fi
	if has_version '<dev-qt/qtcore-5.15.2-r10'; then
		ewarn "Versions of dev-qt/qtcore lower than 5.15.2-r10 might cause telegram"
		ewarn "to crash when pasting big images from the clipboard."
		ewarn
	fi
	if ! use jemalloc && use elibc_glibc; then
		# https://github.com/telegramdesktop/tdesktop/issues/16084
		# https://github.com/desktop-app/cmake_helpers/pull/91#issuecomment-881788003
		ewarn "Disabling USE=jemalloc on glibc systems may cause very high RAM usage!"
		ewarn "Do NOT report issues about RAM usage without enabling this flag first."
		ewarn
	fi
	if use qt6; then
		ewarn "Qt6 support in gentoo is experimental."
		ewarn "Please report any issues you may find, but don't expect"
		ewarn "everything to work correctly as of yet."
		ewarn
	fi
	if use wayland && ! use qt6; then
		ewarn "Wayland-specific integrations have been deprecated with Qt5."
		ewarn "The app will continue to function under wayland, but some"
		ewarn "functionality may be reduced."
		ewarn "These integrations are only supported when built with Qt6."
		ewarn
	fi
	if use qt6 && ! use qt6-imageformats; then
		elog "Enable USE=qt6-imageformats for AVIF, HEIF and JpegXL support"
		elog
	fi
	optfeature_header
	optfeature "shop payment support (requires USE=dbus enabled)" net-libs/webkit-gtk:4
	if ! use qt6; then
		optfeature "AVIF, HEIF and JpegXL image support" kde-frameworks/kimageformats[avif,heif,jpegxl]
	fi
}

pkg_postrm() {
	xdg_pkg_postrm
}
