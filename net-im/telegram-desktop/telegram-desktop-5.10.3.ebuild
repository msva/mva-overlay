# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg cmake optfeature flag-o-matic

inherit patches
# ^ TODO: drop before moving to gentoo repo, and port to manual selection

inherit git-r3
# ^ TODO: conditional (only for 9999)? maybe port to tarballs before moving to gentoo repo.
EGIT_REPO_URI="https://github.com/telegramdesktop/tdesktop.git"
EGIT_SUBMODULES=(
	'*'
	-Telegram/ThirdParty/{xxHash,Catch,lz4,libdbusmenu-qt,fcitx{5,}-qt{,5},hime,hunspell,nimf,qt5ct,range-v3,jemalloc,wayland-protocols,plasma-wayland-protocols,xdg-desktop-portal}
	#,kimageformats,kcoreaddons}
)

DESCRIPTION="Official desktop client for Telegram"
HOMEPAGE="https://desktop.telegram.org"

LICENSE="GPL-3-with-openssl-exception"
SLOT="0"

if [[ "${PV}" = 9999* ]]; then
	EGIT_BRANCH="dev"
else
	# TODO: tarballs
	EGIT_COMMIT="v${PV}"
fi
# 👇 kludge for eix
[[ "${PV}" = 9999* ]] || KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
# 👆 kludge for eix

IUSE="custom-api-id +dbus debug enchant +fonts +hunspell +jemalloc lto pipewire pulseaudio qt6 qt6-imageformats +screencast +system-libtgvoip test +wayland +webkit +X"
# +system-gsl

REQUIRED_USE="
	^^ ( enchant hunspell )
	qt6-imageformats? ( qt6 )
"

MYPATCHES=(
	"allow-disable-stories"
	"hide-banned"
	"hide-sponsored-messages"
	"wide-baloons"
	"chat-ids"
	"increase-limits"
	"ignore-restrictions"
)
USE_EXPAND_VALUES_TDESKTOP_PATCHES="${MYPATCHES[@]}"
for p in ${MYPATCHES[@]}; do
	IUSE="${IUSE} tdesktop_patches_${p}"
done

KIMAGEFORMATS_RDEPEND="
	media-libs/libavif:=
	media-libs/libheif:=
	>=media-libs/libjxl-0.8.0:=
"
# kde-frameworks/kimageformats
# kde-frameworks/kcoreaddons
COMMON_DEPEND="
	!net-im/telegram-desktop-bin
	app-arch/lz4:=
	>=dev-cpp/abseil-cpp-20240116.2:=
	>=dev-libs/glib-2.77:2
	>=dev-libs/gobject-introspection-1.77
	dev-libs/libdispatch
	dev-libs/openssl:=
	>=dev-libs/protobuf-27.2
	dev-libs/xxhash
	media-libs/libjpeg-turbo:=
	system-libtgvoip? ( >media-libs/libtgvoip-2.4.4:=[pulseaudio(-)=,pipewire(-)=] )
	media-libs/openal:=[pipewire=]
	media-libs/opus:=
	media-libs/rnnoise:=
	>=media-libs/tg_owt-0_pre20240731:=[pipewire(-)=,screencast=,X=]
	media-video/ffmpeg:=[opus,vpx]
	sys-libs/zlib:=[minizip]
	virtual/opengl
	enchant? ( app-text/enchant:= )
	hunspell? ( >=app-text/hunspell-1.7:= )
	jemalloc? ( dev-libs/jemalloc:=[-lazy-lock] )
	!qt6? (
		>=dev-qt/qtcore-5.15:5=
		>=dev-qt/qtgui-5.15:5=[dbus?,jpeg,png,wayland?,X?]
		>=dev-qt/qtimageformats-5.15:5=
		>=dev-qt/qtnetwork-5.15:5=[ssl]
		>=dev-qt/qtsvg-5.15:5=
		>=dev-qt/qtwidgets-5.15:5=[png,X?]
		kde-frameworks/kcoreaddons:5=
		wayland? (
			dev-qt/qtwayland:5=
		)
		webkit? (
			>=dev-qt/qtdeclarative-5.15:5=
			>=dev-qt/qtwayland-5.15:5=[compositor(+)]
		)
		dbus? (
			dev-qt/qtdbus:5=
			dev-libs/libdbusmenu-qt[qt5(+)]
		)
	)
	qt6? (
		>=dev-qt/qtbase-6.5:6=[dbus?,gui,network,opengl,wayland?,widgets,X?]
		>=dev-qt/qtimageformats-6.5:6=
		>=dev-qt/qtsvg-6.5:6=
		wayland? ( >=dev-qt/qtwayland-6.5:6=[compositor,qml] )
		webkit? (
			>=dev-qt/qtdeclarative-6.5:6
			>=dev-qt/qtwayland-6.5:6[compositor]
		)
		qt6-imageformats? (
			>=dev-qt/qtimageformats-6.5:6=
			${KIMAGEFORMATS_RDEPEND}
		)
	)
	X? (
		x11-libs/libxcb:=
		x11-libs/xcb-util-keysyms
	)
	dev-libs/ada
	dev-libs/boost:=
	dev-libs/libfmt:=
	!fonts? ( media-fonts/open-sans )
	media-libs/fontconfig:=
	pulseaudio? (
		!pipewire? ( media-sound/pulseaudio-daemon )
	)
	pipewire? (
		media-video/pipewire[sound-server(+)]
		!media-sound/pulseaudio-daemon
	)
	wayland? (
		kde-plasma/kwayland:=
		dev-libs/wayland-protocols:=
		dev-libs/plasma-wayland-protocols:=
	)
	sys-apps/xdg-desktop-portal:=
