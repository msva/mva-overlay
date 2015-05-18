# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from mva overlay; $

EAPI="5"

DESCRIPTION="A command line tool for parsing video download links"
HOMEPAGE="http://quvi.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PV:0:3}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="luajit"

RDEPEND="
	virtual/lua[luajit=]
	>=net-misc/curl-7.18.2
	>=media-libs/libquvi-0.4.0
"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	virtual/pkgconfig"

src_configure() {
	local lua="lua"
	use luajit && lua="luajit"
	export CFLAGS="$CFLAGS $(pkg-config --cflags ${lua})"
	econf \
		--with-manual
}
