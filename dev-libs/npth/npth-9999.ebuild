# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit git-2 eutils autotools

DESCRIPTION="GnuPG's New Portable Threads Library (nPth)"
HOMEPAGE="http://www.gnupg.org/"
SRC_URI=""
EGIT_REPO_URI="git://git.gnupg.org/${PN}.git"
#EGIT_BOOTSTRAP="./autogen.sh"

LICENSE="GPL-3 LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="static-libs"

RDEPEND="~dev-libs/libgpg-error-9999"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS ChangeLog NEWS README )

#S="${WORKDIR}"

src_prepare() {
	epatch_user
	git-2_src_prepare
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static) --enable-maintainer-mode
}

src_install() {
	default
	rm -f "${ED}"usr/lib*/${PN}.la
}
