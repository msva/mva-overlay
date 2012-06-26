# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libgcrypt/libgcrypt-1.5.0-r2.ebuild,v 1.3 2012/05/21 18:52:09 xarthisius Exp $

EAPI="4"

inherit git-2 eutils

DESCRIPTION="General purpose crypto library based on the code used in GnuPG"
HOMEPAGE="http://www.gnupg.org/"
#SRC_URI="mirror://gentoo/${P}-idea.patch.bz2"
SRC_URI=""
EGIT_REPO_URI="git://git.gnupg.org/${PN}.git"
EGIT_BOOTSTRAP="./autogen.sh"

LICENSE="LGPL-2.1 MIT"
SLOT="0"
KEYWORDS=""
IUSE="static-libs +doc"

RDEPEND="~dev-libs/libgpg-error-9999"
DEPEND="${RDEPEND}
	doc? ( media-gfx/transfig )"

DOCS=( AUTHORS ChangeLog NEWS README THANKS TODO )

src_prepare() {
#	epatch "${FILESDIR}"/${P}-uscore.patch
	epatch "${FILESDIR}"/${PN}-multilib-syspath.patch
#	epatch "${WORKDIR}"/${P}-idea.patch
	git-2-src_prepare;
}

src_configure() {
	# --disable-padlock-support for bug #201917
	econf \
		--disable-padlock-support \
		--disable-dependency-tracking \
		--enable-noexecstack \
		--disable-O-flag-munging \
		--enable-maintainer-mode \
		$(use_enable static-libs static)
}

src_install() {
	default
	use static-libs || find "${D}" -name '*.la' -delete
}
