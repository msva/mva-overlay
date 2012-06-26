# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libgpg-error/libgpg-error-1.10-r1.ebuild,v 1.3 2012/04/26 15:57:07 aballier Exp $

EAPI="4"

inherit git-2 eutils

DESCRIPTION="Contains error handling functions used by GnuPG software"
HOMEPAGE="http://www.gnupg.org/related_software/libgpg-error"
SRC_URI=""
EGIT_REPO_URI="git://git.gnupg.org/${PN}.git"
EGIT_BOOTSTRAP="./autogen.sh"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="common-lisp nls static-libs"

RDEPEND="nls? ( virtual/libintl )"
DEPEND="nls? ( sys-devel/gettext )"

src_prepare() {
#	epatch "${FILESDIR}"/${PN}-multilib-syspaths.patch
	epunt_cxx
	git-2-src_prepare
#	elibtoolize
}

DOCS=( AUTHORS ChangeLog NEWS README )

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_enable static-libs static) \
		$(use_enable common-lisp languages) \
		--enable-maintainer-mode
}

src_install() {
	default

	# library has no dependencies, so it does not need the .la file
	find "${D}" -name '*.la' -delete
}
