# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

EGIT_REPO_URI="https://github.com/notsecure/uTox"

inherit git-r3 toolchain-funcs

DESCRIPTION="Lightweight Tox GUI client"
HOMEPAGE="http://utox.org"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	media-libs/openal
	net-libs/tox[av]
	media-libs/libv4l
	x11-libs/libX11
"
DEPEND="${RDEPEND}"

src_install() {
	emake DESTDIR="${D}/usr" install
}

