# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 autotools

DESCRIPTION="X.509 and CMS (PKCS#7) library"
HOMEPAGE="http://www.gnupg.org/related_software/libksba"
EGIT_REPO_URI="https://dev.gnupg.org/source/${PN}.git"

LICENSE="GPL-3"
SLOT="0"
IUSE="static-libs"

DEPEND="~dev-libs/libgpg-error-9999"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static) --enable-maintainer-mode
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	find "${ED}" -name "*.la" -print0 | xargs -0 rm -f
	dodoc AUTHORS ChangeLog NEWS README THANKS TODO || die "dodoc failed"
}
