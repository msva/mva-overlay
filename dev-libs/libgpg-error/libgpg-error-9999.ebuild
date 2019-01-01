# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 eutils autotools

DESCRIPTION="Contains error handling functions used by GnuPG software"
HOMEPAGE="http://www.gnupg.org/related_software/libgpg-error"
SRC_URI=""
EGIT_REPO_URI="git://git.gnupg.org/${PN}.git"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="common-lisp nls static-libs"

RDEPEND="nls? ( virtual/libintl )"
DEPEND="nls? ( sys-devel/gettext )"

DOCS=( AUTHORS ChangeLog NEWS README )

src_prepare() {
	default
	epunt_cxx
	eautoreconf
}

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
