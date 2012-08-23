# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libquvi/libquvi-0.4.1.ebuild,v 1.4 2012/08/03 08:21:06 hwoarang Exp $

EAPI=4

inherit autotools-utils

DESCRIPTION="Library for parsing video download links"
HOMEPAGE="http://quvi.sourceforge.net/"
SRC_URI="mirror://sourceforge/quvi/${PV:0:3}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="examples static-libs luajit"

RDEPEND=">=net-misc/curl-7.18.2
	!<media-libs/quvi-0.4.0
	>=media-libs/libquvi-scripts-0.4.0
	|| ( >=dev-lang/lua-5.1[deprecated] dev-lang/luajit:2 )"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog NEWS README )

src_configure() {
	LUA="lua"
	use luajit && LUA="luajit"
	export CFLAGS="${CFLAGS} $(pkg-config --cflags ${LUA})"
	export liblua_CFLAGS="$(pkg-config --cflags ${LUA})"
	export liblua_LIBS="$(pkg-config --variable libdir ${LUA})"
	export LDFLAGS="${LDFLAGS} $(pkg-config --libs ${LUA})"
	local myeconfargs=(
		--with-manual
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install

	if use examples ; then
		docinto examples
		dodoc examples/*.{c,h}
	fi
}
