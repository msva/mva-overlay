# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake flag-o-matic toolchain-funcs desktop xdg-utils xdg

inherit git-r3
# ^ TODO: conditional (only for 9999)? maybe port to tarballs before moving to gentoo repo.
inherit patches
# ^ TODO: drop before moving to gentoo repo, and port to manual selection

DESCRIPTION="Official desktop client for Telegram"
HOMEPAGE="https://desktop.telegram.org"

EGIT_REPO_URI="https://github.com/telegramdesktop/tdesktop.git"
EGIT_SUBMODULES=(
	'*'
	-Telegram/ThirdParty/{xxHash,Catch,lz4,libdbusmenu-qt}
)

if [[ "${PV}" == 9999 ]]; then
	KEYWORDS=""
	EGIT_BRANCH="dev"
else
	# TODO: tarballs
	EGIT_COMMIT="v${PV}"
	KEYWORDS="~amd64"
	# ~ppc64 # blocked by clang, expected, variant and so on. Although, proven to build (with gcc) and work by @gyakovlev
	# ~x86
	# ~arm ~arm64
	# ~mipsel
	# (blocked by dev-cpp/range, that have only "~amd64 ~ppc64" ATM, and I've no time to prove the build on others)
fi

LICENSE="GPL-3-with-openssl-exception"
SLOT="0"
IUSE="custom-api-id dbus debug gtk2 gtk3 force-gtk-file-dialog libcxx libressl spell system-gsl system-expected system-fonts system-libtgvoip system-rlottie system-variant test wide-baloons"

REQUIRED_USE="
	gtk3? ( !gtk2 )
"

COMMON_DEPEND="
	app-arch/lz4:=
	app-arch/xz-utils:=
	>=dev-cpp/range-v3-0.10.0:=
	dbus? ( dev-libs/libdbusmenu-qt:= )
	dev-libs/xxhash:=
	dev-qt/qtcore:5=
	dev-qt/qtdbus:5=
	dev-qt/qtgui:5=[jpeg,png]
	|| (
		dev-qt/qtgui:5[X(-)]
		dev-qt/qtgui:5[xcb(-)]
	)
	dev-qt/qtnetwork:5=
	dev-qt/qtwidgets:5=[png]
	|| (
		dev-qt/qtwidgets:5[X(-)]
		dev-qt/qtwidgets:5[xcb(-)]
	)
	dev-qt/qtimageformats:5=
	gtk2? (
		x11-libs/gtk+:2=
	)
	gtk3? (
		x11-libs/gtk+:3=
		dev-qt/qtwidgets:5=[gtk]
	)
	libcxx? (
		sys-devel/clang:=
		sys-devel/clang-runtime:=[libcxx]
	)
	libressl? ( dev-libs/libressl:= )
	!libressl? ( dev-libs/openssl:0= )
	media-libs/openal:=
	media-video/ffmpeg:=[opus]
	!net-im/telegram
	!net-im/telegram-desktop-bin
	system-gsl? ( >dev-cpp/ms-gsl-2.0.0:= )
	system-expected? ( >dev-cpp/tl-expected-1.0.0:= )
	system-fonts? ( media-fonts/open-sans:* )
	system-variant? ( dev-cpp/variant:= )
	system-libtgvoip? ( media-libs/libtgvoip:=[libcxx=] )
	system-rlottie? ( >=media-libs/rlottie-0_pre20190818:=[libcxx(-)=,threads,-cache] )
	spell? ( app-text/enchant:= )
	sys-libs/zlib:=[minizip]
	x11-libs/libdrm:=
	x11-libs/libva:=[X,drm]
	x11-libs/libxkbcommon:=
	x11-libs/libX11:=
"

RDEPEND="
	${COMMON_DEPEND}
"
DEPEND="
	${COMMON_DEPEND}
"
BDEPEND="
	>=dev-util/cmake-3.16
	|| (
		sys-devel/clang:=
		>=sys-devel/gcc-8.2.0-r6:=
	)
	test? ( dev-cpp/catch )
	virtual/pkgconfig
"
# ^^^ TODO: gcc-10 supports C++20, so range-v3 would not be needed anymore.
# Opposite is true too: dropping range-v3 will bump minimum compatible GCC version to 10.0

