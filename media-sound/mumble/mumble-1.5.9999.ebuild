# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LANGS="cs cy da de el el_GR en en_GB eo es eu fa_IR fi fr gl he hi hu it ja ko lt nb_NO nl nl_BE no pl pt_BR pt_PT ru sk sv th tr uk vi zh_CN zh_HK zh_TW"

EGIT_REPO_URI="https://github.com/mumble-voip/mumble"
EGIT_SUBMODULES=(
	'*'
	-3rdparty/mach-override-src
)

inherit eutils multilib cmake virtualx git-r3

DESCRIPTION="Mumble is an open source, low-latency, high quality voice chat software"
HOMEPAGE="http://mumble.info/"

LICENSE="BSD MIT"
SLOT="0"
KEYWORDS=""
IUSE="+alsa +dbus debug g15 g15-emulator pch jack pipewire portaudio pulseaudio qtspeech speech-dispatcher +system-opus +system-speex zeroconf optimization +overlay +plugins static"
# system-celt
# rnnoise

REQUIRED_USE="
	g15-emulator? ( g15 )
"

RDEPEND="
	dev-qt/qtcore:5=
	dev-qt/qtnetwork:5=
	dev-qt/qtxml:5=
	>=dev-libs/openssl-1.0.0b:0=
	>=dev-libs/protobuf-2.2.0:=

	dev-qt/qtconcurrent:5=
	dev-qt/qtsql:5=[sqlite]
	dev-qt/qtsvg:5=
	dev-qt/qttranslations:5=
	dev-qt/qtwidgets:5=
	dev-libs/poco[zip]
	>=media-libs/libsndfile-1.0.20[-minimal]
	>=dev-libs/boost-1.41.0:=[threads]
	x11-libs/libXext
	x11-libs/libXi

	dev-qt/qtgui:5=
	dev-qt/qtx11extras:5=
	dev-qt/qtxmlpatterns:5=
	app-crypt/qca:2=

	dbus? ( dev-qt/qtdbus:5= )
	overlay? (
		virtual/opengl
		dev-qt/qtopengl:5=
	)
	system-opus? ( >=media-libs/opus-1.0.1 )
	system-speex? (
		>=media-libs/speex-1.2.0
		media-libs/speexdsp
	)
	sys-apps/lsb-release
	x11-libs/libX11
	x11-base/xorg-proto
	alsa? ( media-libs/alsa-lib )
	g15? ( app-misc/g15daemon )
	jack? ( virtual/jack )
	pipewire? ( media-video/pipewire )
	portaudio? ( media-libs/portaudio )
	pulseaudio? ( || (
		media-sound/apulse
		media-sound/pulseaudio
		media-video/pipewire
	) )
	qtspeech? ( dev-qt/qtspeech:5= )
	speech-dispatcher? ( app-accessibility/speech-dispatcher )
	zeroconf? ( net-dns/avahi[mdnsresponder-compat] )
"
	# system-celt? (
	# 	media-libs/celt
	# )

# TODO: unbundle rnnoise

DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=dev-qt/linguist-tools-5.1:5
"

src_unpack() {
	# use system-celt && EGIT_SUBMODULES+=(-celt-0.7.0-src)
	use system-opus && EGIT_SUBMODULES+=(-opus)
	use system-speex && EGIT_SUBMODULES+=(-3rdparty/speexdsp -speex)
	# use system-rnnoise && EGIT_SUBMODULES+=(-3rdparty/rnnoise-src)
	git-r3_src_unpack
}

src_prepare() {
	pushd 3rdparty &>/dev/null
		rm -r GL jack opus pipewire portaudio pulseaudio speex*
	popd &>/dev/null
	cmake_src_prepare
}

src_configure() {
	useb() {
		usex ${1} "ON" "OFF"
	}
	local mycmakeargs=(
		# core
		-Doptimize=$(useb optimization)
		-Dstatic=$(useb static)
		-Dsymbols=$(useb debug)
		# -Dwarnings-as-errors=OFF
		-Doverlay=$(useb overlay)
		-Dplugins=$(useb plugins)
		-Ddbus=$(useb dbus)
		-Dzeroconf=$(useb zeroconf)

		# client
		-Dupdate=OFF
		# -Dbundled-celt=$(useb !system-celt)
		-Dbundled-opus=$(useb !system-opus)
		-Dbundled-speex=$(useb !system-speex)
		# -Drnnoise= #TODO: unbundle
		-Dqtspeech=$(useb qtspeech)
		-Djackaudio=$(useb jack)
		-Dportaudio=$(useb portaudio)

		-Dplugin-debug=$(useb debug)
		-Dplugin-callback-debug=$(useb debug)

		-Dalsa=$(useb alsa)
		-Dpipewire=$(useb pipewire)
		-Dpulseaudio=$(useb pulseaudio)
		-Dspeechd=$(useb speech-dispatcher)
		# -Dxinput2=ON

		-Dg15=$(useb g15)
		$(usex g15 "-Dg15-emulator=$(useb g15-emulator)" "")

		-Dclient=ON
		-Dserver=OFF # separate package
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install
	einstalldocs
}

pkg_postinst() {
	echo
	elog "Visit http://mumble.sourceforge.net/ for futher configuration instructions."
	elog "Run mumble-overlay to start the OpenGL overlay (after starting mumble)."
	echo
}