"
	# dev-libs/libsigc++:2
	# >=dev-cpp/glibmm-2.77:2.68

RDEPEND="
	${COMMON_DEPEND}
	webkit? (
		|| (
			net-libs/webkit-gtk:4.1
			net-libs/webkit-gtk:6
		)
	)
"
DEPEND="
	${COMMON_DEPEND}
	>=dev-cpp/cppgir-2.0_p20240315
	dev-cpp/range-v3
"
	# system-expected? ( dev-cpp/expected-lite )
	# system-gsl? ( >=dev-cpp/ms-gsl-4.1 )
	# 👆 currently it's buildsystem anyway uses system one if it is anyhow installed
BDEPEND="
	>=dev-cpp/ms-gsl-4.1
	>=dev-build/cmake-3.16
	>=dev-cpp/cppgir-2.0_p20240315
	dev-util/gdbus-codegen
	virtual/pkgconfig
	wayland? ( dev-util/wayland-scanner )
	amd64? ( dev-lang/yasm )
"

RESTRICT="!test? ( test )"

pkg_pretend() {
	for p in ${MYPATCHES[@]}; do
		if use "tdesktop_patches_${p}"; then
			tdesktop_patches_warn=1
		fi
	done
	if [[ -n "${tdesktop_patches_warn}" ]]; then
		ewarn "!!!!!!!!!!!!!!!!!!!!!!!!!"
		ewarn "!!!!!!!! WARNING !!!!!!!"
		ewarn "!!!!!!!!!!!!!!!!!!!!!!!!!"
		ewarn "You have enabled some custom patches!"
		ewarn "Some of them can violate TOS of Telegram and can (but non necessary will) lead to ban of your account on TG main network."
		ewarn "Please, be careful."
		einfo "Also, note that none of that patches have any chance to be ported to ${PN} ebuild in Gentoo repo"
	fi

	if ! use wayland || ! use qt6; then
		ewarn ""
		ewarn "Keep in mind that embedded webview (based on webkit), may not work in runtime."
		ewarn "Upstream has reworked it in sych way that it only guaranteed to work under Wayland+Qt6"
		ewarn ""
	fi
	if use custom-api-id; then
		if [[ -n "${TELEGRAM_CUSTOM_API_ID}" ]] && [[ -n "${TELEGRAM_CUSTOM_API_HASH}" ]]; then
			einfo ""
			einfo "${P} was built with your custom ApiId and ApiHash"
			einfo ""
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

	# if use system-rlottie; then
	# 	eerror ""
	# 	eerror "Currently, ${PN} is totally incompatible with Samsung's rlottie, and uses custom bundled fork."
	# 	eerror "Build will definitelly fail. You've been warned!"
	# 	eerror "Even if you have custom patches to make it build, there is another issue:"
	# 	ewarn ""
	# 	ewarn "Unfortunately, ${PN} uses custom modifications over rlottie"
	# 	ewarn "(which aren't accepted by upstream, since they made it another way)."
	# 	ewarn "This leads to following facts:"
	# 	ewarn "  - Colors replacement maps are not working when you link against system rlottie package."
	# 	ewarn "      That means, for example, that 'giant animated emojis' will ignore skin-tone colors"
	# 	ewarn "      and will always be yellow"
	# 	ewarn "      Ref: https://github.com/Samsung/rlottie/pull/252"
	# 	ewarn "  - Crashes on some stickerpacks"
	# 	ewarn "      Probably related to: https://github.com/Samsung/rlottie/pull/262"
	# 	ewarn ""
	# fi
	if has ccache ${FEATURES}; then
		ewarn "ccache does not work with ${PN} out of the box"
		ewarn "due to usage of precompiled headers"
		ewarn "check bug https://bugs.gentoo.org/715114 for more info"
		ewarn
	fi
}