pkg_pretend() {
	if use custom-api-id; then
		if [[ -n "${MY_TDESKTOP_API_ID}" ]] && [[ -n "${MY_TDESKTOP_API_HASH}" ]]; then
			einfo "Your custom ApiId is ${MY_TDESKTOP_API_ID}"
			einfo "Your custom ApiHash is ${MY_TDESKTOP_API_HASH}"
		else
			eerror ""
			eerror "It seems you did not set one or both of MY_TDESKTOP_API_ID and MY_TDESKTOP_API_HASH variables,"
			eerror "which are required for custom-api-id USE-flag."
			eerror "You can set them either in:"
			eerror "- /etc/portage/make.conf (globally, so all applications you'll build will see that ID and HASH"
			eerror "- /etc/portage/env/${CATEGORY}/${PN} (privately for this package builds)"
			eerror ""
			die "You should correctly set both MY_TDESKTOP_API_ID and MY_TDESKTOP_API_HASH variables if you want custom-api-id USE-flag"
		fi
	fi

	if tc-is-gcc && ver_test "$(gcc-major-version).$(gcc-minor-version)" -lt "8.2" && [[ -z "${TG_FORCE_OLD_GCC}" ]]; then
		die "Minimal compatible gcc version is 8.2. Please, either upgrade or use clang. Or set TG_FORCE_OLD_GCC=1 to override this check."
	fi

	if tc-is-clang && has ccache ${FEATURES}; then
		eerror ""
		eerror "Somewhy clang fails the compilation when it working with some CMake's PCH files if CCache is enabled (at least, this bug reproduces on 8.x and 9.x clang versions)"
		eerror "Reasons are still not fully investigated, but failure is reproducible, and there is an issue at CMake tracker: https://gitlab.kitware.com/cmake/cmake/issues/19923"
		eerror ""
		eerror "Please, either disable ccache feature for ${PN} package, use gcc (slows the build too),"
		eerror "or better, please help us to investigate and fix the problem (open issue at GitHub if you'll have any progress on it)"
		eerror ""
		eerror "As a workaround you can use CCACHE_RECACHE=1, but it will anyway slow down the compilation, as it will act as there is no cache."
		eerror ""
		eerror "Alternate way is to manually remove cached entries for 'bad' PCHs from ccache dir, but this way is fragile and not guaranteed to work."
		eerror "Running this command **before** emergeing ${PN} helps me, but it may require adding another entries for you:"
		eerror "    #  grep -rEl '(Telegram|lib_(export|spellcheck|ui)).dir.*pch:' ${CCACHE_DIR:-/var/tmp/portage/.ccache} | sed -r 's@(.*)\.d\$@\1.d \1.o@' | xargs -r rm"
		eerror ""
		eerror "You have been warned!"
		eerror ""
		eerror "P.S. Please, let me (mva) know if you'll get it to work"
	fi

	if get-flag -flto >/dev/null; then
		eerror ""
		eerror "Keep in mind, that LTO build eats about ~20G RAM for buildind, and final binary size will be about 2.5G."
		if tc-is-clang; then
			eerror ""
			eerror "Qt5 is incompatible with LTO builds using clang at this moment."
			eerror "Ref: https://bugreports.qt.io/browse/QTBUG-61710"
			die "Please, read the error above."
		fi
	fi

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

	if use system-rlottie; then
		ewarn ""
		ewarn "Unfortunately, ${PN} uses custom modifications over rlottie (which aren't yet accepted by upstream)."
		ewarn "This leads to following facts:"
		ewarn "  - Colors replacement maps are not working when you link against system rlottie package."
		ewarn "      That means, for example, that 'giant animated emojis' will ignore skin-tone colors and will always be yellow"
		ewarn "      Ref: https://github.com/Samsung/rlottie/pull/252"
		ewarn "  - Crashes on some stickerpacks"
		ewarn "      Probably related to: https://github.com/Samsung/rlottie/pull/262"
	fi
}

