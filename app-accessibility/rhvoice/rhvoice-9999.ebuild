# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/iulib/iulib-0.4.ebuild,v 1.7 2012/06/03 02:42:24 vapier Exp $

EAPI="4"

inherit scons-utils eutils toolchain-funcs multilib git-2

DESCRIPTION="A speech synthesizer for Russian language"
HOMEPAGE="https://github.com/Olga-Yakovleva/RHVoice"
SRC_URI=""
EGIT_REPO_URI="git://github.com/Olga-Yakovleva/RHVoice.git"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	dev-lang/python
	app-accessibility/flite
	dev-libs/libunistring
	dev-libs/expat
	dev-libs/libpcre
	media-sound/sox
	dev-util/scons"

src_compile() {
	escons prefix=/usr sysconfdir=/etc
}

src_install() {
	# Dirty hack, since it fails to install with multijob
	SCONSOPTS=""
	escons DESTDIR="${D}" prefix=/usr sysconfdir=/etc install
	dodoc README
}
