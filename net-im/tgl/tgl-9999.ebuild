# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

inherit git-r3 flag-o-matic

DESCRIPTION="Telegram library"
HOMEPAGE="https://github.com/vysheng/tgl"

EGIT_REPO_URI="https://github.com/vysheng/tgl.git"
EGIT_BRANCH="master"

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE="gcrypt +libevent"

DEPEND="
	virtual/zlib
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
