# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LANGS="cs cy da de el el_GR en en_GB eo es eu fa_IR fi fr gl he hi hu it ja ko lt nb_NO nl nl_BE no pl pt_BR pt_PT ru sk sv th tr uk vi zh_CN zh_HK zh_TW"

EGIT_REPO_URI="https://github.com/mumble-voip/mumble"
# EGIT_SUBMODULES=(
# 	'*'
# 	-3rdparty/mach-override-src
# )
EGIT_SUBMODULES=(
	'-*'
	# 3rdparty/rnnoise-src
	3rdparty/FindPythonInterpreter
	# 3rdparty/tracy
)

inherit cmake xdg flag-o-matic multilib git-r3

DESCRIPTION="Mumble is an open source, low-latency, high quality voice chat software"
HOMEPAGE="http://mumble.info/"

LICENSE="BSD MIT"
SLOT="0"
KEYWORDS=""
IUSE="+alsa +dbus debug g15 g15-emulator jack lto multilib optimization +overlay nls pipewire +plugins portaudio pulseaudio qtspeech speech-dispatcher static +system-opus +system-rnnoise +system-speex test zeroconf"
# system-celt

REQUIRED_USE="
	g15-emulator? ( g15 )
"

RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/openssl-1.0.0b:0=
	dev-libs/poco[util,xml,zip]
	>=dev-libs/protobuf-2.2.0:=

	dev-qt/qtcore:5
	dbus? ( dev-qt/qtdbus:5= )
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtsql:5[sqlite]
	qtspeech? ( dev-qt/qtspeech:5 )
	dev-qt/qtsvg:5
	dev-qt/qttranslations:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	dev-qt/qtx11extras:5
	dev-qt/qtxmlpatterns:5
	app-crypt/qca:2=

	g15? ( app-misc/g15daemon )

	>=media-libs/libsndfile-1.0.20[-minimal]
	alsa? ( media-libs/alsa-lib )

	overlay? (
		virtual/opengl
		dev-qt/qtopengl:5
	)
	system-opus? ( >=media-libs/opus-1.3.1 )
	system-speex? (
		>=media-libs/speex-1.2.0
		media-libs/speexdsp
	)
	sys-apps/lsb-release
	jack? ( virtual/jack )
	pipewire? ( media-video/pipewire )
	portaudio? ( media-libs/portaudio )
	pulseaudio? ( || (
		media-sound/apulse
		media-sound/pulseaudio
		media-video/pipewire
	) )
	speech-dispatcher? ( >=app-accessibility/speech-dispatcher-0.8.0 )
	zeroconf? ( net-dns/avahi[mdnsresponder-compat] )
	system-rnnoise? ( media-libs/rnnoise )
"

DEPEND="${RDEPEND}
	dev-qt/qtconcurrent:5
	dev-qt/qttest:5
	>=dev-libs/boost-1.41.0[threads(+)]
	x11-base/xorg-proto
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXi
"
BDEPEND="
	dev-cpp/ms-gsl
	dev-cpp/nlohmann_json
	virtual/pkgconfig
	>=dev-qt/linguist-tools-5.1:5
"

src_unpack() {
	# use system-celt && EGIT_SUBMODULES+=(-celt-0.7.0-src)
	use system-opus || EGIT_SUBMODULES+=(opus)
	use system-speex || EGIT_SUBMODULES+=(3rdparty/speexdsp)
	use system-rnnoise || EGIT_SUBMODULES+=(3rdparty/rnnoise-src)
	git-r3_src_unpack
}

src_prepare() {
	pushd 3rdparty &>/dev/null
		rm -r GL jack pipewire portaudio pulseaudio
		use system-opus || rm -r opus
	   	use system-speex || rm -r speex*
	popd &>/dev/null
	sed \
		-e '/TRACY_ON_DEMAND/s@ ON @ OFF @' \
		-e '/add_subdirectory.*tracy/d' \
		-e '/disable_warnings.*tracy/d' \
		-e '/target_link_libraries.*Tracy/d' \
		-e '/message.*about narrowing/d' \
		-i src/CMakeLists.txt || die
	sed \
		-e '/^assert_is_relative/d' \
		-i cmake/install-paths.cmake
	sed \
		-e '/3rdparty\//d' \
		-i scripts/generate_license_header.py
	use pipewire && {
		append-cxxflags "-I/usr/include/pipewire-0.3"
		append-cxxflags "-I/usr/include/spa-0.2"
	}
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
		-Doverlay=$(useb overlay)
		-Dplugins=$(useb plugins)
		-Ddbus=$(useb dbus)
		-Dzeroconf=$(useb zeroconf)

		# client
		-Dupdate=OFF
		-Dwarnings-as-errors=OFF
		-Dtests="$(useb test)"
		# -Dtests="$(useb lto)"
		-Dtracy="OFF"

		# -Dbundled-celt=ON
		# -Dbundled-celt=$(useb !system-celt)
		-Drnnoise=ON # fails with 'off' O_o (maybe submodules?)
		-Dbundled-rnnoise="$(useb !system-rnnoise)"
		-Dbundled-opus=$(useb !system-opus)
		-Dbundled-speex=$(useb !system-speex)
		-Dbundled-json=OFF
		-Dbundled-gsl=OFF

		-Dspeechd=$(useb speech-dispatcher)
		-Dqtspeech=$(useb qtspeech)

		-Dplugin-debug=$(useb debug)
		-Dplugin-callback-debug=$(useb debug)

		-Dalsa=$(useb alsa)
		-Dpipewire=$(useb pipewire)
		-Dpulseaudio=$(useb pulseaudio)
		-Djackaudio=$(useb jack)
		-Dportaudio=$(useb portaudio)
		# -Dxinput2=ON

		-Dg15=$(useb g15)
		$(usex g15 "-Dg15-emulator=$(useb g15-emulator)" "")

		-Dtranslations="$(usex nls)"

		-Dclient=ON
		-Dserver=OFF # separate package
		# -Ddisplay-install-paths=ON
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install
	if use amd64 && use multilib ; then
		# The 32bit overlay library gets built when multilib is enabled.
		# Install it into the correct 32bit lib dir.
		local libdir_64="/usr/$(get_libdir)/mumble"
		local libdir_32="/usr/$(get_abi_LIBDIR x86)/mumble"
		dodir ${libdir_32}
		mv "${ED}"/${libdir_64}/libmumbleoverlay.x86.so* \
			"${ED}"/${libdir_32}/ || die
	fi
	einstalldocs
}

pkg_postinst() {
	xdg_pkg_postinst
	echo
	elog "Visit https://wiki.mumble.info/ for futher configuration instructions."
	elog "Run 'mumble-overlay <program>' to start the OpenGL overlay (after starting mumble)."
	echo
}
