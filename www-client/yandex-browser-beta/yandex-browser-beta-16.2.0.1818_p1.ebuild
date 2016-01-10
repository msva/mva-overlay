# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
CHROMIUM_LANGS="cs de en_US es fr it ja kk pt_BR pt_PT ru tr uk zh_CN zh_TW"
inherit chromium multilib unpacker

DESCRIPTION="Browser that combines a minimal design with sophisticated technology."
HOMEPAGE="http://browser.yandex.ru/beta/"
LICENSE="EULA"
SLOT="0"
SRC_URI="
	amd64? ( http://repo.yandex.ru/yandex-browser/deb/pool/main/y/yandex-browser-beta/yandex-browser-beta_16.2.0.1818-1_amd64.deb -> ${P}.deb )
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

	sed -r \
		-e 's|\[(NewWindow)|\[X-\1|g' \
		-e 's|\[(NewIncognito)|\[X-\1|g' \
		-e 's|^TargetEnvironment|X-&|g' \
		-i usr/share/applications/${PN}.desktop || die
}

src_install() {
	mv * "${D}" || die
	make_wrapper "${PN}" "./${PN}" "/${YANDEX_HOME}" "/usr/$(get_libdir)/${PN}/lib"
#dosym "../../${YANDEX_HOME}/${PN}" /usr/bin/"${PN}"
	dodir /usr/$(get_libdir)/${PN}/lib
	dosym /usr/$(get_libdir)/libudev.so /usr/$(get_libdir)/${PN}/lib/libudev.so.0
	fperms 4711 /${YANDEX_HOME}/yandex_browser-sandbox
}
