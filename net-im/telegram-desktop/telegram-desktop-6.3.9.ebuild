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
	-Telegram/ThirdParty/{xxHash,Catch,lz4,libdbusmenu-qt,fcitx{5,}-qt{,5},hime,hunspell,nimf,qt5ct,range-v3,wayland-protocols,plasma-wayland-protocols,xdg-desktop-portal,GSL,kimageformats,kcoreaddons,expected,cld3,QR}
	# 👆 buildsystem anyway uses system ms-gsl if it is installed, so, no need for bundled, imho 🤷
	-Telegram/ThirdParty/libtgvoip
	# 👆 devs said it is not used anymore (but I found that it's submodule is still in the repo)
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
[[ "${PV}" = 9999* ]] || KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
# 👆 kludge for eix

IUSE="custom-api-id +dbus debug enchant +fonts +hunspell +libdispatch lto pipewire pulseaudio +screencast test +wayland +webkit +X"
# +system-gsl

REQUIRED_USE="
	^^ ( enchant hunspell )
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

COMMON_DEPEND="
	!net-im/telegram-desktop-bin
	app-arch/lz4:=
	>=dev-cpp/abseil-cpp-20240116.2:=
	dev-cpp/ada
	dev-cpp/cld3:=
	dev-libs/boost:=
	>=dev-libs/glib-2.77:2
	>=dev-libs/gobject-introspection-1.77
	libdispatch? ( dev-libs/libdispatch )
	dev-libs/libfmt:=
	dev-libs/openssl:=
	>=dev-libs/protobuf-27.2
	dev-libs/qr-code-generator:=
	dev-libs/xxhash
	>=dev-qt/qtbase-6.5:6=[dbus?,gui,network,opengl,wayland?,widgets,X?]
	>=dev-qt/qtimageformats-6.5:6=
	>=dev-qt/qtsvg-6.5:6=
	enchant? ( app-text/enchant:= )
	!fonts? ( media-fonts/open-sans )
	hunspell? ( >=app-text/hunspell-1.7:= )
	kde-frameworks/kcoreaddons:6=
	kde-frameworks/kimageformats:6=[avif,heif,jpegxl]
	media-libs/fontconfig:=
	media-libs/libjpeg-turbo:=
	media-libs/openal:=[pipewire=]
	media-libs/opus:=
	media-libs/rnnoise:=
	>=media-libs/tg_owt-0_pre20250501:=[pipewire(+)=,screencast=,X=]
	media-video/ffmpeg:=[opus,vpx]
	sys-apps/xdg-desktop-portal:=
	virtual/minizip:=
	virtual/opengl
	pulseaudio? (
		!pipewire? ( media-sound/pulseaudio-daemon )
	)
	pipewire? (
		media-video/pipewire[sound-server(+)]
		!media-sound/pulseaudio-daemon
	)
	wayland? (
		>=dev-qt/qtwayland-6.5:6=[compositor(+),qml]
		kde-plasma/kwayland:=
		dev-libs/wayland-protocols:=
		dev-libs/plasma-wayland-protocols:=
	)
	webkit? ( wayland? (
		>=dev-qt/qtdeclarative-6.5:6
		>=dev-qt/qtwayland-6.5:6[compositor(+)]
		) )
	X? (
		x11-libs/libxcb:=
		x11-libs/xcb-util-keysyms
	)
"
	# dev-libs/libsigc++:2
	# >=dev-cpp/glibmm-2.77:2.68
# XXX: 👆 qtwayland >= 6.10.0 missing 'compositor' USE-flag,
# and I'm not 100% sure if it really defaults to build wayland server
# (as in called in 6.9) anyway, or it moved somewhere outside dev-qt/*
# (as I didn't find it anymore)

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
	net-libs/tdlib:=[tde2e(-)]
	dev-cpp/expected
	dev-cpp/expected-lite
"
	# 👆tdlib builds static libs, and so tdesktop links statically, so, no need to be in RDEPEND
	#
	# system-expected? ( dev-cpp/expected-lite )
	# system-gsl? ( >=dev-cpp/ms-gsl-4.1 )
	# 👆 currently it's buildsystem anyway uses system one if it is anyhow installed
BDEPEND="
	amd64? ( dev-lang/yasm )
	>=dev-build/cmake-3.16
	>=dev-cpp/cppgir-2.0_p20240315
	>=dev-cpp/ms-gsl-4.1
	dev-util/gdbus-codegen
	virtual/pkgconfig
	wayland? ( dev-util/wayland-scanner )
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

	if [[ ${MERGE_TYPE} != binary ]]; then
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
		if has ccache ${FEATURES}; then
			ewarn "ccache does not work with ${PN} out of the box"
			ewarn "due to usage of precompiled headers"
			ewarn "check bug https://bugs.gentoo.org/715114 for more info"
			ewarn
		fi
		if tc-is-clang && [[ $(tc-get-cxx-stdlib) = libstdc++ ]]; then
			ewarn "this package frequently fails to compile with clang"
			ewarn "in combination with libstdc++."
			ewarn "please use libc++, or build this package with gcc."
			ewarn "(if you have a patch or a fix, please open a"
			ewarn "bug report about it)"
			ewarn
		fi
	fi
}

