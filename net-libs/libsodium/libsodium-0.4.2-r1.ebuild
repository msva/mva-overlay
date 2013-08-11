# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="A portable fork of NaCl, a higher-level cryptographic library"
HOMEPAGE="https://github.com/jedisct1/libsodium"
SRC_URI="https://download.libsodium.org/${PN}/releases/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+asm +urandom"

src_prepare() {
	epatch "${FILESDIR}"/${P}-fix-stack.patch
}

src_configure() {
		econf \
			$(use_enable asm) \
			$(use_enable !urandom blocking-random)
}
