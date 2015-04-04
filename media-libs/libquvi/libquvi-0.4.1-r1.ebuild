# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libquvi/libquvi-0.4.1-r1.ebuild,v 1.3 2014/02/23 16:31:00 pacho Exp $

EAPI=5

inherit autotools-utils toolchain-funcs multilib-minimal

DESCRIPTION="Library for parsing video download links"
HOMEPAGE="http://quvi.sourceforge.net/"
SRC_URI="mirror://sourceforge/quvi/${PV:0:3}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0.4"
KEYWORDS="~alpha amd64 ~arm hppa ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE="examples static-libs luajit"

RDEPEND=">=net-misc/curl-7.18.2
	!<media-libs/quvi-0.4.0
	>=media-libs/libquvi-scripts-0.4.21-r1:0.4[${MULTILIB_USEDEP}]
	virtual/lua[luajit,${MULTILIB_USEDEP}]
	!=media-libs/libquvi-0.4*:0"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog NEWS README )

multilib_src_configure() {
	local lua="lua"
	use luajit && lua="luajit"
	export CFLAGS="${CFLAGS} $(pkg-config --cflags ${lua})"
	export liblua_CFLAGS="$(pkg-config --cflags ${lua})"
	export liblua_LIBS="$(pkg-config --variable libdir ${lua})"
	export LDFLAGS="${LDFLAGS} $(pkg-config --libs ${lua})"
	local myeconfargs=(
		--without-manual
	)
	autotools-utils_src_configure
}

multilib_src_install_all() {
	einstalldocs
	prune_libtool_files

	if use examples ; then
		docinto examples
		dodoc examples/*.{c,h}
	fi
}
