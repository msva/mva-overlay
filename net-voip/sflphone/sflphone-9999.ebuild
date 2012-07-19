# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-voip/sflphone/sflphone-1.0.1.ebuild,v 1.3 2012/03/02 14:58:32 elvanor Exp $

EAPI="4"

inherit autotools eutils cmake-utils git-2

DESCRIPTION="SFLphone is a robust standards-compliant enterprise softphone, for desktop and embedded systems."
HOMEPAGE="http://www.sflphone.org/"
EGIT_REPO_URI="http://git.sflphone.org/sflphone.git"
SRC_URI=""
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doxygen dbus gnome +gsm networkmanager +speex +portaudio static-libs iax kde cli celt pulseaudio"

# USE="-iax" does not work in 1.0.1. Upstream problem. (not tested on 1.0.2)

CDEPEND="dev-cpp/commoncpp2
	dev-libs/dbus-c++
	dev-libs/expat
	dev-libs/openssl
	dev-libs/libpcre
	dev-libs/libyaml
	media-libs/alsa-lib
	portaudio? ( media-libs/portaudio )
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

	AT_NO_RECURSIVE=yes

	cd "${S}"/daemon
	eautoreconf

	use gnome && {
		cd "${S}"/gnome
		eautoreconf
# evolution addressbook. Want libebook. Dunno, where to get it.
#		cd "${S}"/plugins
#		eautoreconf

	}

	#remove "target" from lib-names, remove dep to shipped pjsip
#	sed -i -e 's/-$(target)//' \
#		-e '/^\t\t\t-L/ d' \
#		-e 's!include $(src)/libs/pjproject!LDFLAGS+=-I/usr/include!' \
#		"${S}"/daemon/globals.mak || die "sed failed."
#	#respect CXXFLAGS
	sed -i -e 's/CXXFLAGS="-g/CXXFLAGS="-g $CXXFLAGS /' \
		"${S}"/daemon/configure.ac || die "CXX sed failed."

	# Temporary fix of cmake strangeness
	use kde && sed -i -e 's:../src/lib/typedefs.h:../lib/typedefs.h:' \
		"${S}"/kde/src/klib/kcfg_settings.kcfgc || die "kde fix failed."
}

src_configure() {
	cd "${S}"/daemon
	econf $(use_with debug) \
	--enable-video \
	$(use_with pulseaudio pulse) \
	$(use_with gsm) \
	$(use_with networkmanager) \
	$(use_with speex) \
	$(use_enable static-libs static) \
	$(use_enable doxygen) \
	$(use_with iax iax2)

	cd "${S}"/daemon/libs/pjproject
	econf $(use_with speex external-speex) \
	$(use_with gsm external-gsm) \
	$(use_with portaudio external-pa)

	use kde && {
		cd "${S}"/kde
		CMAKE_USE_DIR="${S}/kde"
		CMAKE_IN_SOURCE_BUILD=yes
		cmake-utils_src_configure
	}
	use gnome && {
		cd "${S}"/gnome
		econf
#		cd "${S}"/plugins
#		econf
	}
	use cli && echo "I don't know how to get cli to work :("
}

src_compile() {
	cd "${S}"/daemon/libs/pjproject
	emake -j1 || die "emake failed."
	cd "${S}"/daemon
	emake || die "emake failed."
	use kde && {
		cd "${S}"/kde
		emake || die "emake failed."
	}
	use gnome && {
		cd "${S}"/gnome
		emake || die "emake failed."
#		cd "${S}"/plugins
#		emake || die "emake failed."
	}
}

src_install() {
	cd "${S}"/daemon
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc "${S}"/daemon/test/sflphonedrc-sample
	use kde && {
		cd "${S}"/kde
		emake DESTDIR="${D}" install || die "emake install failed"
	}
	use gnome && {
		cd "${S}"/gnome
		emake DESTDIR="${D}" install || die "emake install failed"
#		cd "${S}"/plugins
#		emake DESTDIR="${D}" install || die "emake install failed"
	}
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
