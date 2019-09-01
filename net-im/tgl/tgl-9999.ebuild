# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 toolchain-funcs flag-o-matic

EGIT_REPO_URI="https://github.com/vysheng/tgl.git"
EGIT_BRANCH="master"

IUSE="gcrypt +libevent"
DESCRIPTION="Telegram library"
HOMEPAGE="https://github.com/vysheng/tgl"
LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS=""

DEPEND="
	sys-libs/zlib
	!gcrypt? ( dev-libs/openssl )
	gcrypt? ( dev-libs/libgcrypt )
	libevent? ( dev-libs/libevent )
"

src_configure() {
	local myeconfargs=();
	append-ldflags '-Wl,-soname,libtgl.so'
	myeconfargs+=( $(use_enable libevent) )
	use gcrypt && myeconfargs+=( "--disable-openssl" )
	econf ${myeconfargs[@]}
}

src_install() {
	dolib.a libs/lib${PN}.a
	dolib.so libs/lib${PN}.so
}
