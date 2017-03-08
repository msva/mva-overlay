# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

LANGS="cs cy da de el el_GR en en_GB eo es eu fa_IR fi fr gl he hi hu it ja ko lt nb_NO nl nl_BE no pl pt_BR pt_PT ru sk sv th tr uk vi zh_CN zh_HK zh_TW"

QT_MINIMAL="4.6"

EGIT_REPO_URI="https://github.com/mumble-voip/mumble"

inherit eutils multilib qmake-utils virtualx git-r3

DESCRIPTION="Mumble is an open source, low-latency, high quality voice chat software"
HOMEPAGE="http://mumble.info/"

LICENSE="BSD MIT"
SLOT="0"
KEYWORDS=""
IUSE="+alsa +dbus debug g15 libressl oss pch portaudio pulseaudio qt4 +qt5 speech zeroconf"

REQUIRED_USE="
	^^ ( qt4 qt5 )
"

RDEPEND="
	qt4? (
		>=dev-qt/qtcore-4.6:4
		>=dev-qt/qtgui-4.6:4
		>=dev-qt/qtopengl-4.6:4
		>=dev-qt/qtsql-4.6:4[sqlite]
		>=dev-qt/qtsvg-4.6:4
		>=dev-qt/qtxmlpatterns-4.6:4
		app-crypt/qca:2[qt4(+)]
		dbus? ( >=dev-qt/qtdbus-4.6:4 )
	)
	qt5? (
		>=dev-qt/qtcore-5.1:5
		>=dev-qt/qtgui-5.1:5
		>=dev-qt/qtnetwork-5.1:5
		>=dev-qt/qtopengl-5.1:5
		>=dev-qt/qtsql-5.1:5[sqlite]
		>=dev-qt/qtsvg-5.1:5
		>=dev-qt/qttranslations-5.1:5
		>=dev-qt/qtwidgets-5.1:5
		>=dev-qt/qtx11extras-5.1:5
		>=dev-qt/qtxml-5.1:5
		>=dev-qt/qtxmlpatterns-5.1:5
		app-crypt/qca:2[qt5(+)]
		dbus? ( >=dev-qt/qtdbus-5.1:5 )
	)

	>=dev-libs/boost-1.41.0
	>=dev-libs/protobuf-2.2.0
	>=media-libs/libsndfile-1.0.20[-minimal]
	>=media-libs/opus-1.0.1
	|| (
		(
			>=media-libs/speex-1.2.0
			media-libs/speexdsp
		)
		<media-libs/speex-1.2.0
	)
	sys-apps/lsb-release
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXi
	x11-proto/inputproto
	alsa? ( media-libs/alsa-lib )
	g15? ( app-misc/g15daemon )
	!libressl? ( >=dev-libs/openssl-1.0.0b:0 )
	libressl? ( dev-libs/libressl )
	portaudio? ( media-libs/portaudio )
	pulseaudio? ( media-sound/pulseaudio )
	speech? ( app-accessibility/speech-dispatcher )
	zeroconf? ( net-dns/avahi[mdnsresponder-compat] )
"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	qt5? ( >=dev-qt/linguist-tools-5.1:5 )
"

src_configure() {
	local conf_add

	if has_version '<=sys-devel/gcc-4.2'; then
		conf_add+=" no-pch"
	else
		use pch || conf_add+=" no-pch"
	fi

	use alsa || conf_add+=" no-alsa"
	use dbus || conf_add+=" no-dbus"
	use debug && conf_add+=" symbols debug" || conf_add+=" release"
	use g15 || conf_add+=" no-g15"
	use oss || conf_add+=" no-oss"
	use portaudio || conf_add+=" no-portaudio"
	use pulseaudio || conf_add+=" no-pulseaudio"
	use speech || conf_add+=" no-speechd"
	use zeroconf || conf_add+=" no-bonjour"

	conf_add+=" bundled-celt"
	conf_add+=" no-bundled-opus"
	conf_add+=" no-bundled-speex"
	conf_add+=" no-embed-qt-translations"
	conf_add+=" no-server"
	conf_add+=" no-update"

	if use qt4; then
		export QT_SELECT=qt4
		eqmake4 "${S}/main.pro" ${myconf} || die "eqmake4 failed"
	elif use qt5; then
		export QT_SELECT=qt5
		ewarn "Please note that Qt5 support is still experimental."
		ewarn "If you find anything to not work with Qt5, please report a bug."
		eqmake5 "${S}/main.pro" -recursive \
			CONFIG+="${conf_add}" \
			DEFINES+="PLUGIN_PATH=/usr/$(get_libdir)/mumble" || die "eqmake5 failed"
	fi
}

#src_compile() {
#	# parallel make workaround, bug #445960
#	emake -j1
#}

src_install() {
	newdoc README.Linux README
	dodoc CHANGES

	local dir
	if use debug; then
		dir=debug
	else
		dir=release
	fi

	dobin "${dir}"/mumble
	dobin scripts/mumble-overlay

	insinto /usr/share/services
	doins scripts/mumble.protocol

	domenu scripts/mumble.desktop

	insinto /usr/share/icons/hicolor/scalable/apps
	doins icons/mumble.svg

	doman man/mumble-overlay.1
	doman man/mumble.1

	insopts -o root -g root -m 0755
	insinto "/usr/$(get_libdir)/mumble"
	doins "${dir}"/libmumble.so.${PV/%9999/0}
	dosym libmumble.so.${PV/%9999/0} /usr/$(get_libdir)/mumble/libmumble.so.1
	dosym libmumble.so.1 /usr/$(get_libdir)/mumble/libmumble.so
	doins "${dir}"/libcelt0.so.0.{7,11}.0
	doins "${dir}"/plugins/lib*.so*
}

pkg_postinst() {
	echo
	elog "Visit http://mumble.sourceforge.net/ for futher configuration instructions."
	elog "Run mumble-overlay to start the OpenGL overlay (after starting mumble)."
	echo
}
