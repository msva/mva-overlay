# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 autotools

DESCRIPTION="General purpose crypto library based on the code used in GnuPG"
HOMEPAGE="http://www.gnupg.org/"
EGIT_REPO_URI="https://dev.gnupg.org/source/${PN}.git"

LICENSE="LGPL-2.1 MIT"
SLOT="0"
IUSE="static-libs +doc"

RDEPEND="~dev-libs/libgpg-error-9999"
DEPEND="${RDEPEND}
	doc? ( media-gfx/transfig )"

DOCS=( AUTHORS ChangeLog NEWS README THANKS TODO )

PATCHES="${FILESDIR}/${PN}-multilib-syspath.patch"

src_prepare() {
	default
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
