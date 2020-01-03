# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils toolchain-funcs git-r3

DESCRIPTION="Limits the CPU usage of a process"
HOMEPAGE="http://cpulimit.sourceforge.net"
EGIT_REPO_URI="https://github.com/opsengine/cpulimit"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

PATCHES="${FILESDIR}/${P}-makefile.patch"

src_compile() {
	emake CC="$(tc-getCC)" || die "emake failed"
}

src_install() {
	dosbin src/cpulimit
	doman "${FILESDIR}/cpulimit.8"
}
