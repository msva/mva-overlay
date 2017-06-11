# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils git-r3

EGIT_REPO_URI="https://gerrit-ring.savoirfairelinux.com/ring-daemon"

IUSE="+alsa +dbus doc graph +gsm +hwaccel ipv6 jack -libav +libilbc +nat-pmp +opus portaudio +pulseaudio -restbed +ringns +sdes +speex +speexdsp +upnp +vaapi vdpau +video +vorbis +vpx +x264 system-gnutls system-pjproject"
KEYWORDS=""

DESCRIPTION="Ring daemon"
HOMEPAGE="https://tuleap.ring.cx/projects/ring"

LICENSE="GPL-3"

SLOT="0"

RDEPEND="
	system-gnutls? ( >=net-libs/gnutls-3.4.14 )
	system-pjproject? ( >=net-libs/pjproject-2.5.5:2/9999 )

	>=dev-cpp/yaml-cpp-0.5.3

	>=dev-libs/boost-1.61.0
	>=dev-libs/crypto++-5.6.5
	>=dev-libs/jsoncpp-1.7.2

	>=media-libs/libsamplerate-0.1.8
	>=media-libs/libsndfile-1.0.25[-minimal]

	!libav? ( >=media-video/ffmpeg-3.1.3[encode,gsm?,iconv,libilbc?,opus?,speex?,v4l,vaapi?,vdpau?,vorbis?,vpx?,x264?,zlib] )
	libav? ( >=media-video/libav-12:0=[encode,gsm?,opus?,speex?,v4l,vaapi?,vdpau?,vorbis?,vpx?,x264?,zlib] )

	libilbc? ( media-libs/libilbc )
	speex? ( >=media-libs/speex-1.2.0 )
	speexdsp? ( >=media-libs/speexdsp-1.2_rc3 )

	>=net-libs/opendht-1.3.1
	>=sys-libs/zlib-1.2.8
		x11-libs/libva

	alsa? ( media-libs/alsa-lib )
	jack? ( virtual/jack )
	portaudio? ( >=media-libs/portaudio-19_pre20140130 )
	pulseaudio? ( media-sound/pulseaudio[alsa?,libsamplerate] )

	dbus? ( dev-libs/dbus-c++ )
	ringns? ( >=net-libs/restbed-4.5 )
	restbed? ( >=net-libs/restbed-4.5 )
	sdes? ( >=dev-libs/libpcre-8.40 )
	video? ( virtual/libudev )

	nat-pmp? ( net-libs/libnatpmp )
	upnp? ( >=net-libs/libupnp-1.6.19:= )
"

DEPEND="
	${RDEPEND}
	doc? (
		graph? ( app-doc/doxygen[dot] )
		!graph? ( app-doc/doxygen )
	)
"

REQUIRED_USE="dbus? ( sdes )
	graph? ( doc )
	hwaccel? ( video )
	restbed? ( sdes video )
	vaapi? ( hwaccel )
	?? ( dbus restbed )
"

src_configure() {
	rm -rf ../client-*

	cd contrib

	# remove stable unbundled libraries
	# and folders for other OSes like android
	rm -r src/{asio,boost,cryptopp,ffmpeg,flac,gcrypt,gmp,gpg-error,gsm,iconv,jack,jsoncpp,libav,msgpack,natpmp,nettle,ogg,opendht,opus,pcre,portaudio,pthreads,restbed,samplerate,sndfile,speex,speexdsp,upnp,uuid,vorbis,vpx,x264,yaml-cpp,zlib}

	for DEP in "gmp" "iconv" "nettle" "opus" "speex" "uuid" "vpx" "x264" "zlib"; do
		sed -i.bak 's/^DEPS_\(.*\) = \(.*\)'${DEP}' $(DEPS_'${DEP}')\(.*\)/DEPS_\1 = \2 \3/g' src/*/rules.mak
		sed -i.bak 's/^DEPS_\(.*\) = \(.*\)'${DEP}'\(.*\)/DEPS_\1 = \2 \3/g' src/*/rules.mak
		sed -i.bak 's/^DEPS_\(.*\) = \(.*\)$(DEPS_'${DEP}')\(.*\)/DEPS_\1 = \2 \3/g' src/*/rules.mak
		sed -i.bak 's/^DEPS_\(.*\) += \(.*\)'${DEP}' $(DEPS_'${DEP}')\(.*\)/DEPS_\1 = \2 \3/g' src/*/rules.mak
		sed -i.bak 's/^DEPS_\(.*\) += \(.*\)'${DEP}'\(.*\)/DEPS_\1 = \2 \3/g' src/*/rules.mak
		sed -i.bak 's/^DEPS_\(.*\) += \(.*\)$(DEPS_'${DEP}')\(.*\)/DEPS_\1 = \2 \3/g' src/*/rules.mak
	done

	if use system-gnutls; then
		rm -r src/gnutls
	fi

	if use system-pjproject; then
		rm -r src/pjproject
	fi

	# if system library is installed, then bundled will be ignored even with !system-
	if ! use system-gnutls || ! use system-pjproject ; then
		mkdir -p build
		cd build
		../bootstrap || die "Bootstrap of bundled libraries failed"

		make || die "Bundled libraries could not be compiled"
		cd ../..
	else
		cd ..
	fi

	# patch jsoncpp include
	grep -rli '#include <json/json.h>' . | xargs -i@ sed -i 's/#include <json\/json.h>/#include <jsoncpp\/json\/json.h>/g' @
	./autogen.sh || die "Autogen failed"

	#opensl is android stuff (OpenSLES)
	econf \
		--without-opensl \
		$(use_with alsa alsa ) \
		$(use_with dbus dbus) \
		$(use_with gsm gsm) \
		$(use_with jack jack) \
		$(use_with libilbc libilbc) \
		$(use_with nat-pmp natpmp) \
		$(use_with opus opus) \
		$(use_with portaudio portaudio) \
		$(use_with pulseaudio pulse ) \
		$(use_with restbed restcpp) \
		$(use_with sdes sdes) \
		$(use_with speex speex) \
		$(use_with speexdsp speexdsp) \
		$(use_with upnp upnp) \
		$(use_enable doc doxygen) \
		$(use_enable graph dot) \
		$(use_enable hwaccel accel) \
		$(use_enable ipv6 ipv6) \
		$(use_enable ringns ringns) \
		$(use_enable vaapi vaapi) \
		$(use_enable video video)
	sed -i.bak 's/LIBS = \(.*\)$/LIBS = \1 -lopus /g' bin/Makefile
}

src_install() {
	use doc && HTML_DOCS=( "${S}/doc/doxygen/core-doc/" )
	use !doc && rm  "${S}"/{AUTHORS,ChangeLog,NEWS,README}
	default
	prune_libtool_files --all
}
