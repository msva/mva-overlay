# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit toolchain-funcs

DESCRIPTION="Quote arguments or standard input for usage in POSIX shell by eval"
HOMEPAGE="https://github.com/vaeth/quoter/"
SRC_URI="https://github.com/vaeth/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

src_compile() {
	emake CC="$(tc-getCC)" EPREFIX="${EPREFIX}"
}

src_install() {
	emake DESTDIR="${ED}" EPREFIX="${EPREFIX}" install
	dodoc README.md
}
