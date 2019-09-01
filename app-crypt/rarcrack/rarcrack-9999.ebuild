# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 eutils toolchain-funcs flag-o-matic

DESCRIPTION="Bruteforce algorithm to find correct password of zip, rar and 7z archives"
HOMEPAGE="http://rarcrack.sourceforge.net/"
EGIT_REPO_URI="https://git.code.sf.net/p/rarcrack/code"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="GPL-2"
IUSE=""

RDEPEND="dev-libs/libxml2"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	tc-export CC
	append-cflags "-Wno-unused-result -Wno-maybe-uninitialized -Wno-deprecated-declarations"
	sed -r \
		-e 's/(install) -s/\1/' \
		-i Makefile
}

src_install()  {
	emake PREFIX="${ED}/usr" install
}
