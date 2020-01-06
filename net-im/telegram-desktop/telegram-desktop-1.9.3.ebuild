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
IUSE="crash-report connman custom-api-id debug gnome +gtk2 gtk3 gtk-file-dialog ibus kde libcxx libressl +networkmanager +openal-eff +spell test wide-baloons"
# mostly (with some exceptions), `+`'es (USE-flag soft-forcing) here to provide upstream defaults.
# ^ `crash-report` is upstream default, but I don't `+` it since it needs some work to move from bundled breakpad to system-wide. // also, privacy
# ^ `lto`, actually, is also upstream default, but it produces broken binary for me, so I don't `+` it here.
# ^ yup, upstream has moved from `gtk3` to `gtk2` somewhy, so, I also moved + from gtk3 to gtk2
# disabled USE-flag features:
# lto (user will set it on their own, if needed)
# system-fonts (USE_PACKED_RESOURCES is anyway broken ATM, so using "system fonts" is the only way to get it to work for now)

REQUIRED_USE="
	gtk-file-dialog? (
		|| (
			gtk2
			gtk3
		)
	)
	gtk2? ( !gtk3 )
	gnome? ( gtk3 )
	kde? ( !gtk2 !gtk3 !gnome !gtk-file-dialog networkmanager )
"

COMMON_DEPEND="
	app-arch/lz4:=
	app-arch/xz-utils:=
	connman? ( dev-qt/qtnetwork[connman] )
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
	gnome? (
		x11-themes/QGnomePlatform
		gnome-base/gsettings-desktop-schemas
		dev-qt/qtwidgets[gtk]
	)
	gtk2? (
		x11-libs/gtk+:2
		dev-libs/libappindicator:2
	)
	gtk3? (
		x11-libs/gtk+:3
		dev-libs/libappindicator:3
		dev-qt/qtwidgets[gtk]
	)
	ibus? ( dev-qt/qtgui[ibus] )
	!kde? (
		!gtk3? (
			!gtk2? ( x11-misc/qt5ct )
		)
	)
	libcxx? (
		sys-devel/clang:=
		sys-devel/clang-runtime:=[libcxx]
		media-libs/rlottie:=[libcxx]
		media-libs/libtgvoip:=[libcxx]
	)
	libressl? ( dev-libs/libressl:= )
	!libressl? ( dev-libs/openssl:0= )
	media-fonts/open-sans
	media-libs/libexif
	media-libs/libtgvoip:=
	media-libs/openal:=
	media-libs/opus:=
	>=media-libs/rlottie-0_pre20190818:=[module,threads,telegram-patches]
	media-video/ffmpeg:=
	!net-im/telegram
	!net-im/telegram-desktop-bin
	networkmanager? ( dev-qt/qtnetwork[networkmanager] )
	openal-eff? ( >=media-libs/openal-1.19.1:= )
	spell? ( app-text/enchant )
	sys-libs/zlib:=[minizip]
	x11-libs/libdrm:=
	x11-libs/libva:=[X,drm]
	x11-libs/libxkbcommon
	x11-libs/libX11:=
"

RDEPEND="
	${COMMON_DEPEND}
"

DEPEND="
	|| (
		sys-devel/clang:=
		>=sys-devel/gcc-8.2.0-r6:=
	)
	test? ( dev-cpp/catch )
	virtual/pkgconfig
	${COMMON_DEPEND}
"

pkg_pretend() {
	if use custom-api-id; then
		if [[ -n "${TELEGRAM_CUSTOM_API_ID}" ]] && [[ -n "${TELEGRAM_CUSTOM_API_HASH}" ]]; then
			einfo "Your custom ApiId is ${TELEGRAM_CUSTOM_API_ID}"
			einfo "Your custom ApiHash is ${TELEGRAM_CUSTOM_API_HASH}"
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
		eerror "    #  grep -rEl '(Telegram|lib_(spellcheck|ui)).dir.*pch:' ${CCACHE_DIR:-/var/tmp/portage/.ccache} | sed -r 's@(.*)\.d\$@\1.d \1.o@' | xargs -r rm"
		eerror ""
		eerror "You have been warned!"
		eerror ""
		eerror "P.S. Please, let me (mva) know if you'll get it to work"
	fi

	if get-flag -flto >/dev/null; then
		eerror ""
		eerror "Somewhy enabling LTO leads to a broken binary (it starts, but don't render the UI). At least, with clang-9."
		eerror "You're free to experiment, but keep in mind that it eats about ~20G RAM."
		eerror ""
		eerror "You have been warned!"
		eerror ""
		eerror "P.S. Please, let me (mva) know if you'll get it to work"
	fi

	if [[ $(get-flag stdlib) == "libc++" ]]; then
		if ! tc-is-clang; then
			die "Building with libcxx (aka libc++) as stdlib requires using clang as compiler. Please set CC/CXX in portage.env"
		elif ! use libcxx; then
			die "Building with libcxx (aka libc++) as stdlib requires some dependencies to be also built with it. Please, set USE=libcxx on ${PN} to handle that."
		fi
	elif use libcxx; then
		append-cxxflags "-stdlib=libc++"
	fi
}

