# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools multilib-minimal git-r3

DESCRIPTION="Barcode data matrix reading and writing library"
HOMEPAGE="http://www.libdmtx.org/"
SRC_URI=""

EGIT_REPO_URI="https://github.com/dmtx/libdmtx"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="static-libs"

src_prepare() {
	default
	eautoreconf
	multilib_copy_sources
}

multilib_src_configure() {
	local myeconfargs=(
		$(use_enable static-libs static)
	)
	econf ${myeconfargs}
}

multilib_src_install() {
	default
	find "${ED}" -name '*.la' -exec rm -f {} +
}