src_unpack() {
	use system-gsl && EGIT_SUBMODULES+=(-Telegram/ThirdParty/GSL)

#	# XXX: maybe de-unbundle those? Anyway, they're header-only libraries...
#	#  Moreover, upstream recommends to use bundled versions to avoid artefacts 🤷
#	use system-expected && EGIT_SUBMODULES+=(-Telegram/ThirdParty/expected)

	( use arm && ! use arm64 ) || EGIT_SUBMODULES+=(-Telegram/ThirdParty/dispatch)
	use system-libtgvoip && EGIT_SUBMODULES+=(-Telegram/ThirdParty/libtgvoip)

#	use system-rlottie && EGIT_SUBMODULES+=(-Telegram/{lib_rlottie,ThirdParty/rlottie})
	# ^ Ref: https://bugs.gentoo.org/752417

	git-r3_src_unpack
}

src_prepare() {
	# use system-rlottie || (
	# # Ref: https://bugs.gentoo.org/752417
	# 	sed -i \
	# 		-e 's/DESKTOP_APP_USE_PACKAGED/0/' \
	# 		cmake/external/rlottie/CMakeLists.txt || die
	# )

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

	# Happily fail if libraries aren't found...
	find -type f \( -name 'CMakeLists.txt' -o -name '*.cmake' \) \
		\! -path './Telegram/lib_webview/CMakeLists.txt' \
		\! -path "./cmake/external/expected/CMakeLists.txt" \
		\! -path './cmake/external/kcoreaddons/CMakeLists.txt' \
		\! -path './cmake/external/qt/package.cmake' \
		\! -path './Telegram/lib_webview/CMakeLists.txt' \
		-print0 | xargs -0 sed -i \
		-e '/pkg_check_modules(/s/[^ ]*)/REQUIRED &/' \
		-e '/find_package(/s/)/ REQUIRED)/' || die
	# Make sure to check the excluded files for new
	# CMAKE_DISABLE_FIND_PACKAGE entries.

	# Control QtDBus dependency from here, to avoid messing with QtGui.
	if ! use dbus; then
		sed -e '/find_package(Qt[^ ]* OPTIONAL_COMPONENTS/s/DBus *//' \
			-i cmake/external/qt/package.cmake || die
	fi

	# HACK: tmp (nothing is more persistent than temporary, hehe)
	sed -r \
		-e '1i#include <QJsonObject>' \
		-i "${S}/Telegram/SourceFiles/payments/smartglocal/smartglocal_card.h" \
			"${S}/Telegram/SourceFiles/payments/smartglocal/smartglocal_error.h" || die

	# Use system xdg-portal things
	sed -r \
		-e '/generate_dbus\([^ ]*\ org.freedesktop.portal/{s@\$\{third_party_loc\}/xdg-desktop-portal/data@/usr/share/dbus-1/interfaces@}' \
		-i "${S}/Telegram/lib_base/CMakeLists.txt" "${S}/Telegram/CMakeLists.txt" || die

	patches_src_prepare
# cmake_src_prepare
#	^ to be used when will be ported to gentoo repo
}

