# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 eutils autotools

DESCRIPTION="X.509 and CMS (PKCS#7) library"
HOMEPAGE="http://www.gnupg.org/related_software/libksba"
#SRC_URI="ftp://ftp.gnupg.org/gcrypt/${PN}/${P}.tar.bz2"
SRC_URI=""
EGIT_REPO_URI="git://git.gnupg.org/${PN}.git"
#EGIT_BOOTSTRAP="./autogen.sh"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
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
