# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-voip/sflphone/sflphone-1.0.1.ebuild,v 1.3 2012/03/02 14:58:32 elvanor Exp $

EAPI="4"

inherit autotools eutils git-2

DESCRIPTION="SFLphone is a robust standards-compliant enterprise softphone, for desktop and embedded systems."
HOMEPAGE="http://www.sflphone.org/"
EGIT_REPO_URI="http://git.sflphone.org/sflphone.git"
SRC_URI=""
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doxygen dbus gnome gsm networkmanager speex static-libs iax kde cli celt pulseaudio"

# USE="-iax" does not work in 1.0.1. Upstream problem. (not tested on 1.0.2)

CDEPEND="dev-cpp/commoncpp2
	dev-libs/dbus-c++
	dev-libs/expat
	dev-libs/openssl
	dev-libs/libpcre
	dev-libs/libyaml
	media-libs/alsa-lib
	celt? ( media-libs/celt )
	media-libs/libsamplerate
	pulseaudio? ( media-sound/pulseaudio )
	net-libs/ccrtp
	iax? ( net-libs/iax )
	net-libs/libzrtpcpp
	>=net-libs/pjsip-1.8.10
	dbus? ( sys-apps/dbus )
	gsm? ( media-sound/gsm )
	speex? ( media-libs/speex )
	networkmanager? ( net-misc/networkmanager )
	gnome? ( dev-libs/atk
		dev-libs/check
		dev-libs/log4c
		gnome-base/libgnomeui
		gnome-base/orbit:2
		gnome-extra/evolution-data-server
		media-libs/fontconfig
		media-libs/freetype
		media-libs/libart_lgpl
		net-libs/libsoup:2.4
		net-libs/webkit-gtk:3
		x11-libs/cairo
		x11-libs/libICE
		x11-libs/libnotify
		x11-libs/libSM )"

DEPEND="${CDEPEND}
		>=dev-util/astyle-1.24
		doxygen? ( app-doc/doxygen )
		gnome? ( app-text/gnome-doc-utils )"

RDEPEND="${CDEPEND}"

S="${WORKDIR}/${PN}"

src_prepare() {
	if ! use gnome && ! use kde && ! use cli; then
		ewarn "No clients selected. It will be daemon-only installation."
	fi

	sed -i -e 's/unpad=paren/unpad-paren/' astylerc || die "sed failed."
	cd daemon
	#remove "target" from lib-names, remove dep to shipped pjsip
	sed -i -e 's/-$(target)//' \
		-e '/^\t\t\t-L/ d' \
		-e 's!include $(src)/libs/pjproject!LDFLAGS+=-I/usr/include!' \
		globals.mak || die "sed failed."
	#respect CXXFLAGS
	sed -i -e 's/CXXFLAGS="-g/CXXFLAGS="-g $CXXFLAGS /' \
		configure.ac || die "sed failed."
	rm -r libs/pjproject
#	cd libs/pjproject
#	mkdir -p m4
#	eautoreconf
	#workaround:
	mkdir -p m4
	eautoreconf
}

src_configure() {
	cd daemon
	# $(use_with iax iax2) won't work (compilation failure)
	econf
# --disable-dependency-tracking $(use_with debug) \
#		$(use_with gsm) $(use_with networkmanager) $(use_with speex) $(use_enable static-libs static) $(use_enable doxygen) --with-iax
#$(use_with iax iax2) $(use_with celt)
}

src_compile() {
	cd daemon
	emake || die "emake failed."
}

src_install() {
	cd daemon
	emake -j1 DESTDIR="${D}" install || die "emake install failed"
	dodoc test/sflphonedrc-sample
}

pkg_postinst() {
	elog
	elog "You need to restart dbus, if you want to access"
	elog "sflphoned through dbus."
	elog
	elog "If you use the command line client"
	elog "(https://projects.savoirfairelinux.com/repositories/browse/sflphone/tools/pysflphone)"
	elog "extract /usr/share/doc/${PF}/${PN}drc-sample to"
	elog "~/.config/${PN}/${PN}drc for example config."
	elog
	elog
	elog "For calls out of your browser have a look in sflphone-callto"
	elog "and sflphone-handler. You should consider to install"
	elog "the \"Telify\" Firefox addon. See"
	elog "https://projects.savoirfairelinux.com/repositories/browse/sflphone/tools"
	elog
}
