# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

CHROMIUM_LANGS="af am ar bg bn ca cs da de el en-GB en-US es-419 es et fa fil fi fr gu he hi hr hu id it
ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr sv sw ta te th tr ur uk vi zh-CN zh-TW"

inherit desktop xdg unpacker chromium-2

DESCRIPTION="Desktop application for Jitsi Meet built with Electron"
HOMEPAGE="https://github.com/jitsi/jitsi-meet-electron"
BASE_SRC_URI="https://github.com/jitsi/${PN//-bin}/releases/download/v${PV}/${PN//-electron-bin}"
SRC_URI="
	amd64? ( ${BASE_SRC_URI}-amd64.deb -> ${P}-amd64.deb )
	arm64? ( ${BASE_SRC_URI}-arm64.deb -> ${P}-arm64.deb )
"

S="${WORKDIR}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="system-ffmpeg"
RESTRICT="bindist mirror splitdebug test"

QA_PREBUILT="*"
RDEPEND="
	app-accessibility/at-spi2-core:2
	dev-libs/expat
	dev-libs/glib
	dev-libs/nspr
	dev-libs/nss
	media-libs/alsa-lib
	media-libs/mesa
	system-ffmpeg? ( media-video/ffmpeg[chromium(-)] )
	net-print/cups
	sys-apps/dbus
	virtual/udev
	x11-libs/cairo
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libXtst
	x11-libs/libdrm
	x11-libs/libxcb
	x11-libs/libxkbcommon
	x11-libs/pango
"

src_install() {
	rm "opt/Jitsi Meet/chrome-sandbox" || die

	insinto /opt
	doins -r "opt/Jitsi Meet"

	# dobin "opt/Jitsi Meet/jitsi-meet"
	dosym "../../opt/Jitsi Meet/jitsi-meet" "${EPREFIX}/usr/bin/jitsi-meet"
	domenu usr/share/applications/jitsi-meet.desktop
	doicon usr/share/icons/hicolor/512x512/apps/jitsi-meet.png

	pushd "${ED}/opt/Jitsi Meet/locales" > /dev/null || die
	chromium_remove_language_paks
	popd > /dev/null || die

	if use system-ffmpeg; then
		rm "${ED}/opt/Jitsi Meet/libffmpeg.so" || die
		dosym "../../usr/$(get_libdir)/chromium/libffmpeg.so" "opt/Jitsi Meet/libffmpeg.so" || die
		elog "Using system ffmpeg. This is experimental and may lead to crashes."
	fi

	# fperms +x /usr/bin/jitsi-meet
	fperms +x "/opt/Jitsi Meet/jitsi-meet"
}
