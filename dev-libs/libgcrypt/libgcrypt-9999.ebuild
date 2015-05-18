# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from mva overlay; $

EAPI="5"

inherit git-2 autotools eutils

DESCRIPTION="General purpose crypto library based on the code used in GnuPG"
HOMEPAGE="http://www.gnupg.org/"
#SRC_URI="mirror://gentoo/${P}-idea.patch.bz2"
SRC_URI=""
EGIT_REPO_URI="git://git.gnupg.org/${PN}.git"
#EGIT_BOOTSTRAP="./autogen.sh"

LICENSE="LGPL-2.1 MIT"
SLOT="0"
KEYWORDS=""
IUSE="static-libs +doc"

RDEPEND="~dev-libs/libgpg-error-9999"
DEPEND="${RDEPEND}
	doc? ( media-gfx/transfig )"

DOCS=( AUTHORS ChangeLog NEWS README THANKS TODO )

src_prepare() {
	epatch "${FILESDIR}"/${PN}-multilib-syspath.patch
#	epatch "${FILESDIR}"/${P}-uscore.patch
#	epatch "${WORKDIR}"/${P}-idea.patch
	epatch_user
	git-2-src_prepare
	eautoreconf
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
