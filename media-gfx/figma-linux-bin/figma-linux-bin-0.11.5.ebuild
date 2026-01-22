# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8
inherit unpacker xdg

DESCRIPTION="Unofficial desktop application for linux"
HOMEPAGE="https://github.com/Figma-Linux/figma-linux"
SRC_URI="amd64? ( https://github.com/Figma-Linux/figma-linux/releases/download/v${PV}/figma-linux_${PV}_linux_amd64.deb -> ${P}-amd64.deb )"

S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="appindicator doc libnotify"
RESTRICT="bindist mirror"

RDEPEND="
	app-accessibility/at-spi2-core
	app-crypt/libsecret
	dev-libs/expat
	dev-libs/libbsd
	dev-libs/nss
	media-libs/freetype
	media-libs/libpng
	sys-apps/dbus
	sys-apps/keyutils
	sys-apps/util-linux
	sys-fs/e2fsprogs
	virtual/zlib
	x11-libs/gtk+:3
	x11-libs/libXScrnSaver
	x11-libs/libXtst
	x11-misc/xdg-utils
	appindicator? ( dev-libs/libayatana-appindicator )
	libnotify? ( x11-libs/libnotify )
"

QA_PREBUILT="*"

src_prepare() {
	default

	if use doc ; then
		unpack "usr/share/doc/figma-linux/changelog.gz" || die "unpack failed"
		rm -f "usr/share/doc/figma-linux/changelog.gz" || die "rm failed"
		mv "changelog" "usr/share/doc/figma-linux" || die "mv failed"
	fi

	rm -f "opt/figma-linux/lib/x86_64-linux-gnu/libbsd.so.0" || die "rm failed"
	rm -f "opt/figma-linux/lib/x86_64-linux-gnu/libbsd.so.0.8.7" || die "rm failed"
	rm -f "opt/figma-linux/lib/x86_64-linux-gnu/libcom_err.so.2" || die "rm failed"
	rm -f "opt/figma-linux/lib/x86_64-linux-gnu/libcom_err.so.2.1" || die "rm failed"
	rm -f "opt/figma-linux/lib/x86_64-linux-gnu/libdbus-1.so.3" || die "rm failed"
	rm -f "opt/figma-linux/lib/x86_64-linux-gnu/libdbus-1.so.3.19.4" || die "rm failed"
	rm -f "opt/figma-linux/lib/x86_64-linux-gnu/libexpat.so.1" || die "rm failed"
	rm -f "opt/figma-linux/lib/x86_64-linux-gnu/libexpat.so.1.6.7" || die "rm failed"
	rm -f "opt/figma-linux/libfreetype.so.6" || die "rm failed"
	rm -f "opt/figma-linux/lib/x86_64-linux-gnu/libkeyutils.so.1" || die "rm failed"
	rm -f "opt/figma-linux/lib/x86_64-linux-gnu/libkeyutils.so.1.5" || die "rm failed"
	rm -f "opt/figma-linux/libm.so.6" || die "rm failed"
	rm -f "opt/figma-linux/libpng16.so.16" || die "rm failed"
	rm -f "opt/figma-linux/libz.so.1" || die "rm failed"
}

src_install() {
	if use doc ; then
		dodoc -r "usr/share/doc/figma-linux/"* || die "dodoc failed"
	fi

	rm -r "usr/share/doc/figma-linux" || die "rm failed"

	# TODO: rewrite to insinto/dobin/etc
	cp -a . "${ED}" || die "cp failed"

	dosym "../../opt/figma-linux/figma-linux" "/usr/bin/figma-linux" || die "dosym failed"
}
