# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libassuan/libassuan-2.0.3.ebuild,v 1.2 2012/05/09 15:19:16 aballier Exp $

EAPI=4

inherit git-2

DESCRIPTION="GnuPG's New Portable Threads Library (nPth)"
HOMEPAGE="http://www.gnupg.org/"
SRC_URI=""
EGIT_REPO_URI="git://git.gnupg.org/${PN}.git"
EGIT_BOOTSTRAP="./autogen.sh"

LICENSE="GPL-3 LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="static-libs"

RDEPEND="~dev-libs/libgpg-error-9999"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS ChangeLog NEWS README )

S="${WORKDIR}"

src_configure() {
	econf $(use_enable static-libs static) --enable-maintainer-mode
}

src_install() {
	default
	rm -f "${ED}"usr/lib*/${PN}.la
}