src_configure() {
	append-flags '-fpch-preprocess' # ccache compatibility.
	# ^ see https://bugs.gentoo.org/715114

	# Having user paths sneak into the build environment through the
	# XDG_DATA_DIRS variable causes all sorts of weirdness with cppgir:
	# - bug 909038: can't read from flatpak directories (fixed upstream)
	# - bug 920819: system-wide directories ignored when variable is set
	export XDG_DATA_DIRS="${EPREFIX}/usr/share"

	# Evil flag (bug #919201)
	filter-flags -fno-delete-null-pointer-checks

	# The ABI of media-libs/tg_owt breaks if the -DNDEBUG flag doesn't keep
	# the same state across both projects.
	# See https://bugs.gentoo.org/866055
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
		# XXX: temp (I hope) kludge (until abseil-cpp-2025+ will be in tree)
		-I/usr/include/tg_owt/third_party/abseil-cpp
	)

	local qt=$(usex qt6 6 5)
	local mycmakeargs=(
		# -DCMAKE_DISABLE_FIND_PACKAGE_tl-expected=$(usex !system-expected)
		# ^ header only lib, some git version. prevents warnings.

		-DQT_VERSION_MAJOR=${qt}

		# Override new cmake.eclass defaults (https://bugs.gentoo.org/921939)
		# Upstream never tests this any other way
		-DCMAKE_DISABLE_PRECOMPILE_HEADERS=OFF

		# Control automagic dependencies on certain packages
		## Header-only lib, some git version.
		-DCMAKE_DISABLE_FIND_PACKAGE_tl-expected=ON
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt${qt}Quick=$(usex !webkit)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt${qt}QuickWidgets=$(usex !webkit)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt${qt}WaylandClient=$(usex !wayland)
		## Only used in Telegram/lib_webview/CMakeLists.txt
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt${qt}WaylandCompositor=$(usex !webkit)
		## KF6CoreAddons is currently unavailable in ::gentoo
		-DCMAKE_DISABLE_FIND_PACKAGE_KF${qt}CoreAddons=$(usex qt6)

		-DCMAKE_CXX_FLAGS:="${mycxxflags[*]}"

		# Upstream does not need crash reports from custom builds anyway
		-DDESKTOP_APP_DISABLE_CRASH_REPORTS=ON

		-DDESKTOP_APP_USE_ENCHANT=$(usex enchant)  # enables enchant and disables hunspell

		# Unbundling:
		-DDESKTOP_APP_USE_PACKAGED=ON # Main

		-DDESKTOP_APP_DISABLE_X11_INTEGRATION=$(usex !X)
		# -DDESKTOP_APP_DISABLE_WAYLAND_INTEGRATION="$(usex !wayland)"
		-DDESKTOP_APP_DISABLE_JEMALLOC=$(usex !jemalloc)

		$(usex lto "-DCMAKE_INTERPROCEDURAL_OPTIMIZATION=ON" '')

		-DTDESKTOP_API_TEST=$(usex test)

		## Use system fonts instead of bundled ones
		-DDESKTOP_APP_USE_PACKAGED_FONTS=$(usex !fonts)

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
	if ! use jemalloc && use elibc_glibc; then
		# https://github.com/telegramdesktop/tdesktop/issues/16084
		# https://github.com/desktop-app/cmake_helpers/pull/91#issuecomment-881788003
		ewarn "Disabling USE=jemalloc on glibc systems may cause very high RAM usage!"
		ewarn "Do NOT report issues about RAM usage without enabling this flag first."
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
	if ! use qt6; then
		optfeature "AVIF, HEIF and JpegXL image support" kde-frameworks/kimageformats[avif,heif,jpegxl]
	fi
}

pkg_postrm() {
	xdg_pkg_postrm
}
