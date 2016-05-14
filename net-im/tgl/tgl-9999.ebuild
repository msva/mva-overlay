# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit git-r3 toolchain-funcs flag-o-matic

EGIT_REPO_URI="https://github.com/vysheng/tgl.git"
EGIT_BRANCH="master"

IUSE="gcrypt +libevent"
DESCRIPTION="Command line interface client for Telegram"
HOMEPAGE="https://github.com/vysheng/tgl"
LICENSE="LGPL"
SLOT="0"
KEYWORDS=""

DEPEND="
	sys-libs/zlib
	!gcrypt? ( dev-libs/openssl )
	gcrypt? ( dev-libs/gcrypt )
	libevent? ( dev-libs/libevent )
"

src_configure() {
	append-ldflags '-Wl,-soname,libtgl.so'
	EXTRA_ECONF=($(use_enable libevent))
	default
}

src_install() {
	dolib.a libs/lib${PN}.a
	dolib.so libs/lib${PN}.so
}
