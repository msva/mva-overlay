# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 multilib-minimal patches

DESCRIPTION="Standards compliant, fast, secure markdown processing library in C"
EGIT_REPO_URI="https://github.com/hoedown/hoedown"

HOMEPAGE="https://github.com/hoedown/hoedown"

LICENSE="MIT"
SLOT="0"

BDEPEND="
	dev-util/gperf
"

src_prepare() {
	patches_src_prepare
	sed -r \
		-e "/^PREFIX/s@(=).*@\1/usr@" \
		-e "/^LIBDIR/s@/lib\$@/$(get_libdir)@" \
		-e "/^install/,\$s@(smartypants)@\1-hoedown@" \
		-e "/^smartypants:/s@(smartypants)@\1-hoedown@" \
		-e "/^all:/s@(smartypants)@\1-hoedown@" \
		-i "${S}"/Makefile
	multilib_copy_sources
}
