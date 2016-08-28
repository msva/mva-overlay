# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
CHROMIUM_LANGS="cs de en-US es fr it ja kk pt-BR pt-PT ru tr uk zh-CN zh-TW"
inherit chromium-2 unpacker

RESTRICT="mirror"

MY_PV="${PV/_p/-}"

DESCRIPTION="The web browser from Yandex"
HOMEPAGE="http://browser.yandex.ru/beta/"
LICENSE="Yandex-EULA"
SLOT="0"
SRC_URI="
	amd64? ( http://repo.yandex.ru/yandex-browser/deb/pool/main/y/yandex-browser-beta/yandex-browser-beta_${MY_PV}_amd64.deb -> ${P}.deb )
"
KEYWORDS="~amd64"

RDEPEND="
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	>=dev-libs/openssl-1.0.1:0
	gnome-base/gconf:2
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/freetype
	net-misc/curl
	net-print/cups
	sys-apps/dbus
	sys-libs/libcap
	virtual/libudev
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:2
	x11-libs/libX11
	x11-libs/libXScrnSaver
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/pango[X]
	x11-misc/xdg-utils
"

QA_PREBUILT="*"
S=${WORKDIR}
YANDEX_HOME="opt/${PN/-//}"

src_unpack() {
	unpack_deb ${A}
}

src_prepare() {
	rm usr/bin/${PN} || die

	rm -r etc || die

	rm -r "${YANDEX_HOME}/cron" || die

	mv usr/share/doc/${PN} usr/share/doc/${PF} || die

	pushd "${YANDEX_HOME}/locales" > /dev/null || die
	chromium_remove_language_paks
	popd > /dev/null || die

	eapply_user

	sed -r \
		-e 's|\[(NewWindow)|\[X-\1|g' \
		-e 's|\[(NewIncognito)|\[X-\1|g' \
		-e 's|^TargetEnvironment|X-&|g' \
		-i usr/share/applications/${PN}.desktop || die
}

src_install() {
	mv * "${D}" || die
	dodir /usr/$(get_libdir)/${PN}/lib
	make_wrapper "${PN}" "./${PN}" "/${YANDEX_HOME}" "/usr/$(get_libdir)/${PN}/lib"
	dosym /usr/$(get_libdir)/libudev.so /usr/$(get_libdir)/${PN}/lib/libudev.so.0

	for icon in "/${YANDEX_HOME}/product_logo_"*.png; do
		size="${icon##*/product_logo_}"
		size=${size%.png}
		dodir "/usr/share/icons/hicolor/${size}x${size}/apps"
		newicon -s "${size}" "$icon" "yandex-browser-beta.png"
	done
}

pkg_postinst() {
	# https://github.com/msva/mva-overlay/issues/79
	# https://github.com/msva/mva-overlay/pull/80/files#r76529485
	ewarn "The SUID sandbox helper binary was found, but is not configured correctly."
	ewarn "You need to make sure that /${YANDEX_HOME}/yandex_browser-sandbox is owned by root and has mode 4755."
	chown root:root "/${YANDEX_HOME}/yandex_browser-sandbox"
	chmod 4755 "/${YANDEX_HOME}/yandex_browser-sandbox"
}