src_unpack() {
	use spell && EGIT_SUBMODULES+=(-Telegram/lib_spellcheck)
	use system-gsl && EGIT_SUBMODULES+=(-Telegram/ThirdParty/GSL)
	use system-expected && EGIT_SUBMODULES+=(-Telegram/ThirdParty/expected)
	use system-libtgvoip && EGIT_SUBMODULES+=(-Telegram/ThirdParty/libtgvoip)
	use system-rlottie && EGIT_SUBMODULES+=(-Telegram/{lib_rlottie,ThirdParty/rlottie})
	use system-variant && EGIT_SUBMODULES+=(-Telegram/ThirdParty/variant)

	git-r3_src_unpack
}

src_prepare() {
	sed -i \
		-e '/-W.*/d' \
		-e '/PIC/a-Wno-error\n-Wno-all' \
		-e "$(usex debug '' 's@-g[a-zA-Z0-9]*@@')" \
		-e 's@-flto@@' \
		-e "s@-Ofast@@" \
		cmake/options_linux.cmake || die
#		echo > cmake/options_linux.cmake
#		^ Maybe just wipe it out instead of trying to fix?
#		^ There are not so mush useful compiler flags, actually.

	patches_src_prepare
#	cmake_src_prepare
#	^ to be used when will be ported to gentoo repo
}

src_configure() {
	local mycxxflags=(
		${CXXFLAGS}
		-Wno-error=deprecated-declarations
		-DLIBDIR="$(get_libdir)"
		-DTDESKTOP_DISABLE_AUTOUPDATE
	)

	local mycmakeargs=(
		-DCMAKE_CXX_FLAGS:="${mycxxflags[*]}"

		# Upstream does not need crash reports from custom builds anyway
		-DDESKTOP_APP_DISABLE_CRASH_REPORTS=ON

		-DDESKTOP_APP_DISABLE_SPELLCHECK=$(usex spell OFF ON)

		# Unbundling:
		-DDESKTOP_APP_USE_PACKAGED=ON # Main

		-DDESKTOP_APP_USE_PACKAGED_RLOTTIE=$(usex system-rlottie ON OFF)   # Using system-rlottie have side-effect of disabled color replacements for "giant emojis"
		-DDESKTOP_APP_USE_PACKAGED_GSL=$(usex system-gsl ON OFF)           # Header-only library. Not so much profit on unbundling it (app anyway needs rebuild after it's upgrade)
		-DDESKTOP_APP_USE_PACKAGED_EXPECTED=$(usex system-expected ON OFF) # Same as above ^
		-DDESKTOP_APP_USE_PACKAGED_VARIANT=$(usex system-variant ON OFF)   # Same as above ^
#		-DDESKTOP_APP_USE_PACKAGED_QRCODE=$(usex system-qrcode ON OFF)     # Not yet packaged in gentoo. Waiting for libreoffice team to unbundle it.
		-DDESKTOP_APP_USE_PACKAGED_FONTS=$(usex system-fonts ON OFF)       # Use system fonts.

		-DTDESKTOP_USE_PACKAGED_TGVOIP=$(usex system-libtgvoip ON OFF)     # Stable ABI? Never heard of it!

		-DTDESKTOP_DISABLE_GTK_INTEGRATION="$(usex gtk3 OFF $(usex gtk2 OFF ON))"
		-DTDESKTOP_FORCE_GTK_FILE_DIALOG=$(usex force-gtk-file-dialog ON OFF)

		-DTDESKTOP_DISABLE_DBUS_INTEGRATION=$(usex dbus OFF ON)

		-DTDESKTOP_API_TEST=$(usex test ON OFF)

# Snapcraft (snap, flatpack, whatever) API keys:
# As of my discussion with John Preston, he specifically asked TG servers owners to never ban snap's keys:
# TODO: (!!!!!!!) Ask Gentoo Council (or whatever) to get "official" Gentoo keys.
		-DTDESKTOP_API_ID=$(usex custom-api-id "${TELEGRAM_CUSTOM_API_ID}" "611335")
		-DTDESKTOP_API_HASH=$(usex custom-api-id "${TELEGRAM_CUSTOM_API_HASH}" "d524b414d21f4d37f08684c1df41ac9c")

#		-DDESKTOP_APP_LOTTIE_USE_CACHE=NO # in case of caching bugs. Maybe also useful with system-rlottie[cache]. TODO: test that idea.
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
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
