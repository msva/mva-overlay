# Copyright 1999-2017 Gentoo Foundation
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
	KEYWORDS="~x86 ~amd64"
fi

EGIT_REPO_URI="https://github.com/telegramdesktop/tdesktop"

LICENSE="GPL-3-with-openssl-exception"
SLOT="0"
IUSE="custom-api-id debug +wide-baloons +pulseaudio +gtk3"
# upstream-api-id"

COMMON_DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5[xcb,jpeg,png]
	dev-qt/qtwidgets[xcb,png]
	dev-qt/qtnetwork
	dev-qt/qtimageformats
	virtual/ffmpeg
	media-libs/opus
	x11-libs/libdrm
	x11-libs/libva[X,drm]
	sys-libs/zlib[minizip]
	gtk3? (
		x11-libs/gtk+:3
		dev-libs/libappindicator:3
		|| (
			<dev-qt/qtgui-5.7:5[gtkstyle]
			>=dev-qt/qtgui-5.7:5[gtk(+)]
		)
	)
	media-libs/openal
	dev-libs/openssl:0
	x11-libs/libX11
	dev-util/google-breakpad
	!net-im/telegram
	!net-im/telegram-desktop-bin
	pulseaudio? ( media-sound/pulseaudio )
"

RDEPEND="
	${COMMON_DEPEND}
"

DEPEND="
	virtual/pkgconfig
	${COMMON_DEPEND}
"

CMAKE_USE_DIR="${S}/Telegram"

src_prepare() {
	patches_src_prepare
#	cmake-utils_src_prepare
### cmake-utils_src_prepare emulation {{{
	_cmake_cleanup_cmake
	# make ${S} read-only in order to detect broken build-systems
	if [[ ${CMAKE_UTILS_QA_SRC_DIR_READONLY} && ! ${CMAKE_IN_SOURCE_BUILD} ]]; then
		chmod -R a-w "${S}"
	fi

	_CMAKE_UTILS_SRC_PREPARE_HAS_RUN=1
### cmake-utils_src_prepare emulation }}}

	if use custom-api-id; then
		if [[ -n "${TELEGRAM_CUSTOM_API_ID}" ]] && [[ -n "${TELEGRAM_CUSTOM_API_HASH}" ]]; then
			(
				echo 'static const int32 ApiId = '"${TELEGRAM_CUSTOM_API_ID}"';'
				echo 'static const char *ApiHash = "'"${TELEGRAM_CUSTOM_API_HASH}"'";'
			) > custom_api_id.h
		else
			eerror ""
			eerror "It seems you did not set one or both of TELEGRAM_CUSTOM_API_ID and TELEGRAM_CUSTOM_API_HASH variables,"
			eerror "which are required for custom-api-id USE-flag."
			eerror "You can set them either in:"
			eerror "- /etc/portage/make.conf (globally, so all applications you'll build will see that ID and HASH"
			eerror "- /etc/portage/env/${CATEGORY}/${PN} (privately for this package builds)"
			eerror ""
			die "You should correctly set TELEGRAM_CUSTOM_API_ID && TELEGRAM_CUSTOM_API_HASH variables if you want custom-api-id USE-flag"
		fi
	fi
	mv "${S}"/lib/xdg/telegram{,-}desktop.desktop || die "Failed to fix .desktop-file name"
}

src_configure() {
	local mycxxflags=(
#		$(usex custom-api-id '-DCUSTOM_API_ID' "$(usex upstream-api-id '' '-DGENTOO_API_ID')") # Variant for moving ebuild in the tree.
		$(usex custom-api-id '-DCUSTOM_API_ID' '')
		-DLIBDIR="$(get_libdir)"
		# If you will copy this ebuild from my overlay, please don't forget to uncomment -DGENTOO_API_ID definition here and fix the patch (and manifest).
		# And also, don't forget to get your (or Gentoo's, in case you'll move ot to the portage tree) unique ID and HASH

#		-DTDESKTOP_DISABLE_CRASH_REPORTS
#		-DTDESKTOP_DISABLE_REGISTER_CUSTOM_SCHEME
#		-DTDESKTOP_DISABLE_DESKTOP_FILE_GENERATION
	)

	local mycmakeargs=(
		-DCMAKE_CXX_FLAGS:="${mycxxflags[*]}"
		-DBREAKPAD_INCLUDE_DIR="/usr/include/breakpad"
		-DBREAKPAD_LIBRARY_DIR="/usr/$(get_libdir)/libbreakpad_client.a"
	)

	use gtk3 || {
		mycmakeargs+=("-DGTK=OFF")
	}

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
