# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 autotools multilib-minimal

DESCRIPTION="a library for manipulating MPQ archives, used in Blizzard games"
HOMEPAGE="https://libmpq.org/"
EGIT_REPO_URI="https://github.com/msva/${PN}"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	app-arch/bzip2
	sys-libs/zlib
"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -r \
		-e '/raise.*,.*"/s@^(.*raise [[:alpha:]]*Error), ("[^"]*")$@\1(\2)@' \
		-e 's@print (.*)@print(\1)@' \
		-i bindings/python/mpq.py
	default
	eautoreconf
	multilib_copy_sources
}