src_unpack() {
	# use system-gsl && EGIT_SUBMODULES+=(-Telegram/ThirdParty/GSL)

#	# XXX: maybe de-unbundle those? Anyway, they're header-only libraries...
#	#  Moreover, upstream recommends to use bundled versions to avoid artefacts 🤷
#	use system-expected && EGIT_SUBMODULES+=(-Telegram/ThirdParty/expected)

	( use arm && ! use arm64 ) || EGIT_SUBMODULES+=(-Telegram/ThirdParty/dispatch)

	git-r3_src_unpack
}

src_prepare() {
	# Happily fail if libraries aren't found...
	find -type f \( -name 'CMakeLists.txt' -o -name '*.cmake' \) \
		\! -path './Telegram/lib_webview/CMakeLists.txt' \
		\! -path './cmake/external/kcoreaddons/CMakeLists.txt' \
		\! -path './cmake/external/lz4/CMakeLists.txt' \
		\! -path './cmake/external/opus/CMakeLists.txt' \
		\! -path './cmake/external/xxhash/CMakeLists.txt' \
		\! -path './cmake/external/qt/package.cmake' \
		\! -path './Telegram/lib_webview/CMakeLists.txt' \
		-print0 | xargs -0 sed -i \
		-e '/pkg_check_modules(/s/[^ ]*)/REQUIRED &/' \
		-e '/find_package(/s/)/ REQUIRED)/' \
		-e '/find_library(/s/)/ REQUIRED)/' || die
		# \! -path "./cmake/external/expected/CMakeLists.txt" \
		# \! -path './cmake/external/kimageformats/CMakeLists.txt' \
	# Make sure to check the excluded files for new
	# CMAKE_DISABLE_FIND_PACKAGE entries.

	# Some packages are found through pkg_check_modules, rather than find_package
	sed -e '/find_package(lz4 /d' -i cmake/external/lz4/CMakeLists.txt || die
	sed -e '/find_package(Opus /d' -i cmake/external/opus/CMakeLists.txt || die
	sed -e '/find_package(xxHash /d' -i cmake/external/xxhash/CMakeLists.txt || die

	# Greedily remove ThirdParty directories, keep only ones that interest us
	local keep=(
		rlottie  # Patched, not recommended to unbundle by upstream
		libprisma  # Telegram-specific library, no stable releases
		tgcalls  # Telegram-specific library, no stable releases
		# xdg-desktop-portal  # Only a few xml files are used with gdbus-codegen
	)
	for x in Telegram/ThirdParty/*; do
		has "${x##*/}" "${keep[@]}" || rm -r "${x}" || die
	done

	# Control QtDBus dependency from here, to avoid messing with QtGui.
	if ! use dbus; then
		sed -e '/find_package(Qt[^ ]* OPTIONAL_COMPONENTS/s/DBus *//' \
			-i cmake/external/qt/package.cmake || die
	fi

	# XXX: checking if it is non needed anymore. Ping me if I pushed that to GH
	# # HACK: tmp (nothing is more persistent than temporary, hehe)
	# sed -r \
	# 	-e '1i#include <QJsonObject>' \
	# 	-i "${S}/Telegram/SourceFiles/payments/smartglocal/smartglocal_card.h" \
	# 		"${S}/Telegram/SourceFiles/payments/smartglocal/smartglocal_error.h" || die

	# Use system xdg-portal things
	sed -r \
		-e '/generate_dbus\([^ ]*\ org.freedesktop.portal/{s@\$\{third_party_loc\}/xdg-desktop-portal/data@/usr/share/dbus-1/interfaces@}' \
		-i "${S}/Telegram/lib_base/CMakeLists.txt" "${S}/Telegram/CMakeLists.txt" || die

	# Control automagic dep only needed when USE="webkit wayland"
	if ! use webkit || ! use wayland; then
		sed -e 's/QT_CONFIG(wayland_compositor_quick)/0/' \
			-i Telegram/lib_webview/webview/platform/linux/webview_linux_compositor.h || die
	fi

	# Shut the CMake 4 QA checker up by removing unused CMakeLists files
	rm Telegram/ThirdParty/rlottie/CMakeLists.txt || die
	rm cmake/external/glib/cppgir/expected-lite/example/CMakeLists.txt || die
	rm cmake/external/glib/cppgir/expected-lite/test/CMakeLists.txt || die
	rm cmake/external/glib/cppgir/expected-lite/CMakeLists.txt || die

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
		# -I/usr/include/tg_owt/third_party/abseil-cpp
	)

	# https://github.com/telegramdesktop/tdesktop/issues/17437#issuecomment-1001160398
	use !libdispatch && append-cppflags -DCRL_FORCE_QT

	local no_webkit_wayland=$(use webkit && use wayland && echo no || echo yes)
	local use_webkit_wayland=$(use webkit && use wayland && echo yes || echo no)
	local mycmakeargs=(
		-DQT_VERSION_MAJOR=6

		# Override new cmake.eclass defaults (https://bugs.gentoo.org/921939)
		# Upstream never tests this any other way
		-DCMAKE_DISABLE_PRECOMPILE_HEADERS=OFF

		# Control automagic dependencies on certain packages
		## Header-only lib, some git version.
		# -DCMAKE_DISABLE_FIND_PACKAGE_tl-expected=ON

		# Control automagic dependencies on certain packages
		## These libraries are only used in lib_webview, for wayland
		## See Telegram/lib_webview/webview/platform/linux/webview_linux_compositor.h
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6Quick=${no_webkit_wayland}
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6QuickWidgets=${no_webkit_wayland}
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6WaylandCompositor=${no_webkit_wayland}

		# Make sure dependencies that aren't patched to be REQUIRED in
		# src_prepare, are found.  This was suggested to me by the telegram
		# devs, in lieu of having explicit flags in the build system.
		-DCMAKE_REQUIRE_FIND_PACKAGE_Qt6DBus=$(usex dbus)
		-DCMAKE_REQUIRE_FIND_PACKAGE_Qt6Quick=${use_webkit_wayland}
		-DCMAKE_REQUIRE_FIND_PACKAGE_Qt6QuickWidgets=${use_webkit_wayland}
		-DCMAKE_REQUIRE_FIND_PACKAGE_Qt6WaylandCompositor=${use_webkit_wayland}

		# -DCMAKE_DISABLE_FIND_PACKAGE_KF6CoreAddons=ON

		-DCMAKE_CXX_FLAGS:="${mycxxflags[*]}"

		# Upstream does not need crash reports from custom builds anyway
		-DDESKTOP_APP_DISABLE_CRASH_REPORTS=ON

		-DDESKTOP_APP_USE_ENCHANT=$(usex enchant)  # enables enchant and disables hunspell

		# Unbundling:
		-DDESKTOP_APP_USE_PACKAGED=ON # Main

		-DDESKTOP_APP_DISABLE_X11_INTEGRATION=$(usex !X)
		# -DDESKTOP_APP_DISABLE_WAYLAND_INTEGRATION="$(usex !wayland)"

		$(usex lto "-DCMAKE_INTERPROCEDURAL_OPTIMIZATION=ON" '')

		-DTDESKTOP_API_TEST=$(usex test)

		## Use system fonts instead of bundled ones
		-DDESKTOP_APP_USE_PACKAGED_FONTS=$(usex !fonts)

		# Snapcraft (snap, flatpack, whatever) API keys:
		# As of my discussion with John Preston, he specifically asked TG servers owners to never ban snap's keys:
		# TODO: (!!!!!!!) Ask Gentoo Council (or whatever) to get "official" Gentoo keys.
		-DTDESKTOP_API_ID=$(usex custom-api-id "${TELEGRAM_CUSTOM_API_ID}" "611335")
		-DTDESKTOP_API_HASH=$(usex custom-api-id "${TELEGRAM_CUSTOM_API_HASH}" "d524b414d21f4d37f08684c1df41ac9c")

		-DDESKTOP_APP_DISABLE_QT_PLUGINS=ON

#		-DDESKTOP_APP_LOTTIE_USE_CACHE=NO
#		# in case of caching bugs. Maybe also useful with system-rlottie[cache]. TODO: test that idea.

		## See tdesktop-*-libdispatch.patch
		-DDESKTOP_APP_USE_LIBDISPATCH=$(usex libdispatch)
	)
	cmake_src_configure
}

src_compile() {
	# There's a bug where sometimes, it will rebuild/relink during src_install
	# Make sure that happens here, instead.
	cmake_build
	cmake_build
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
	if ! use libdispatch; then
		ewarn "Disabling USE=libdispatch may cause performance degradation"
		ewarn "due to fallback to poor QThreadPool! Please see"
		ewarn "https://github.com/telegramdesktop/tdesktop/wiki/The-Packaged-Building-Mode"
		ewarn
	fi
	optfeature_header
	optfeature "AVIF, HEIF and JpegXL image support" kde-frameworks/kimageformats[avif,heif,jpegxl]
}

pkg_postrm() {
	xdg_pkg_postrm
}
