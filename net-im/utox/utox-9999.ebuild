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
IUSE="audio video"

RDEPEND="
	net-im/tox-core
	audio? (
		media-libs/openal
		net-im/tox-core[opus]
		)
	video? (
		media-libs/libv4l
		)
"
DEPEND="${RDEPEND}"

src_install() {
	emake DESTDIR="${D}/usr" install
}

