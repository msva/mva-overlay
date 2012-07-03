# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/qutecom/qutecom-2.2_p20110210.ebuild,v 1.9 2012/06/17 01:05:11 chithanh Exp $

EAPI="3"

inherit cmake-utils mercurial eutils flag-o-matic

DESCRIPTION="Multi-protocol instant messenger and VoIP client"
HOMEPAGE="http://www.qutecom.org/"
SRC_URI=""
EHG_REPO_URI="http://hg.qutecom.org/qutecom-3.0"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa debug oss portaudio xv"

RDEPEND="dev-libs/boost
	dev-libs/glib
	dev-libs/openssl
	alsa? ( media-libs/alsa-lib )
	media-libs/libsamplerate
	media-libs/libsndfile
	portaudio? ( media-libs/portaudio )
	media-libs/speex
	net-im/pidgin[gnutls]
	net-libs/gnutls
	>=net-libs/libosip-3
	>=net-libs/libeXosip-3
	net-misc/curl
	virtual/ffmpeg
	x11-libs/libX11
	x11-libs/qt-gui
	x11-libs/qt-svg
	x11-libs/qt-webkit
	xv? ( x11-libs/libXv )"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	media-libs/libv4l
	sys-kernel/linux-headers"


pkg_setup() {
	if has_version "<dev-libs/boost-1.41" && has_version ">=dev-libs/boost-1.41"; then
		ewarn "QuteCom build system may mix up headers and libraries if versions of"
		ewarn "dev-libs/boost both before and after 1.41 are installed. If the build"
		ewarn "fails due to undefined boost symbols, remove older boost."
	fi
	# fails to find its libraries with --as-needed, bug #315045
	append-ldflags $(no-as-needed)
}

#src_prepare() {
#	# do not include gtypes.h, bug #421415
#	sed -i '/gtypes.h/d' libs/imwrapper/src/purple/PurpleIMFactory.h || die
#}

src_configure() {
	local mycmakeargs="$(cmake-utils_use alsa PHAPI_AUDIO_ALSA_SUPPORT)
		$(cmake-utils_use oss PHAPI_AUDIO_OSS_SUPPORT)
		-DLIBPURPLE_INTERNAL=ON
		-DCMAKE_VERBOSE_MAKEFILE=OFF
		-DENABLE_CALL_FORWARD=ON
		-DENABLE_CONFERENCE=ON
		-DENABLE_FILETRANSFER=ON
		-DENABLE_MANUAL_CALL_FORWARD=ON
		-DENABLE_REMOTE_CONTACT_SEARCH=ON
		-DENABLE_SMS=ON
		-DENABLE_VFW=ON
		-DENABLE_VOICE_MAIL=ON
		-DPHAPI_AUDIO_AMR_SUPPORT=ON
		-Wno-dev"
#		-DPORTAUDIO_INTERNAL=OFF
#		$(cmake-utils_use_enable portaudio PORTAUDIO_SUPPORT) #possibly broken
#		$(cmake-utils_use xv QUTECOM_XV_SUPPORT) #broken
#		-DMEDIASTREAMER2_INTERNAL=OFF
#		-DENABLE_FACEBOOK=ON
#		-DENABLE_MYSPACE=ON
#		-DENABLE_SKYPE=ON
#		-DENABLE_TWITTER=ON
#		-DENABLE_QUTECOM_ACCOUNT=ON
#		-DENABLE_QUTECOM_SSO=ON
#		-DOSIP2_INTERNAL=OFF
#		-DORTP_INTERNAL=OFF
#		-DENABLE_CRASHREPORT=ON
#TODO: PA	-DPHAPI_AUDIO_ESD_SUPPORT=ON
#		-DENABLE_UNIT_TEST

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	domenu ${PN}/res/${PN}.desktop || die "domenu failed"
	doicon ${PN}/res/${PN}_64x64.png || die "doicon failed"
	ln -fs qutecom/libmediastreamer2.so /usr/$(get_libdir)/libmediastreamer2.so
}
