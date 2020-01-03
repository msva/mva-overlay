# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

DESCRIPTION="Full screen visualization of the network traffic"
HOMEPAGE="http://soft.risp.ru/trafshow/index_en.shtml"
SRC_URI="ftp://ftp.nsk.su/pub/RinetSoftware/${P}.tgz"

LICENSE="BSD"
SLOT="3"
KEYWORDS="amd64 hppa ~ppc ppc64 sparc x86"
IUSE="slang ipv6"

RDEPEND="
	net-libs/libpcap
	!slang? ( sys-libs/ncurses:0 )
	slang? ( >=sys-libs/slang-1.4 )
"
DEPEND="
	virtual/pkgconfig
	${RDEPEND}
"

PATCHES=( ${FILESDIR}/${P}-{gcc44,gentoo,tinfo}.patch )

src_prepare() {
	cat /usr/share/aclocal/pkg.m4 >> aclocal.m4 || die
	use ipv6 && eapply "${FILESDIR}/${P}-ipv6.patch"
	default
}

src_configure() {
	if ! use slang; then
		# No command-line option so pre-cache instead
		export ac_cv_have_curses=ncurses
		export LIBS="-lncurses"
	fi

	use ipv6 && append_flags "-DINET6"

	econf
}
