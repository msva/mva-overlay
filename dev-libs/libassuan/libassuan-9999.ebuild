# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 autotools

DESCRIPTION="IPC library used by GnuPG and GPGME"
HOMEPAGE="http://www.gnupg.org/related_software/libassuan/index.en.html"
EGIT_REPO_URI="https://dev.gnupg.org/source/libassuan.git"

LICENSE="GPL-3 LGPL-2.1"
SLOT="0"
IUSE="static-libs"

RDEPEND=">=dev-libs/libgpg-error-1.8"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS ChangeLog NEWS README THANKS TODO )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static) --enable-maintainer-mode
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
