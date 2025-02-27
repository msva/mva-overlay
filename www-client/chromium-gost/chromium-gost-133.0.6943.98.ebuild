# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
CHROMIUM_LANGS="af am ar bg bn ca cs da de el en-GB en-US es es-419 et fa fi fil fr gu he hi hr hu id it ja kn ko lt lv ml mr ms nb nl pl ro sk sl sr sv sw pt-BR pt-PT ta te th ru tr uk ur vi zh-CN zh-TW"

inherit chromium-2 unpacker desktop wrapper pax-utils xdg

DESCRIPTION="The web browser from Yandex"
HOMEPAGE="https://github.com/deemru/Chromium-Gost"

SRC_URI="
	amd64? ( https://github.com/deemru/Chromium-Gost/releases/download/${PV}/${P}-linux-amd64.deb )
"
# -> ${P}.deb )
S=${WORKDIR}

LICENSE="EULA"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+ffmpeg-codecs qt5 qt6"
RESTRICT="bindist mirror strip"

FFMPEG_PV="$(ver_cut 1)"
BROWSER_HOME="opt/${PN}"
MY_PN="${PN}-stable"

RDEPEND="
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	>=dev-libs/openssl-1.0.1:0
	media-libs/alsa-lib
	ffmpeg-codecs? ( media-video/ffmpeg-chromium:${FFMPEG_PV} )
	media-libs/fontconfig
	media-libs/freetype
	net-misc/curl
	net-print/cups
	sys-apps/dbus
	sys-libs/libcap
	virtual/libudev
	x11-libs/cairo
	x11-libs/libdrm
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libxkbcommon
	x11-libs/libXrandr
	x11-libs/pango[X]
	x11-misc/xdg-utils
	sys-libs/libudev-compat
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5[X]
		dev-qt/qtwidgets:5
	)
	qt6? (
		dev-qt/qtbase:6[gui,widgets]
	)
	app-accessibility/at-spi2-core
	${BLOCK}
"
BDEPEND="
	>=dev-util/patchelf-0.9
"

QA_PREBUILT="*"
QA_DESKTOP_FILE="usr/share/applications/.*\\.desktop"

pkg_pretend() {
	# Protect against people using autounmask overzealously
	use amd64 || die "${PN} only works on amd64"
}

pkg_setup() {
	chromium_suid_sandbox_check_kernel_config
}

src_unpack() {
	unpack_deb ${A}
}

src_prepare() {
	rm "usr/bin/${MY_PN}" || die "Failed to remove bundled wrapper"

	rm -r etc || die "Failed to remove etc"

	rm -r "${BROWSER_HOME}/cron" || die "Failed ro remove cron hook"

	mv usr/share/doc/${MY_PN} usr/share/doc/${PF} || die "Failed to move docdir"

	gunzip \
		"usr/share/doc/${PF}/changelog.gz" \
		"usr/share/man/man1/${MY_PN}.1.gz" \
	|| die "Failed to decompress docs"

	pushd "${BROWSER_HOME}/locales" > /dev/null || die "Failed to cd into locales dir"
		chromium_remove_language_paks
	popd > /dev/null || die

	if ! use qt5; then
		rm "${BROWSER_HOME}/libqt5_shim.so" || die
	fi
	if ! use qt6; then
		rm "${BROWSER_HOME}/libqt6_shim.so" || die
	fi

	local crap=(
		"${BROWSER_HOME}/xdg-settings"
		"${BROWSER_HOME}/xdg-mime"
	)

	test -L "usr/share/man/man1/${PN}.1.gz" &&
		crap+=("usr/share/man/man1/${PN}.1.gz")

	rm ${crap[@]} || die "Failed to remove bundled crap"

	default

	# sed -r \
	# 	-e 's|\[(NewWindow)|\[X-\1|g' \
	# 	-e 's|\[(NewIncognito)|\[X-\1|g' \
	# 	-e 's|^TargetEnvironment|X-&|g' \
	# 	-e 's|-stable||g' \
	# 	-i usr/share/applications/${DESKTOP_FILE_NAME}.desktop || die

	patchelf --remove-rpath "${S}/${BROWSER_HOME}/chrome-sandbox" ||
		die "Failed to fix library rpath (sandbox)"
	patchelf --remove-rpath "${S}/${BROWSER_HOME}/chrome" ||
		die "Failed to fix library rpath (browser, chrome)"
	patchelf --remove-rpath "${S}/${BROWSER_HOME}/chrome-management-service" ||
		die "Failed to fix library rpath (management-service)"
	patchelf --remove-rpath "${S}/${BROWSER_HOME}/chrome_crashpad_handler" ||
		die "Failed to fix library rpath (chrome_crashpad_handler)"
}

src_install() {
	mv * "${D}" || die
	dodir /usr/$(get_libdir)/${MY_PN}/lib
	mv "${D}"/usr/share/appdata "${D}"/usr/share/metainfo || die

	# make_wrapper "${PN}" "./chrome" "/${BROWSER_HOME}" "/usr/$(get_libdir)/${MY_PN}/lib" \
	make_wrapper "${PN}" "./${PN}" "/${BROWSER_HOME}" "/usr/$(get_libdir)/${MY_PN}/lib" \
		|| die "Failed to make a wrapper"

	for icon in "${D}/${BROWSER_HOME}/product_logo_"*.png; do
		size="${icon##*/product_logo_}"
		size=${size%.png}
		dodir "/usr/share/icons/hicolor/${size}x${size}/apps"
		newicon -s "${size}" "$icon" "${MY_PN}.png"
	done

	dosym ../../../usr/"$(get_libdir)"/chromium/libffmpeg.so."${FFMPEG_PV}" "${BROWSER_HOME}"/libffmpeg.so || die

	fowners root:root "/${BROWSER_HOME}/chrome-sandbox"
	fperms 4711 "/${BROWSER_HOME}/chrome-sandbox"
	pax-mark m "${ED}${BROWSER_HOME}/chrome-sandbox"
}