src_prepare() {
	cp -r "${FILESDIR}/cmake" "${S}" || die

	if use gnome; then
		sed -i \
			-e '/QT_QPA_PLATFORMTHEME/s@unsetenv.*$@setenv("QT_QPA_PLATFORMTHEME", "gnome", true)@' \
			Telegram/SourceFiles/core/launcher.cpp
	elif use gtk3; then
		sed -i \
			-e '/QT_QPA_PLATFORMTHEME/s@unsetenv.*$@setenv("QT_QPA_PLATFORMTHEME", "gtk3", true)@' \
			Telegram/SourceFiles/core/launcher.cpp
	elif use !kde; then
		sed -i \
			-e '/QT_QPA_PLATFORMTHEME/s@unsetenv.*$@setenv("QT_QPA_PLATFORMTHEME", "qt5ct", true)@' \
			Telegram/SourceFiles/core/launcher.cpp
	fi

	sed -i \
		-e "$(usex networkmanager '/QNetworkManagerEnginePlugin/s@^#@@' '')" \
		-e "$(usex connman '/QConnmanEnginePlugin/s@^#@@' '')" \
		-e "$(usex ibus '/QIbusPlatformInputContextPlugin/s@^#@@' '')" \
		cmake/external.cmake || die
#		-e "$(usex fcitx '/QFcitxPlatformInputContextPlugin/s@^#@@' '')" \
#		-e "$(usex hime '/QHimePlatformInputContextPlugin/s@^#@@' '')" \
#		-e "$(usex nimf '/NimfInputContextPlugin/s@^#@@' '')" \
#		^ qtgui have no useflags for them

	sed -i \
		-e '/-W.*/d' \
		-e '/PIC/a-Wno-error\n-Wno-all' \
		-e "$(usex debug '' 's@-g[a-zA-Z0-9]*@@')" \
		-e 's@-flto@@' \
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
		-e '/add_subdirectory.crash_reports/d' \
		cmake/external/CMakeLists.txt || die

	sed -i \
		-e '/external_crash_reports/d' \
		Telegram/lib_base/CMakeLists.txt || die

	sed -i \
		-e '/LINK_SEARCH_START_STATIC/s@1@0@' \
		cmake/init_target.cmake || die

	sed -i \
		-e '/OUTPUT_VARIABLE machine_uname/d' \
		-e '/uname. MATCHES .x86_64/s@^.*$@if (CMAKE_SIZEOF_VOID_P EQUAL 4)@' \
		cmake/variables.cmake
	# ^ There are 32-bit processor arches which aren't x86 nor arm

	sed -i \
		-e 's@qt_static_plugins@qt_functions@' \
		-e '/third_party_loc.*minizip/d' \
		-e '/include.cmake.lib_tgvoip/d' \
		-e '/desktop-app::external_auto_updates/d' \
		-e '/AL_LIBTYPE_STATIC/d' \
		-e '/output_name "Telegram"/s@Telegram@telegram-desktop@' \
		-e '/AND NOT build_winstore/s@winstore@winstore AND TD_ENABLE_AUTOUPDATER@' \
		-e "$(usex gtk3 's@gtk\+\-2@gtk\+\-3@;s@GTK2_I@GTK3_I@' '')" \
		Telegram/CMakeLists.txt || die
#		-e '/CMAKE_GENERATOR. MATCHES/{s@Visual Studio|Xcode|Ninja@Visual Studio|Xcode@;s@Unix Makefiles@Unix Makefiles|Ninja@}' \

	sed -i \
		-e '1s:^:#include <QtCore/QVersionNumber>\n:' \
		Telegram/SourceFiles/platform/linux/notifications_manager_linux.cpp || die

#		echo > Telegram/SourceFiles/qt_static_plugins.cpp
#		^ Maybe, wipe it out, just in case (even we prevented it to be used)?

	sed -i \
		-e "$(usex ppc '/defined(__arm__)/{s@$@ || defined(__powerpc__)@}' '')" \
		-e "$(usex ppc64 '/defined(__aarch64__)/{s@$@ || defined(__powerpc64__)@}' '')" \
		Telegram/lib_base/base/build_config.h || die
	sed -i \
		-e '/Only little endian/{s@#error@#warning@}' \
		Telegram/SourceFiles/config.h || die

	patches_src_prepare
#	cmake-utils_src_prepare
#	^ to be used when will be ported to gentoo repo
}

src_configure() {
	local mycxxflags=(
		${CXXFLAGS}
		-Wno-error=deprecated-declarations
		-DLIBDIR="$(get_libdir)"
		-DTDESKTOP_DISABLE_AUTOUPDATE # no need
		#$(usex system-fonts "" -DTDESKTOP_USE_PACKED_RESOURCES)
		# ^ Doesn't work anyway
		# (CMake doesn't build rcc file which tdesktop tries to load,
		# and tdesktop also refuses to load manually-built rcc).
		$(usex openal-eff "" -DTDESKTOP_DISABLE_OPENAL_EFFECTS)
	)

	#	tc-is-clang && mycxxflags+=("-stdlib=libc++")
	# ^ randomly fails to build otherwise (currently, not)

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

		-DTDESKTOP_DISABLE_GTK_INTEGRATION="$(usex gtk3 OFF $(usex gtk2 OFF ON))"
		-DTDESKTOP_FORCE_GTK_FILE_DIALOG=$(usex gtk-file-dialog ON OFF)
		#-DTDESKTOP_DISABLE_REGISTER_CUSTOM_SCHEME
		#-DTDESKTOP_DISABLE_NETWORK_PROXY

		-DTDESKTOP_API_TEST=$(usex test ON OFF)
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
