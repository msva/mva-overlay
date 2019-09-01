# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs git-r3

EGIT_REPO_URI="https://github.com/jorisvink/${PN}.git"

DESCRIPTION="A fast SPDY capable webserver for web development in C"
HOMEPAGE="https://kore.io/"

LICENSE="ISC"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	dev-libs/openssl:*
	sys-libs/zlib
"
RDEPEND="${DEPEND}"

src_prepare() {
	sed \
		-e 's/CC=gcc/CC?=gcc/' \
		-i Makefile || die
	default
}

src_compile() {
	tc-export CC
	emake linux
}

src_install() {
	dodoc -r docs
	dobin kore
}
